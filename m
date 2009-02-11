Return-Path: <linux-kernel-owner+w=401wt.eu-S1757312AbZBKO7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbZBKO7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 09:59:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755452AbZBKO70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 09:59:26 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:22963 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700AbZBKO7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 09:59:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aCaMyl5fm9Zo/bPNpUdM8GS9WKNeWXHL5H98SwDRcrqyqwXsD54QRgHTvBVGoOxlU9
         cyDGjVp/0LLMoRwyr6H0fIpLXdtnyX83n3EMV3otjlUN5khCiBUuEt1BKbAsSW4dnpcM
         AjkOSzd5VUK2TxOBOQ9yVaDQ2NrR8pDEk2mSc=
MIME-Version: 1.0
In-Reply-To: <4992E551.4060901@gmail.com>
References: <1234277507-4987-1-git-send-email-brgerst@gmail.com>
	 <1234277507-4987-3-git-send-email-brgerst@gmail.com>
	 <4992812B.1050800@kernel.org>
	 <73c1f2160902110631j68e58202h3e49288cfe613d66@mail.gmail.com>
	 <4992E396.6000205@kernel.org> <4992E551.4060901@gmail.com>
Date: Wed, 11 Feb 2009 09:59:23 -0500
Message-ID: <73c1f2160902110659i776e1d89qc23d89363881572e@mail.gmail.com>
Subject: Re: [PATCH 2/3] x86: Pass in pt_regs pointer for syscalls that need 
	it
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 9:48 AM, Tejun Heo <htejun@gmail.com> wrote:
> Tejun Heo wrote:
>>> I checked the disassembly of these functions and didn't see this
>>> happen on gcc 4.3.0.
>>
>> Well, tracking down why run_init_process() is returning 0 with
>> -fstack-protector wasn't much of fun.  These breakages are very subtle
>> and if we're gonna pass in pointer to pt_regs anyway and thus can
>> guarantee such breakage can't happen at no additional cost, I think we
>> should do that even if it means slightly more argument fetching in a
>> few places.
>
> In addition, if we do that, we can remove the horrible
> asmlinkage_protect() thing altogether.

Like I said before, the tail-call optimization problem isn't limited
to just this set of syscalls.  There are only two real ways to fix it.
 1) Set up a real stack frame for the syscalls instead of overalying
pt_regs, or 2) patch gcc to tell it not to touch the args area of the
stack.

--
Brian Gerst
