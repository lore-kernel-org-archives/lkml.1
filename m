Return-Path: <linux-kernel-owner+w=401wt.eu-S1753680AbZDOPGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbZDOPGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 11:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbZDOPGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 11:06:04 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47133 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751812AbZDOPGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 11:06:03 -0400
Subject: Re: 2.6.30-rc1: parisc: system hangs on boot at __schedule()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, linux-parisc@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-scsi@vger.kernel.org
In-Reply-To: <a4423d670904150549s48b844a7iba097acaf875b992@mail.gmail.com>
References: <a4423d670904080603w50face2fl87cd16bd7967cb5d@mail.gmail.com>
	 <20090408220921.GF7372@bombadil.infradead.org>
	 <a4423d670904090146w2937bf15le2afb5dfad718f0e@mail.gmail.com>
	 <20090409144611.GH7372@bombadil.infradead.org>
	 <a4423d670904150549s48b844a7iba097acaf875b992@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 15 Apr 2009 15:06:03 +0000
Message-Id: <1239807963.3371.17.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-15 at 16:49 +0400, Alexander Beregalov wrote:
> 2009/4/9 Kyle McMartin <kyle@mcmartin.ca>:
> > On Thu, Apr 09, 2009 at 12:46:15PM +0400, Alexander Beregalov wrote:
> >> 2009/4/9 Kyle McMartin <kyle@mcmartin.ca>:
> >> > On Wed, Apr 08, 2009 at 05:03:04PM +0400, Alexander Beregalov wrote:
> >> >> Hi
> >> >>
> >> >> Machine is HP j6000.
> >> >> CPU(s): 2 x PA8700 (PCX-W2) at 750.000000 MHz
> >> >>
> >> >> gcc version 4.3.3 (Gentoo 4.3.3-r2 p1.1, pie-10.1.5)
> >> >>
> >> >>
> >> >> Machine hangs before starting rc scripts, but SysRq and C-A-Del work.
> >> >>
> >> >> All tasks are at __schedule+0x268/0x7bc:
> >> >>
> >> >
> >> > .config?
> >>
> >> Sorry, attached.
> >
> > Thanks, I swapped disks into my j6700 and will try to reproduce.
> 
> It seems the problem is the same as mentioned here:
> http://marc.info/?l=linux-kernel&m=123920746830420&w=2
> 
> The patch  fixes the issue.
> 
> James?
> The same problem on two of my hosts: x86_64 with LSI SAS MegaRAID
> and parisc with SYM53C8XX_2

Well, I can tell you why I don't see the problem:  My parisc system has
modular SCSI, so it doesn't really test out the async system that well
(it was designed more for monolithic kernels).

On the specific patch in the email, it seems reasonable, but I think it
might interfere with the sd probe async calls, so what you might end up
losing a rache where the host fully scanned, but the sd driver not
attached.

The root cause of the problem is that we now have two different async
mechanisms in SCSI: our original one for host scanning and the new one
for sd attachment.

James


