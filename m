Return-Path: <linux-kernel-owner+w=401wt.eu-S1757237AbZIEJ5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbZIEJ5n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 05:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757055AbZIEJ5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 05:57:41 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:59334 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbZIEJ5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 05:57:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=o/XZf3/7GujpNmrfF2IcPrkc+dZ3cKFfkDFe49H4k4TUBaWG3hl6x3W4d/N7UQrqWW
         XYFMwZHMaaSfVYW/sVRWeb6Nu90tWYNxLLZcasd3UgkqDv23laku27qc4/mPpZRer2n7
         8FiXeLLcLeOHxJRVvECYLy/diBvNiRLl+tLLo=
Date: Sat, 5 Sep 2009 11:57:36 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/cpu] x86, msr: change msr-reg.o to obj-y, and export
 its symbols
Message-ID: <20090905095736.GA5005@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, linux-tip-commits@vger.kernel.org
References: <20090904140834.GA15789@elte.hu>
 <tip-b19ae3999891cad21a3995c34d313dda5df014e2@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <tip-b19ae3999891cad21a3995c34d313dda5df014e2@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 05:06:47PM +0000, tip-bot for H. Peter Anvin wrote:
> x86, msr: change msr-reg.o to obj-y, and export its symbols
> 
> Change msr-reg.o to obj-y (it will be included in virtually every
> kernel since it is used by the initialization code for AMD processors)

Yeah, about that, I'm wondering whether a more fine grained
Kconfig suboptions would be appropriate here. Currently,
<arch/x86/kernel/cpu/{intel,amd}.c> are sprinkled with the

if (c->x86 == XX) { apply quirks }

thingies and we could put those into their own files which are
built/linked only when enabled. Before that, you would have chosen
the CPU vendor and the CPU family thus pulling only the related
quirks/fixes. Distros will of course need to enable all of them. Then,
all those different families quirks should be iterated over in a manner
similar to the initcall mechanism.

Anyways, just an idea - it could be dumb overengineering but on a
first glance it will organize/simplify the quirks code, reduce kernel
image proper, get rid of Kconfig options like CONFIG_X86_F00F_BUG,
vendor-specific cpuinfo_x86 members like fdiv_bug, f00f_bug, coma_bug,
and [add another good reason here :)].

Comments?

-- 
Regards/Gruss,
    Boris.
