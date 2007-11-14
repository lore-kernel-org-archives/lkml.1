Return-Path: <linux-kernel-owner+w=401wt.eu-S1757108AbXKNOxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbXKNOxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 09:53:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbXKNOxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 09:53:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52280 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808AbXKNOxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 09:53:41 -0500
Date: Wed, 14 Nov 2007 15:53:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Matthew Wilcox <matthew@wil.cx>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: v2.6.24-rc2-409-g9418d5d: attempt to access beyond end of
	device
Message-ID: <20071114145314.GA4537@elte.hu>
References: <4739F112.5060604@m3y3r.de> <473A10C2.6040102@m3y3r.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473A10C2.6040102@m3y3r.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(added Cc:s)

* Thomas Meyer <thomas@m3y3r.de> wrote:

> Thomas Meyer schrieb:
> > i get these errors in the kernel log while trying to copy a file from an
> > iso9660 file system (/dev/sr0) to my intenal hard disk. This is the
> > second cd/dvd that gives me this error. kernel 2.6.23 works without any
> > problems, so i think this is not an medium error:
> >
> > ISO 9660 Extensions: Microsoft Joliet Level 3
> > ISOFS: changing to secondary root
> > attempt to access beyond end of device
> > sr0: rw=0, want=81220, limit=40944
> > Buffer I/O error on device sr0, logical block 20304
> > attempt to access beyond end of device
> > sr0: rw=0, want=81224, limit=40944
> > Buffer I/O error on device sr0, logical block 20305
> > attempt to access beyond end of device
> > sr0: rw=0, want=81228, limit=40944
> > Buffer I/O error on device sr0, logical block 20306
> > attempt to access beyond end of device
> > sr0: rw=0, want=81232, limit=40944
> > Buffer I/O error on device sr0, logical block 20307
> > attempt to access beyond end of device
> > sr0: rw=0, want=81236, limit=40944
> > Buffer I/O error on device sr0, logical block 20308
> > attempt to access beyond end of device
> > sr0: rw=0, want=81240, limit=40944
> > Buffer I/O error on device sr0, logical block 20309
> > attempt to access beyond end of device
> > sr0: rw=0, want=81244, limit=40944
> > Buffer I/O error on device sr0, logical block 20310
> > attempt to access beyond end of device
> > sr0: rw=0, want=81248, limit=40944
> > Buffer I/O error on device sr0, logical block 20311
> > attempt to access beyond end of device
> > sr0: rw=0, want=81220, limit=40944
> > Buffer I/O error on device sr0, logical block 20304
> > attempt to access beyond end of device
> > sr0: rw=0, want=81224, limit=40944
> > Buffer I/O error on device sr0, logical block 20305
> > attempt to access beyond end of device
> > sr0: rw=0, want=1028968, limit=40944
> > Buffer I/O error on device sr0, logical block 257241
> > attempt to access beyond end of device
> > sr0: rw=0, want=1028972, limit=40944
> > Buffer I/O error on device sr0, logical block 257242
> > attempt to access beyond end of device
> > sr0: rw=0, want=1028976, limit=40944
> > attempt to access beyond end of device
> > sr0: rw=0, want=1028980, limit=40944
> > attempt to access beyond end of device
> > sr0: rw=0, want=1028984, limit=40944
> > attempt to access beyond end of device
> > sr0: rw=0, want=1028988, limit=40944
> > attempt to access beyond end of device
> > sr0: rw=0, want=1028992, limit=40944
> > attempt to access beyond end of device
> > sr0: rw=0, want=1028996, limit=40944
> > attempt to access beyond end of device
> > sr0: rw=0, want=1028968, limit=40944
> > attempt to access beyond end of device
> > sr0: rw=0, want=1028972, limit=40944
> >
> > does anybody have similiar problems with current linus kernel?
> >   
>
> I have a question: How to find out between which two tags a given 
> commit lies?
> 
> E.g. commit 6f5391c283d7fdcf24bf40786ea79061919d1e1d ([SCSI] Get rid 
> of scsi_cmnd->done), which is the last commit that changed 
> drivers/scsi/sr.c

good question. A quirky way would be to look at:

  ls -l .git/refs/tags/

and compare it with the commit date. But ... that doesnt necessarily 
work if a tag has been created after the commit but before the commit 
was merged upstream.

> i now discovered (using gitk and a lot of scolling) that above commit 
> is after v2.6.23 but before v2.6.24-rc1 (so it is a possible offender)
> 
> You see i am just too lazy to bisect (and reboot 20th times or so) and 
> i just wanted to try my luck and revert the last
>  commit and see if this fixes my problem.
> 
> By the way: Reverting commit 6f5391c283d7fdcf24bf40786ea79061919d1e1d 
> makes the same cd medium readable again on v2.6.24-rc2-409-g9418d5d.

nice - that commit should then be reverted.

	Ingo
