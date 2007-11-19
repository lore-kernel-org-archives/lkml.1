Return-Path: <linux-kernel-owner+w=401wt.eu-S1752390AbXKSVLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390AbXKSVLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 16:11:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbXKSVLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 16:11:15 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45167 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751244AbXKSVLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 16:11:14 -0500
Date: Mon, 19 Nov 2007 22:11:42 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: kernel list <linux-kernel@vger.kernel.org>, tglx@linutronix.de
Subject: Re: nohz and strange sleep latencies
Message-ID: <20071119211142.GA1857@elf.ucw.cz>
References: <20071119203152.GA1772@elf.ucw.cz> <20071119205555.GA28696@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119205555.GA28696@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > On unloaded x60 system, 2.6.24-rc3 (tainted-pavel-so if someone can
> > reproduce it, it would be helpful):
> > 
> > pavel@amd:~$ while true; do time sleep 0.01; done
> > 0.00user 0.00system 0.01 (0m0.013s) elapsed 30.71%CPU
> > 0.00user 0.00system 0.02 (0m0.024s) elapsed 8.36%CPU
> > 0.00user 0.00system 0.01 (0m0.013s) elapsed 15.53%CPU
> > 0.00user 0.00system 0.02 (0m0.026s) elapsed 7.75%CPU
> > 0.00user 0.00system 0.01 (0m0.013s) elapsed 23.34%CPU
> > 0.00user 0.00system 0.20 (0m0.207s) elapsed 1.45%CPU
> > 0.00user 0.00system 0.01 (0m0.013s) elapsed 15.59%CPU
> > 0.00user 0.00system 0.23 (0m0.230s) elapsed 1.30%CPU
> > 0.00user 0.00system 0.01 (0m0.013s) elapsed 15.61%CPU
> > 0.00user 0.00system 0.20 (0m0.201s) elapsed 1.48%CPU
> > 0.00user 0.00system 0.01 (0m0.013s) elapsed 15.50%CPU
> > 0.00user 0.00system 0.19 (0m0.190s) elapsed 1.05%CPU
> > 0.00user 0.00system 0.01 (0m0.013s) elapsed 23.37%CPU
> > 0.00user 0.00system 0.04 (0m0.049s) elapsed 4.09%CPU
> > 0.00user 0.00system 0.01 (0m0.013s) elapsed 23.35%CPU
> > 0.00user 0.00system 0.01 (0m0.017s) elapsed 11.89%CPU
> > 0.00user 0.00system 0.01 (0m0.013s) elapsed 23.38%CPU
> > 0.00user 0.00system 0.08 (0m0.081s) elapsed 3.71%CPU
> > 0.00user 0.00system 0.01 (0m0.013s) elapsed 23.33%CPU
> > 0.00user 0.00system 0.01 (0m0.019s) elapsed 15.92%CPU
> > 
> > nohz=off helps a lot. while true; do time sleep 0.0; done does not 
> > have unexpected latencies.
> 
> does hpet=disable on the boot line also help? (without nohz=off)

hpet-disable helps.. a bit. 200msec latencies are gone. (What is used
for wakeups in this case?)

pavel@amd:~$ while true; do time sleep 0.01; done
0.00user 0.00system 0.01 (0m0.013s) elapsed 22.96%CPU
0.00user 0.00system 0.01 (0m0.018s) elapsed 11.05%CPU
0.00user 0.00system 0.01 (0m0.013s) elapsed 15.54%CPU
0.00user 0.00system 0.03 (0m0.037s) elapsed 8.05%CPU
0.00user 0.00system 0.01 (0m0.013s) elapsed 23.34%CPU
0.00user 0.00system 0.03 (0m0.037s) elapsed 8.14%CPU
0.00user 0.00system 0.01 (0m0.013s) elapsed 23.33%CPU
0.00user 0.00system 0.03 (0m0.037s) elapsed 8.16%CPU
0.00user 0.00system 0.01 (0m0.013s) elapsed 23.30%CPU
0.00user 0.00system 0.03 (0m0.037s) elapsed 5.47%CPU
0.00user 0.00system 0.01 (0m0.013s) elapsed 23.25%CPU
0.00user 0.00system 0.01 (0m0.013s) elapsed 15.54%CPU
0.00user 0.00system 0.01 (0m0.013s) elapsed 15.56%CPU
0.00user 0.00system 0.03 (0m0.036s) elapsed 5.49%CPU
0.00user 0.00system 0.01 (0m0.013s) elapsed 23.35%CPU
0.00user 0.00system 0.03 (0m0.037s) elapsed 8.14%CPU
0.00user 0.00system 0.01 (0m0.013s) elapsed 23.35%CPU
0.00user 0.00system 0.03 (0m0.037s) elapsed 8.14%CPU
0.00user 0.00system 0.01 (0m0.013s) elapsed 23.34%CPU
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
