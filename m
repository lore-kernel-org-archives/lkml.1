Return-Path: <linux-kernel-owner+w=401wt.eu-S1759817AbYAULbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759817AbYAULbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 06:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758700AbYAULbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 06:31:33 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:65184 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758033AbYAULbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 06:31:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type;
        b=QV0EEMa3xIOn471IjkL1DtvZsXVH/k4a2pdOE7puQhZ/WAP/stFJKz4sdxDdzAnPH5leb4qxv3w/EQC2E+VWb1JNWkWFbdWCH1zTqvF//K4Vfx5LN8zBbRG0hlBLDPzM48h+T1wBYg0KNLHXd1kPpts/MOUGnQDGzsjSdaFKJbA=
Date: Mon, 21 Jan 2008 12:31:20 +0100 (CET)
From: Esben Nielsen <nielsen.esben@googlemail.com>
X-X-Sender: simlo@frodo.shire
To: Steven Rostedt <rostedt@goodmis.org>
cc: Valdis.Kletnieks@vt.edu, caglar@pardus.org.tr,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.24-rc7-rt2
In-Reply-To: <Pine.LNX.4.58.0801161112140.15998@gandalf.stny.rr.com>
Message-ID: <Pine.LNX.4.64.0801211223210.11032@frodo.shire>
References: <1200336080.318.8.camel@localhost.localdomain>
 <200801150237.44029.caglar@pardus.org.tr> <24149.1200455417@turing-police.cc.vt.edu>
            <Pine.LNX.4.58.0801152302580.10869@gandalf.stny.rr.com>
 <31516.1200464589@turing-police.cc.vt.edu> <Pine.LNX.4.58.0801160904200.9544@gandalf.stny.rr.com>
 <Pine.LNX.4.58.0801161112140.15998@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 16 Jan 2008, Steven Rostedt wrote:

>
> On Wed, 16 Jan 2008, Steven Rostedt wrote:
>>
>> We modified mcount now, and it is derived from an objdump of glibc. So
>> this is most definitely a "derived" work from glibc. But glibc is licensed
>> as LGPL, which IIRC allows for non GPL to link to it.
>>
>> I personally could care less if we use EXPORT_SYMBOL or EXPORT_SYMBOL_GPL.
>> But I really want to do The Right Thing(tm). I'm not a lawyer and don't
>> claim that I know anything about the law, but I'm leaning towards the non
>> _GPL version because the code was from LGPL and not from strict GPL.
>
> Sorry folks, I'm going to stick with the _GPL version. It doesn't mean
> that you can't still load your nVidia module into -rt. I just means you
> can't turn on function trace and then load it. Well, you might if you
> don't compile the nVidia wrapper against it with function trace on.
>
> The reason simply is to cover my butt.  By limiting it to GPL, I'm fine.
> Even if the original author didn't care. But by opening it up to external
> prorietary modules, I may be considered infringing on the license.
>
> So, unless I hear from a lawyer that is willing to back me up on a non
> _GPL export publically, the mcount function will stay as an
> EXPORT_SYMBOL_GPL.
>
> Note: There is a definite reason for this change. The previous version
> of mcount was written by Ingo Molnar, and he added the export. I've
> changed mcount to be closer to the glibc code (which I derived it from),
> so the change in EXPORT type is legitimate.
>
> -- Steve


Please, tell what in the license forbids me to make a global replacement
EXPORT_SYMBOL_GPL -> EXPORT_SYMBOL and distribute the result?

For me, on the other hand, it is against the spirit of free software to 
actively make a block for people to do what ever they want with the code 
when they are only doing it to themselves. That includes loading non-GPL 
software into the kernel. The only thing they  are not allowed to do is to
distribute it and in that way "hurt" other people.

Esben


> -
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
