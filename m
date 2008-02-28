Return-Path: <linux-kernel-owner+w=401wt.eu-S1759572AbYB1LIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572AbYB1LIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 06:08:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755572AbYB1LId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 06:08:33 -0500
Received: from cantor.suse.de ([195.135.220.2]:57312 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758966AbYB1LIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 06:08:14 -0500
Date: Thu, 28 Feb 2008 12:09:27 +0100
From: Holger Macht <hmacht@suse.de>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [PATCH] libata: Register for dock events when the drive is
	inside a dock station
Message-ID: <20080228110927.GA5745@homac.suse.de>
Mail-Followup-To: Tejun Heo <htejun@gmail.com>,
	Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>
References: <20080214124048.GB9708@homac.suse.de> <20080214125615.GD9708@homac.suse.de> <47BC5F44.605@garzik.org> <20080221115305.GB5032@homac.suse.de> <47BE26A0.2040708@gmail.com> <20080226101551.GB10721@homac.suse.de> <47C6804A.50705@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C6804A.50705@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 28. Feb - 18:35:06, Tejun Heo wrote:
> Holger Macht wrote:
> > The hotplug handler is only called if the device is actually inside the
> > dock station. If it is not, nothing will happen. I hope that I got your
> > question right?
> 
> Yes, right.
> 
> > However, if this would be helpful, it would be easy to add something like
> > a am_I_on_dock_station?(...) function to the dock driver.
> 
> Hmm.. as long as the event is only delivered when the device is actually
> connected behind dock, I think it's okay.

The dock driver also export a is_dock_device(acpi_handle) function, which
could be used to make more fine-grained decisions, but it shouldn't be
needed here.

> Does the attached patch fix the previous undock problem?  It now
> explicitly tells libata EH to detach the notified devices on
> EJECT_REQUEST and wait for EH to complete such that control is returned
> to ACPI after all notified devices are actually detached.

No it does not. Apparently, it freezes faster (from 1 second down to
immediately). Before, it just froze when someone (in this case HAL) tried
to access the device. The "echo 1 > undock" call does not even return, so
it might have introduced another problem.

Regards,
	Holger
