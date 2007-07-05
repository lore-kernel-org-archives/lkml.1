Return-Path: <linux-kernel-owner+w=401wt.eu-S1760302AbXGEPCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760302AbXGEPCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 11:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757360AbXGEPCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 11:02:11 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:60968 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757094AbXGEPCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 11:02:10 -0400
Date: Thu, 5 Jul 2007 16:00:42 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Oliver Neukum <oliver@neukum.org>,
       Miklos Szeredi <miklos@szeredi.hu>, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       pavel@ucw.cz, benh@kernel.crashing.org
Message-ID: <20070705150042.GA23647@srcf.ucam.org>
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <200707051528.34754.oliver@neukum.org> <20070705134632.GA22177@srcf.ucam.org> <200707051609.25887.rjw@sisk.pl> <20070705142318.GA22598@srcf.ucam.org> <2c0942db0707050746v2b8cdc9ew2c4656736b52895d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0707050746v2b8cdc9ew2c4656736b52895d@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2007 at 07:46:01AM -0700, Ray Lee wrote:

> Hmm, careful. There are a bunch of people who use suspend2 exactly
> because it saves and restores the page cache, leaving the system in a
> usable state without waiting for the universe to swap back in from
> disk. It makes a big difference on older laptops with slow drives.
> While the other advantages you list for process cryogenics are pretty
> neat, let's remember that the 99% use case for STD is laptops.

Saving the processes means that you're implicitly saving the interesting 
chunks of the page cache. Removing the need for the atomic copy saves 
you from pushing a pile of stuff out to swap in the first place.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
