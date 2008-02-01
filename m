Return-Path: <linux-kernel-owner+w=401wt.eu-S1755418AbYBARqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbYBARqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 12:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbYBARqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 12:46:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:7778 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbYBARqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 12:46:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MSwviCL4F8aduy8Yx2MreoUyKpvMWf/bABno0BWzK25pKv2ShXyLlEKzSyLXGwI9YEUFA05FagbLv/bkGKB0oQ8p/0d02bN56SN4WspFDfcQm5t/BTC5fmcykuh5UcS//3668EYyLTPWGthnemad6eVR71sru86FkbNF5N7XG08=
Message-ID: <58cb370e0802010946v3544a4echc08a17f678222555@mail.gmail.com>
Date: Fri, 1 Feb 2008 18:46:32 +0100
From: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [PATCH #upstream] libata: implement libata.force module parameter
Cc: "Tejun Heo" <htejun@gmail.com>,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       "Mark Lord" <liml@rtr.ca>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Sam Ravnborg" <sam@ravnborg.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47A356C3.3010904@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47A3375F.80101@gmail.com> <47A356C3.3010904@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 1, 2008 6:28 PM, Jeff Garzik <jeff@garzik.org> wrote:
> Tejun Heo wrote:
> > This patch implements libata.force module parameter which can
> > selectively override ATA port, link and device configurations
> > including cable type, SATA PHY SPD limit, transfer mode and NCQ.
> >
> > For example, you can say "use 1.5Gbps for all fan-out ports attached
> > to the second port but allow 3.0Gbps for the PMP device itself, oh,
> > the device attached to the third fan-out port chokes on NCQ and
> > shouldn't go over UDMA4" by the following.
> >
> >  libata.force=2:1.5g,2.15:3.0g,2.03:noncq,udma4
> >
> > Signed-off-by: Tejun Heo <htejun@gmail.com>
> > ---
> > I guess it's about time we add something like this.  More than
> > anything else this should help debugging and can serve as a last
> > resort to work around problems.
> >
> > Thanks.
> >
> >  Documentation/kernel-parameters.txt |   35 +++
> >  drivers/ata/libata-core.c           |  375 +++++++++++++++++++++++++++++++++++-
> >  drivers/ata/libata-eh.c             |    8
> >  drivers/ata/libata.h                |    1
> >  4 files changed, 415 insertions(+), 4 deletions(-)
>
> ACK, but it breaks the build due to section type conflicts:
>
> drivers/ata/libata-core.c:108: error: ata_force_param_buf causes a
> section type conflict
>
> Given that the data is marked __initdata and the code is marked __init,
> I cannot see the problem.

the data is marked as "const"
