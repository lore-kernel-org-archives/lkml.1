Return-Path: <linux-kernel-owner+w=401wt.eu-S1161352AbXCGJDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161352AbXCGJDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 04:03:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161357AbXCGJD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 04:03:29 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47963 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161344AbXCGJDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 04:03:25 -0500
Date: Wed, 7 Mar 2007 10:03:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: devzero@web.de
Cc: Lee Revell <rlrevell@joe-job.com>, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] BadRAM still not ready for inclusion ? (was: Re: Free Linux Driver Development!)
Message-ID: <20070307090311.GA4285@elf.ucw.cz>
References: <1667859354@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1667859354@web.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >What's so hard about submitting a 200 line patch to LKML?
> 
> that's what i was wondering about ;D
> it's not the first time, that i see nice features not being submitted to lkml.
> 
> anyway - pavel (thanks btw!) just pointed me to some param "mem=exactmap" :
> 
> >I think functionality is there in latest vanila with mem=exactmap even
> >w/o patches.
> 
> so, maybe we need to find out _if_ and _how_ this could make BadRAM obsolete (i.e. if this is a good alternative) ?
> (so we won't need to discuss about BadRAM inclusion anymore. :)
> 
> what i found is:
> 
> 894         memmap=exactmap [KNL,IA-32,X86_64] Enable setting of an exact
> 895                         E820 memory map, as specified by the user.
> 896                         Such memmap=exactmap lines can be constructed based on
> 897                         BIOS output or other requirements. See the memmap=nn@ss
> 898                         option description.
> 899 
> 900         memmap=nn[KMG]@ss[KMG]
> 901                         [KNL] Force usage of a specific region of memory
> 902                         Region of memory to be used, from ss to ss+nn.
> 903 
> 904         memmap=nn[KMG]#ss[KMG]
> 905                         [KNL,ACPI] Mark specific memory as ACPI data.
> 906                         Region of memory to be used, from ss to ss+nn.
> 907 
> 908         memmap=nn[KMG]$ss[KMG]
> 909                         [KNL,ACPI] Mark specific memory as reserved.
> 910                         Region of memory to be used, from ss to ss+nn.

>  this indeed looks like something being able to replace BadRAM, but
> the question is, how to handle/enable that and how to translate
> BadRAM patterns from memtest86 to be usable. (i.e.: writing a HowTo
> for the average user not being a kernel wizard) 

Writing a howto, or maybe writting a shellscript to do a translation
:-). It will not be trivial, but certainly better than trying to push
the badram patch. Good luck ;-).

(e820 map is available from dmesg after boot, and perhaps from other
places. First, you'll need to duplicate it on cmdline using
memmap=... arguments. Then, if bad ram is in the middle of something,
you'll need to split memmap= accordingly).
								Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
