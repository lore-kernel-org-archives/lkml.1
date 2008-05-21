Return-Path: <linux-kernel-owner+w=401wt.eu-S932936AbYEULAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936AbYEULAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 07:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756726AbYEULAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 07:00:17 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50256 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251AbYEULAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 07:00:15 -0400
Date: Wed, 21 May 2008 11:59:44 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       kristen.c.accardi@intel.com, Len Brown <lenb@kernel.org>
Message-ID: <20080521105944.GA30728@srcf.ucam.org>
References: <20080521104547.GA8097@homac>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521104547.GA8097@homac>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] bay: Exit if notify handler cannot be installed
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 12:45:47PM +0200, Holger Macht wrote:
> If acpi_install_notify_handler() for a bay device fails, the bay driver is
> superfluous. Most likely, another driver (like libata) is already caring
> about this device anyway. Furthermore,
> register_hotplug_dock_device(acpi_handle) from the dock driver must not be
> called twice with the same handler. This would result in an endless loop
> consuming 100% of CPU. So clean up and exit.

The bay driver still provides the only mechanism for calling the eject 
methods.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
