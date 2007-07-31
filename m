Return-Path: <linux-kernel-owner+w=401wt.eu-S1763666AbXGaOSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763666AbXGaOSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 10:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762745AbXGaOSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 10:18:14 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:35778 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763497AbXGaOSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 10:18:11 -0400
Subject: Re: [patch 2/4] Expose Power Management Policy option to users
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       linux-scsi@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       edwintorok@gmail.com, axboe@kernel.dk
In-Reply-To: <46AED656.8070407@gmail.com>
References: <20070705194909.337398431@intel.com>
	 <20070705130518.135e4e3c.kristen.c.accardi@intel.com>
	 <46AE12B6.6090408@garzik.org>  <46AED656.8070407@gmail.com>
Content-Type: text/plain
Date: Tue, 31 Jul 2007 09:18:08 -0500
Message-Id: <1185891488.3468.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 15:27 +0900, Tejun Heo wrote:
> Jeff Garzik wrote:
> > Any chance the SCSI peeps could ACK this, and then let me include it in
> > the ALPM patchset in the libata tree?
> 
> ATA link PS is pretty complex with HIPM, DIPM and AHCI ALPM.  I'm not
> sure whether this three level knob would be sufficient.  It might be
> good enough if we're gonna develop extensive in-kernel black/white list
> specifying which method works on which combination but my gut tells me
> that it's best left to userland (probably in the form of per-notebook PS
> profile).
> 
> Adding to the fun, there are quite a few broken devices out there which
> act weirdly when link PS actions are taken.
> 
> Also, I generally don't think AHCI ALPM is a good idea.  It doesn't have
> 'cool down' period before entering PS state which unnecessarily hampers
> performance and might increase chance of device malfunction.
> 
> So, mild NACK from me.

The other comment is that power saving seems to be a property of the
transport rather than the host.  If you do it in the transport classes,
then you can expose all the knobs the actual transport possesses (which
is, unfortunately, none for quite a few SCSI transports).

James


