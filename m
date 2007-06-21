Return-Path: <linux-kernel-owner+w=401wt.eu-S1758435AbXFUGwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435AbXFUGwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 02:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbXFUGwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 02:52:11 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:31700 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428AbXFUGwJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 02:52:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=qBrpprr22Um5+QuG1i+p0QZ6vJBE4mnIbxMT8Ng1LAXzs4fn1fVTySXhu/v4DPiY6N7wtA/VYb/Wff/huRjcrH+25rHM0KgeWmgEYXS71I35GiJzRbQ2tDM/bYtYQ18UwSYVVEkT1lOigdiIJNjAcLFNKsHgOx9vkfl4WVPHZaQ=
Message-ID: <a781481a0706202352u1efed48fo5a101f8c015638d7@mail.gmail.com>
Date: Thu, 21 Jun 2007 12:22:01 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Tom Spink" <tspink@gmail.com>
Subject: build failure due to ROOT_DEV in mtd module (was Re: linux-2.6.22-rc5-g7c8545e build #298 failed ...)
Cc: "=?ISO-8859-1?Q?Toralf_F=F6rster?=" <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org, "Christoph Hellwig" <hch@infradead.org>,
       "Paolo Giarrusso" <blaisorblade@yahoo.it>,
       "David Woodhouse" <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[Added Christoph, Paolo, David and linux-mtd.]

On 6/21/07, Tom Spink <tspink@gmail.com> wrote:
> On 20/06/07, Tom Spink <tspink@gmail.com> wrote:
> > On 20/06/07, Toralf Förster <toralf.foerster@gmx.de> wrote:
> > > Hello,
> > >
> > > the build with the attached .config failed, make ends with:
> > [...]
> > The build seems to fail because of:
> > ERROR: "ROOT_DEV" [drivers/mtd/maps/nettel.ko] undefined!
> >
> > After taking a quick look at the code, I can't immediately see why
> > this would be, since there is an include for linux/root_dev.h at the
> > top, there.
> >
> > There's only one occurrence of ROOT_DEV (line 425), and after a quick
> > look at the git history, it seems the include was originally missing,
> > but was put back in, in commit
> > 6cc449c7d0292cb9b993f0df84fd3225e3099492.
> [...]
> After further inspection, I *think* it's because nettel is being built
> as a module, and it's trying to reference ROOT_DEV, which is not
> exported.

You're right. Look at:
commit a2d2b5cb8e5d8787f009eeb3bbca52687bd42a77
[ http://lkml.org/lkml/2005/7/13/166 ]

You could export ROOT_DEV to modules back again, or perhaps:
http://www.infradead.org/pipermail/linux-mtd/2005-March/012290.html
to get around the build error.

[ It might've been unexported for good reasons, of course, see:
http://lkml.org/lkml/2005/3/30/179 ]

Satyam
