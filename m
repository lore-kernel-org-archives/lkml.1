Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab0CHS6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 13:58:44 -0500
Received: from cantor.suse.de ([195.135.220.2]:38901 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251Ab0CHS6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 13:58:36 -0500
Subject: Re: ATA 4 KiB sector issues.
From: James Bottomley <James.Bottomley@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Tejun Heo <tj@kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       hirofumi@mail.parknet.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
In-Reply-To: <4B9546E6.6050006@zytor.com>
References: <4B947393.2050002@kernel.org>
	 <1268031640.4389.11.camel@mulgrave.site>
	 <yq1vdd6bzgz.fsf@sermon.lab.mkp.net>	<yq1mxyibz7o.fsf@sermon.lab.mkp.net>
	 <yq1iq96bz22.fsf@sermon.lab.mkp.net>  <4B9546E6.6050006@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Mar 2010 00:28:25 +0530
Message-ID: <1268074705.10660.23.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-08 at 10:50 -0800, H. Peter Anvin wrote:
> On 03/08/2010 07:41 AM, Martin K. Petersen wrote:
> >>>>>> "Martin" == Martin K Petersen <martin.petersen@oracle.com> writes:
> > 
> >>>>>> "Martin" == Martin K Petersen <martin.petersen@oracle.com> writes:
> > Martin> There are 4 KB LBS SSDs out there but in general the industry is
> > Martin> sticking to ATA for local boot.
> > 
> > Martin> Thus implying that ATA doesn't support 4 KB LBS, just that
> > Martin> people stick to the tried-and-true 512.
> > 
> > *sigh* I haven't had my breakfast tea yet...
> > 
> > What I meant to say was that I know ATA supports 4 KB LBS and that
> > nobody appears to care about it.
> > 
> 
> Well, apparently Western Digital are looking at it for USB drives due to
> XP compatibility requirements -- those presumably are ATA internally and
> use a USB-ATA bridge.
> 
> On the flipside, though, there really is very little net benefit to 4K
> as opposed to 512 byte logical sectors: the additional protocol overhead
> is relatively minimal, and as long as writes are aligned full blocks,
> there shouldn't be any additional overhead on either the OS or the drive
> side.  On the plus side, you get full compatibility with the existing
> software stack.  The equation really seems rather simple.

There's another problem that afflicts 4k drives emulating 512b: they
have to do a read modify write for any isolated 512b write ... that
leads to potential corruption of adjacent 512b blocks if power is lost
at the moment the write is being done.  Since most Linux filesystems are
4k sectors, misalignment really hammers this, plus most journal writes
seem to be done in 512 byte increments.  I suppose for USB this could be
regarded as flakey as usual, though.

James


