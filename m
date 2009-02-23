Return-Path: <linux-kernel-owner+w=401wt.eu-S1753764AbZBWKVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbZBWKVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 05:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbZBWKVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 05:21:08 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:54878 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbZBWKVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 05:21:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ua4a1MkJDtYVO4HRgzj/8dDGQx5QSjhy6UWuz/G47/fzyx+PPkEG6XQLmvy88/lFdV
         onFWBsZxZJMm53FVq+/8fWhwcFfwFb/NaWZDP0dqrH9iv/te8lBNT/Kcpg+SXKxnPyv6
         LIQra2HXOvJDh+J3fPNk8iZpsqV7knR1xwK8M=
MIME-Version: 1.0
In-Reply-To: <20090222162234.GA6003@nowhere>
References: <b9df5fa10902131936p5e0997c6p57f659457a9cc356@mail.gmail.com>
	 <20090221152251.GA6807@nowhere>
	 <b9df5fa10902220533rb625291k135b3218151e12e5@mail.gmail.com>
	 <20090222162234.GA6003@nowhere>
Date: Mon, 23 Feb 2009 11:21:04 +0100
Message-ID: <a430082a0902230221p4f128073id93b5d5d4184ddf1@mail.gmail.com>
Subject: Re: [PATCH -mm] tracing: Fix section mismatch in trace_hw_branches.c
From: Markus Metzger <markus.t.metzger@googlemail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Rakib Mullick <rakib.mullick@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, markus.t.metzger@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 5:22 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Sun, Feb 22, 2009 at 07:33:08PM +0600, Rakib Mullick wrote:
>> On 2/21/09, Frederic Weisbecker <fweisbec@gmail.com> wrote:

>> >  So, unless I missed something, this patch seems to me very dangerous.
>> >  The init and reset callbacks of a tracer can be called at any time, not only
>> >  on initcalls time (__init functions are freed from memory after the middle stage
>> >  of the boot).
>> >  With this patch, on UP we will dereference freed memory while activating this tracer.
>> If the init and reset callbacks of a tracer can be called regardless
>> of cpu hotpluging then it is. If the tracer's init or reset doesn't
>> rely on cpuhotplug then it shouldn't use it.
>> There's a another way to fix the warning is by remove __cpuinitdata
>> from bts_hotcpu_notifier.
[...]
> But removing __cpuinitdata will mean a kind of waste of memory (though it's only
> a little struct).

Plus the hotplug handler function. It's still not much.

I'll send out a patch following Frederic's suggestion to register the
hotplug notifier once in init.

thanks and regards,
markus.
