Return-Path: <linux-kernel-owner+w=401wt.eu-S1757516AbYJPGTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516AbYJPGTo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 02:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbYJPGQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 02:16:47 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:47445 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756244AbYJPGQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 02:16:46 -0400
Date: Thu, 16 Oct 2008 09:16:38 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Alex Chiang <achiang@hp.com>, Tejun Heo <tj@kernel.org>, jeff@redhat.com,
       linux-ide@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] stop gcc warning about uninitialized 'dev' in
	ata_scsi_scan_host
Message-ID: <20081016061638.GA23630@cs181140183.pp.htv.fi>
References: <20081015232505.GB9272@ldl.fc.hp.com> <48F6A2E7.5090005@kernel.org> <20081016034042.GA27621@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20081016034042.GA27621@ldl.fc.hp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 09:40:42PM -0600, Alex Chiang wrote:
> * Tejun Heo <tj@kernel.org>:
> > Alex Chiang wrote:
> > > Shuts up gcc-3.4.5-glibc-2.3.6 when it complains of:
> > > 
> > > drivers/ata/libata-scsi.c: In function `ata_scsi_scan_host':
> > > drivers/ata/libata-scsi.c:3225: warning: 'dev' might be used
> > > uninitialized in this function
> > > 
> > > Signed-off-by: Alex Chiang <achiang@hp.com>
> > 
> > Nacked-by: Tejun Heo <tj@kernel.org>
> > 
> > Some gcc versions complain about sata_via, others complain
> > about something else.  Some versions complain about some
> > iterator usages while not complaining about others, but none of
> > those complaints is actually wrong or dangerous.  I don't think
> > adding = NULL whenever some version of gcc complains is the
> > right approach.
> 
> Hm, ok.
> 
> I guess we don't want to sprinkle these around all over the place
> just to solve cosmetic issues, which makes sense, but is there
> some other approach we could take instead? Any suggestions? Or
> just live with it?

We have an annotation for these kinds of warnings in the kernel.

But we'll never get a warning-free compilation with all seven (sic) 
supported gcc release series.

A warning-free compilation with gcc 4.3 is worth some efforts, but 
cluttering our code to fix bogus warnings with older gcc versions
is not a good thing.

> /ac

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

