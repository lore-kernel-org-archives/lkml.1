Return-Path: <linux-kernel-owner+w=401wt.eu-S1757053AbZBKOtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053AbZBKOtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 09:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754240AbZBKOtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 09:49:08 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:17936 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbZBKOtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 09:49:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=IUrXRlp0rlIaDYY2SgMZ4VW84PaYlQeCphN+vqF7UW2T+DnHZ7s8gMH0h1t/Z7I50v
         EvyauOhPEAJtrMAw0dRptGnGqY3JAgYpb06ObpVv0WnpxAmnDKyi7JhnzE2lf0Jqq2Bq
         ZioqGeSqtAMZjWyQXYwrFXZPMpN0De9th76LM=
Message-ID: <4992E551.4060901@gmail.com>
Date: Wed, 11 Feb 2009 23:48:49 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: Pass in pt_regs pointer for syscalls that need
 	it
References: <1234277507-4987-1-git-send-email-brgerst@gmail.com>	 <1234277507-4987-3-git-send-email-brgerst@gmail.com>	 <4992812B.1050800@kernel.org> <73c1f2160902110631j68e58202h3e49288cfe613d66@mail.gmail.com> <4992E396.6000205@kernel.org>
In-Reply-To: <4992E396.6000205@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
>> I checked the disassembly of these functions and didn't see this
>> happen on gcc 4.3.0.
> 
> Well, tracking down why run_init_process() is returning 0 with
> -fstack-protector wasn't much of fun.  These breakages are very subtle
> and if we're gonna pass in pointer to pt_regs anyway and thus can
> guarantee such breakage can't happen at no additional cost, I think we
> should do that even if it means slightly more argument fetching in a
> few places.

In addition, if we do that, we can remove the horrible
asmlinkage_protect() thing altogether.

-- 
tejun
