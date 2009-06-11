Return-Path: <linux-kernel-owner+w=401wt.eu-S1756616AbZFKJIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbZFKJIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 05:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbZFKJHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 05:07:54 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:53637 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbZFKJHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 05:07:53 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch update] Re: [linux-pm] Run-time PM idea (was: Re: [RFC][PATCH 0/2] PM: Rearrange core suspend code)
Date: Thu, 11 Jun 2009 11:08:40 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       linux-pm@lists.linux-foundation.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0906082233490.19072-100000@netrider.rowland.org> <200906101029.27529.rjw@sisk.pl> <aec7e5c30906102218j2f8f38dbt5d05a3928ca46c15@mail.gmail.com>
In-Reply-To: <aec7e5c30906102218j2f8f38dbt5d05a3928ca46c15@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906111108.40785.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 11. Juni 2009 07:18:46 schrieb Magnus Damm:
> 3) When all devices in the power domain are suspended the bus code can
> turn off the power. The reason why I'd like to only autosuspend when

So you are saying that you have power dependencies independent
of the device tree?

> all devices are idle is simply that we don't get any power savings
> from the per device autosuspend() callbacks, only from turning off
> power to the entire per-domain. So bindly autosuspending and
> autoresuming devices is just pure overhead unless we know we can do it
> for all devices in the domain.

Why can't you do this within the framework? You simply suspend when
all a domain's devices have been autosuspended.
I suppose we could have a helper.

int pm_autosuspend_in_domain(struct device *dev)
{
	int err;

	mutex_lock(dev->power_domain);
	if (! --dev->power_domain.active_devices)
		err = dev->power_domain->power_down(dev->power_domain);
	else
		err = 0;
	mutex_unlock(dev->power_domain);

	return err;
}

	Regards
		Oliver

