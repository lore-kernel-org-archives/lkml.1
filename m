Return-Path: <linux-kernel-owner+w=401wt.eu-S1759292AbYBWEPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292AbYBWEPh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 23:15:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbYBWEPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 23:15:30 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35815 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750974AbYBWEP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 23:15:29 -0500
Subject: Re: [patch 33/38] SCSI: gdth: scan for scsi devices
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       jejb@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
In-Reply-To: <ec7f7ee70802221902i1d4877afkad86bca0e2a9b479@mail.gmail.com>
References: <20080223001946.979768610@mini.kroah.org>
	 <20080223002907.GA7268@suse.de> <20080223003130.GH7268@suse.de>
	 <ec7f7ee70802221902i1d4877afkad86bca0e2a9b479@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 22 Feb 2008 22:15:20 -0600
Message-Id: <1203740120.6206.89.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-02-23 at 05:02 +0200, Boaz Harrosh wrote:
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

OK, If I look at mainline plust rc fixes, there are three patches, two
of which were confirmed by testers, and one of which is obvious.  Could
you send the missing two to linux-scsi with a Tested-by tag?

Thanks,

James


