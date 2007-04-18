Return-Path: <linux-kernel-owner+w=401wt.eu-S1422886AbXDRLsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422886AbXDRLsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 07:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422894AbXDRLsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 07:48:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:52616 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422886AbXDRLso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 07:48:44 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Loud "pop" coming from hard drive on reboot
To: Tejun Heo <htejun@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       emisca <emisca.ml@gmail.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@osdl.org>
Reply-To: 7eggert@gmx.de
Date: Wed, 18 Apr 2007 13:47:24 +0200
References: <88SeR-5Sf-15@gated-at.bofh.it> <88Sov-662-3@gated-at.bofh.it> <88SHV-6uL-29@gated-at.bofh.it> <8agVk-3wc-81@gated-at.bofh.it> <8b3IR-4mE-25@gated-at.bofh.it> <8b3SA-4z3-5@gated-at.bofh.it> <8b42g-51N-15@gated-at.bofh.it> <8bbdm-7iS-27@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1He8dA-0000mw-LI@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19ZpJSZSMkkTKRtoo1DlHvgIxB4FXJpJ42S77i
 9JZt7NHI6xLdN/hdoAThF5uy3yHD5X7kwvsFfNZihO3DQzslv+
 7X26LkMsy+2IjFvvbXaiw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <htejun@gmail.com> wrote:

> This really isn't a regression.  It's been always like that with libata.
>  libata doesn't make devices go into standby mode and shutdown(8) does
> it for libata.  The problem here is that libata does issue
> SYNCHRONIZE_CACHE on shutdown.  So, the sequence of event is...
> 
> 1. shutdown(8) issues SYNCHRONIZE_CACHE followed by STANDBY_NOW
> 2. kernel shutdown starts
> 3. libata shutdown issues SYNCHRONIZE_CACHE
> 4. power goes off
> 
> Some drives seem to spin up at step #3 even when its cache is clean and
> power goes off right after the disk finishes the command.  So, it's
> really bad when it happens - spin down, spin up followed by immediate
> power off.
> 
> SCSI part of the fix is queued in scsi-misc-2.6 tree and libata-dev part
> is acked and waiting to be merged, so the fix will be available in
> 2.6.22.  However, it's disabled by default to remain compatible with the
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> current behavior and requires userland change to fully fix the problem.
  ^^^^^^^^^^^^^^^^
It sounds like the Schilling kind of compatibility: "The old burner destroyed
your disk on buffer underruns, therefore the new thing should do the same
instead of giving you a perfectly readable data disk."

Guys, not destroying hardware is _NOT_ bad!
-- 
Anger, fear, aggression. The Dark Side of the Force are they.
Once you start down the Dark Path, forever will it dominate your destiny.
        -- Jedi Master Yoda
Friﬂ, Spammer: QuG4KfL@BSc.7eggert.dyndns.org
