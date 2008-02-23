Return-Path: <linux-kernel-owner+w=401wt.eu-S1762759AbYBWEFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762759AbYBWEFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 23:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758969AbYBWEEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 23:04:23 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43828 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbYBWEEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 23:04:10 -0500
Date: Fri, 22 Feb 2008 19:52:04 -0800
From: Greg KH <greg@kroah.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Greg KH <gregkh@suse.de>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       jejb@kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, torvalds@linux-foundation.org,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, akpm@linux-foundation.org,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 33/38] SCSI: gdth: scan for scsi devices
Message-ID: <20080223035204.GA25980@kroah.com>
References: <20080223001946.979768610@mini.kroah.org> <20080223002907.GA7268@suse.de> <20080223003130.GH7268@suse.de> <ec7f7ee70802221902i1d4877afkad86bca0e2a9b479@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec7f7ee70802221902i1d4877afkad86bca0e2a9b479@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 05:02:40AM +0200, Boaz Harrosh wrote:
> On Sat, Feb 23, 2008 at 2:31 AM, Greg KH <gregkh@suse.de> wrote:
> >
> >  2.6.24-stable review patch.  If anyone has any objections, please let us
> >  know.
> >
> >  ------------------
> >  From: Boaz Harrosh <bharrosh@panasas.com>
> >
> >  commit: 61c92814dc324b541391757062ff02fbf3b08086
> >
> >  The patch: "gdth: switch to modern scsi host registration"
> >
> >  missed one simple fact when moving a way from scsi_module.c.
> >  That is to call scsi_scan_host() on the probed host.
> >  With this the gdth driver from 2.6.24 is again able to
> >  see drives and boot.
> >
> >  Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> >  Tested-by: Joerg Dorchain <joerg@dorchain.net>
> >  Tested-by: Stefan Priebe <s.priebe@allied-internet.ag>
> >  Tested-by: Jon Chelton <jchelton@ffpglobal.com>
> >  Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> >  Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> >
> >  ---
> >   drivers/scsi/gdth.c |    9 +++++++++
> >   1 file changed, 9 insertions(+)
> >
> >  --- a/drivers/scsi/gdth.c
> >  +++ b/drivers/scsi/gdth.c
> >  @@ -4838,6 +4838,9 @@ static int __init gdth_isa_probe_one(ulo
> >         if (error)
> >                 goto out_free_coal_stat;
> >         list_add_tail(&ha->list, &gdth_instances);
> >  +
> >  +       scsi_scan_host(shp);
> >  +
> >         return 0;
> >
> >   out_free_coal_stat:
> >  @@ -4965,6 +4968,9 @@ static int __init gdth_eisa_probe_one(us
> >         if (error)
> >                 goto out_free_coal_stat;
> >         list_add_tail(&ha->list, &gdth_instances);
> >  +
> >  +       scsi_scan_host(shp);
> >  +
> >         return 0;
> >
> >   out_free_ccb_phys:
> >  @@ -5102,6 +5108,9 @@ static int __init gdth_pci_probe_one(gdt
> >         if (error)
> >                 goto out_free_coal_stat;
> >         list_add_tail(&ha->list, &gdth_instances);
> >  +
> >  +       scsi_scan_host(shp);
> >  +
> >         return 0;
> >
> >   out_free_coal_stat:
> >
> >  --
> 
> Greg, James Hi
> 
> This patch is not enough, and will not return a gdth system to working
> order. With this patch disks
> will show up again, only to crash later. All the 5 patches I sent are
> needed, to return to a working
> state. James please apply to mainline, so they can be accepted into stable.
> of the 5 only 2 I have seen in mainline. 3 are missing.
> (if they were submitted, I might have missed them, as I'm traveling, then sorry)

Ok, I'll take this for now, and let James send me any further ones he
deems necessary.

thanks,

greg k-h
