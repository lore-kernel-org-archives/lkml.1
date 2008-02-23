Return-Path: <linux-kernel-owner+w=401wt.eu-S1765986AbYBWDCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765986AbYBWDCw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 22:02:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757091AbYBWDCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 22:02:42 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:38491 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756337AbYBWDCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 22:02:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=rce/4QI3b9losWCdqcw+d1xlTPfQcRhOs074wnwUcw4OBfwHShpD9l4b+f+AvdJoYDS9OofVu2ZaWWlsxxM7M1ZqFW01k8sG0fKZ54htkOITlLMyg6TI8aVa4fVmcGhN3Sr1XMFnPDChThHpRGJJYpPzUjsIM3UmyG9m1kqdd90=
Message-ID: <ec7f7ee70802221902i1d4877afkad86bca0e2a9b479@mail.gmail.com>
Date: Sat, 23 Feb 2008 05:02:40 +0200
From: "Boaz Harrosh" <bharrosh@panasas.com>
To: "Greg KH" <gregkh@suse.de>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: [patch 33/38] SCSI: gdth: scan for scsi devices
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org,
       "Justin Forbes" <jmforbes@linuxtx.org>,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Dave Jones" <davej@redhat.com>,
       "Chuck Wolber" <chuckw@quantumlinux.com>,
       "Chris Wedgwood" <reviews@ml.cw.f00f.org>,
       "Michael Krufky" <mkrufky@linuxtv.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Domenico Andreoli" <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20080223003130.GH7268@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080223001946.979768610@mini.kroah.org>
	 <20080223002907.GA7268@suse.de> <20080223003130.GH7268@suse.de>
X-Google-Sender-Auth: f69d2dff04b92a33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 2:31 AM, Greg KH <gregkh@suse.de> wrote:
>
>  2.6.24-stable review patch.  If anyone has any objections, please let us
>  know.
>
>  ------------------
>  From: Boaz Harrosh <bharrosh@panasas.com>
>
>  commit: 61c92814dc324b541391757062ff02fbf3b08086
>
>  The patch: "gdth: switch to modern scsi host registration"
>
>  missed one simple fact when moving a way from scsi_module.c.
>  That is to call scsi_scan_host() on the probed host.
>  With this the gdth driver from 2.6.24 is again able to
>  see drives and boot.
>
>  Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>  Tested-by: Joerg Dorchain <joerg@dorchain.net>
>  Tested-by: Stefan Priebe <s.priebe@allied-internet.ag>
>  Tested-by: Jon Chelton <jchelton@ffpglobal.com>
>  Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
>  Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
>  ---
>   drivers/scsi/gdth.c |    9 +++++++++
>   1 file changed, 9 insertions(+)
>
>  --- a/drivers/scsi/gdth.c
>  +++ b/drivers/scsi/gdth.c
>  @@ -4838,6 +4838,9 @@ static int __init gdth_isa_probe_one(ulo
>         if (error)
>                 goto out_free_coal_stat;
>         list_add_tail(&ha->list, &gdth_instances);
>  +
>  +       scsi_scan_host(shp);
>  +
>         return 0;
>
>   out_free_coal_stat:
>  @@ -4965,6 +4968,9 @@ static int __init gdth_eisa_probe_one(us
>         if (error)
>                 goto out_free_coal_stat;
>         list_add_tail(&ha->list, &gdth_instances);
>  +
>  +       scsi_scan_host(shp);
>  +
>         return 0;
>
>   out_free_ccb_phys:
>  @@ -5102,6 +5108,9 @@ static int __init gdth_pci_probe_one(gdt
>         if (error)
>                 goto out_free_coal_stat;
>         list_add_tail(&ha->list, &gdth_instances);
>  +
>  +       scsi_scan_host(shp);
>  +
>         return 0;
>
>   out_free_coal_stat:
>
>  --

Greg, James Hi

This patch is not enough, and will not return a gdth system to working
order. With this patch disks
will show up again, only to crash later. All the 5 patches I sent are
needed, to return to a working
state. James please apply to mainline, so they can be accepted into stable.
of the 5 only 2 I have seen in mainline. 3 are missing.
(if they were submitted, I might have missed them, as I'm traveling, then sorry)

Boaz
