Return-Path: <linux-kernel-owner+w=401wt.eu-S1758782AbYFLJ24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782AbYFLJ24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 05:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755148AbYFLJ2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 05:28:47 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33446 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914AbYFLJ2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 05:28:46 -0400
Date: Thu, 12 Jun 2008 10:28:40 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Implement thermal limiting in generic thermal class
Message-ID: <20080612092840.GA10762@srcf.ucam.org>
References: <20080611100647.GA20013@srcf.ucam.org> <20080611164226.GA27437@srcf.ucam.org> <20080611165804.GB27437@srcf.ucam.org> <1213237534.4867.32.camel@rzhang-dt.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213237534.4867.32.camel@rzhang-dt.sh.intel.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 10:25:34AM +0800, Zhang Rui wrote:

> this patch introduce two things that are obsolete in ACPI thermal
> driver, polling and trip point overriding.

Overriding active trip points was pretty much doomed to failure, given 
that the platform can redefine them at any time.

> I'm under the impression that they are known to break some laptops for
> some reason. Len may have comments on this? :p

Polling is known to break in one case, where the laptop provides a 
passive cooling zone that's at around 50 degrees C. The hardware doesn't 
send any notifications, but if you enable polling thermal limiting will 
start at an excessively low temperature. This patch won't affect that 
case. I'm not aware of any other situations where polling has been 
demonstrated to break things, especially when at a frequency as low as 
this. Of course, it's possible that some machines take an excessively 
long time to respond to temperature reads - that's something that could 
be handled without any trouble.

> as cdev->throttle is cleared by default, this may affect the cooling
> devices in the thermal zones that don't enable passive cooling.

Hm, yes, that's a good point and needs rectifying.

> Hmm, I don't think we should enable the force_passive by default.
> IMO, we should just create "passive" attribute for thermal zones without
> a passive trip point, and enable it until user set a valid value.

That would be an option (and certainly better than the current 
situation), but I'd prefer systems to work out of the box where 
possible.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
