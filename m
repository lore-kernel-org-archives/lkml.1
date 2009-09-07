Return-Path: <linux-kernel-owner+w=401wt.eu-S1752885AbZIGX04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbZIGX04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 19:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbZIGX0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 19:26:55 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:24751 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbZIGX0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 19:26:54 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=w4iE+TBsmj5y1WloLYF40w==:17 a=CATmnnJcvPCm2y3zWxsA:9
 a=wos_fZWYcppAuCGGlp2U94-ZovgA:4
From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
To: Chris Webb <chris@arachsys.com>, linux-scsi@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Ric Wheeler <rwheeler@redhat.com>,
       Andrei Tanas <andrei@tanas.ca>, NeilBrown <neilb@suse.de>,
       linux-kernel@vger.kernel.org,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>
Subject: Re: MD/RAID time out writing superblock
Date: Mon, 7 Sep 2009 17:26:56 -0600
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc8; KDE/4.3.1; x86_64; ; )
References: <4A950FA6.4020408@redhat.com> <20090907114442.GG18831@arachsys.com> <20090907165504.GJ31003@lifeintegrity.com>
In-Reply-To: <20090907165504.GJ31003@lifeintegrity.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909071726.56432.tfjellstrom@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon September 7 2009, Allan Wind wrote:
> On 2009-09-07T12:44:42, Chris Webb wrote:
> > Sorry for the late follow up to this thread, but I'm also seeing symptoms
> > that look identical to these and would be grateful for any advice. I
> > think I can reasonably rule out a single faulty drive, controller or
> > cabling set as I'm seeing it across a cluster of Supermicro machines with
> > six Seagate ST3750523AS SATA drives in each and the drive that times out
> > is apparently randomly distributed across the cluster. (Of course, since
> > the hardware is identical, it could still be a hardware design or
> > firmware problem.)
> 
> Seeing the same thing with a Supermicro motherboard and a pair WDC 2 TB
> drives.  Disabling NCQ does not resolve the issue, nor increasing
> the safe_mode_delay.  This is with 2.6.30.4.  This machine is
> sitting on its hand (i.e. no significant load).

I have the same issue with a single WD 2TB Green drive. Technically two, but 
it always only gets errors from the same drive, so I was assuming it was the 
drive. I only have to setup the raid0 array, and put some light load on it for 
the kernel to start complaining, and eventually it just kicks the drive 
completely with the following messages:

sd 3:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
end_request: I/O error, dev sdb, sector 202026972

The drive does work fine prior to the frozen timeout errors. And I was using 
it in windows (same raid0 config) just fine with no errors what so ever.

> 
> /Allan
> 


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
