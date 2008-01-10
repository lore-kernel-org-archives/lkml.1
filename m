Return-Path: <linux-kernel-owner+w=401wt.eu-S1760011AbYAJP44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760011AbYAJP44 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 10:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756498AbYAJP4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 10:56:48 -0500
Received: from rn-out-0910.google.com ([64.233.170.187]:32341 "EHLO
	rn-out-0102.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755807AbYAJP4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 10:56:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xuWhp2wuJ2PFwg/47AYNe/A+JfcC9OgG9spgeEP2RBNczJcoVqSNfyWmfnPQMwm4QVeEx/Hb1E5/UqebPxBLuT+SYrYP15mh3X4BHEugs0ahez16tSgiNTnxE8O13xOJKiATEXVMKspNZLLfTJ8ulVagNvyXaxRrQQ3k7BnGP0c=
Message-ID: <e85b9d30801100756ud5e56dftdf24e094b346a397@mail.gmail.com>
Date: Thu, 10 Jan 2008 16:56:12 +0100
From: Matthew <jackdachef@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Fwd: Fwd: laptop / computer hardlocks during execution of 32bit applications(binaries) on 64bit system (Gentoo)
Cc: "Ed Tomlinson" <edt@aei.ca>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20080110133252.GB5886@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e85b9d30712291157v113f5e73yd830ae3c3429092d@mail.gmail.com>
	 <e85b9d30801100443s50ab2b69wbf1a7b4dbd09f002@mail.gmail.com>
	 <20080110124810.GA20579@elte.hu> <200801100808.42945.edt@aei.ca>
	 <20080110133252.GB5886@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > My kernel is _not_ tainted. [...]
>

this time my kernel isn't tainted either (comm: thunderbird-bin Not
tainted; http://kerneloftruth.neucode.org/other/crash_ia32_64/not_tainted/moto_0041.jpg)
 but still hardlocks:
http://kerneloftruth.neucode.org/other/crash_ia32_64/not_tainted/


> ok, good. A series of questions:
>
> - can you reproduce it from the VGA console?
>

yes

> - if yes, does booting with "nmi_watchdog=2 idle=poll" give you a
>   working NMI watchdog? (working NMI watchdog means the NMI counts
>   increase for all cores in /proc/interrupts).
>

no, I get err=-16
(watchdog is broken: cat /proc/interrupts | grep NMI reveals nothing)

> if still 'yes', then try to reproduce the hard hang on the VGA text
> console

yes, despite broken watchdog

steps:
1) startx
2) change to tty2, log in; DISPLAY:=0 thunderbird-bin
3) wait until it hardlocks

known apps to trigger that locking:
- realplayer
- thunderbird-bin (2.0.0.9)
- mozilla-firefox-bin (2.0.0.11)
(all included in portage-tree)

apps not triggering:
- skype (not tested that thoroughly (yet))
- ...

> - do you perhaps get an NMI backtrace printed within 1-2 minutes
> after the hard hang happens? If yes then take a photo of that or write
> it down.
>

only backtrace so far (once):
http://kerneloftruth.neucode.org/other/crash_ia32_64/moto_0040.jpg

I'll tar the whole kernel-directory & modules so that you'll be able
to reproduce it more easily (if wanted), is there a place where I
could upload it (it weighs around 300-400 MBs so that'll take some
time ;) )
I got work to do so that'll be all for now, I hope you'll be able to
find the culprit soon ...

>         Ingo
>

Mat
