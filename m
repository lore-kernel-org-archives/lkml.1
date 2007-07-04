Return-Path: <linux-kernel-owner+w=401wt.eu-S1760031AbXGDJVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760031AbXGDJVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 05:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757068AbXGDJVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 05:21:30 -0400
Received: from ozlabs.org ([203.10.76.45]:33541 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756052AbXGDJV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 05:21:29 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18059.26259.765791.62319@cargo.ozlabs.ibm.com>
Date: Wed, 4 Jul 2007 19:21:23 +1000
From: Paul Mackerras <paulus@samba.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
In-Reply-To: <200707041039.30015.oliver@neukum.org>
References: <20070703042916.GA17240@srcf.ucam.org>
	<200707041011.33279.oliver@neukum.org>
	<18059.23015.860618.268754@cargo.ozlabs.ibm.com>
	<200707041039.30015.oliver@neukum.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum writes:

> > It's not lost, it's sitting in RAM, and will be sent out when you
> > resume.
> 
> Unfortunately this is not the case. The URB will error out.

So the higher-level driver needs to do the sensible thing, i.e.,
resubmit the URB after resume.  It's not rocket science.  The data is
not lost, it's sitting in RAM, and the higher-level driver will send
it out when you resume.  If not, then we fix the higher-level driver.

Of course with USB there is the interesting question of whether the
device is still there when we resume.  But if it isn't, the situation
is no different to the user asynchronously unplugging the device
during operation, and if we lose data in that situation, we can only
blame the user. :)

Paul.
