Return-Path: <linux-kernel-owner+w=401wt.eu-S1752851AbXGaG2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbXGaG2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 02:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbXGaG1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 02:27:50 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:33324 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbXGaG1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 02:27:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=REfPh6Iynf7x2n8ilTGWJTFsvixRWesAP0USLKALCzVnwm01K0deLxXdC4pyit/KxeKFfQcOJ0PnMO8T4gWtD/oLpBgbcuLO1cEre4ggJ/1xylljscYsZ7td4tnO+QASH8kwnejGVr37iL9TxxjWnevKZ6392YjBJ6DFO8NgHWE=
Message-ID: <46AED656.8070407@gmail.com>
Date: Tue, 31 Jul 2007 15:27:34 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, edwintorok@gmail.com, axboe@kernel.dk
Subject: Re: [patch 2/4] Expose Power Management Policy option to users
References: <20070705194909.337398431@intel.com> <20070705130518.135e4e3c.kristen.c.accardi@intel.com> <46AE12B6.6090408@garzik.org>
In-Reply-To: <46AE12B6.6090408@garzik.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Any chance the SCSI peeps could ACK this, and then let me include it in
> the ALPM patchset in the libata tree?

ATA link PS is pretty complex with HIPM, DIPM and AHCI ALPM.  I'm not
sure whether this three level knob would be sufficient.  It might be
good enough if we're gonna develop extensive in-kernel black/white list
specifying which method works on which combination but my gut tells me
that it's best left to userland (probably in the form of per-notebook PS
profile).

Adding to the fun, there are quite a few broken devices out there which
act weirdly when link PS actions are taken.

Also, I generally don't think AHCI ALPM is a good idea.  It doesn't have
'cool down' period before entering PS state which unnecessarily hampers
performance and might increase chance of device malfunction.

So, mild NACK from me.

-- 
tejun
