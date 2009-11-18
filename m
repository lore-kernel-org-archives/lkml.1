Return-Path: <linux-kernel-owner+w=401wt.eu-S932182AbZKRVeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182AbZKRVeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 16:34:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932114AbZKRVeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 16:34:03 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:38581 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103AbZKRVeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 16:34:03 -0500
Date: Wed, 18 Nov 2009 21:33:55 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: David Zeuthen <david@fubar.dk>, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, linux-hotplug@vger.kernel.org
Subject: Re: [PATCH] [RFC] Add support for uevents on block device idle
	changes
Message-ID: <20091118213355.GA16630@srcf.ucam.org>
References: <ac3eb2510911170755i5188fb53ud2d6012a2db8c00a@mail.gmail.com> <1258474180.16176.62.camel@localhost.localdomain> <20091117185742.GA19829@srcf.ucam.org> <ac3eb2510911181130l6f25642cy1d5332f79a112cf9@mail.gmail.com> <20091118194053.GB12944@srcf.ucam.org> <ac3eb2510911181147ufeacb58u5194b0e1e5fd86d6@mail.gmail.com> <20091118195342.GA13627@srcf.ucam.org> <ac3eb2510911181203r1be5c3dajdacec94f196d550c@mail.gmail.com> <20091118200712.GA14026@srcf.ucam.org> <ac3eb2510911181306g221e8940xfbcf8b8e7fa9a56e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510911181306g221e8940xfbcf8b8e7fa9a56e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 10:06:33PM +0100, Kay Sievers wrote:

> That's true, but I think there is a significant difference between
> polling every one or two seconds for media changes, and usually one or
> two minutes for a disk idle. It's not that we poll in a rather hight
> frequency, in an arbitrary interval, and check if some condition is
> met.

My use cases are on the order of a second.

> I still don't think that we should add new event interfaces which are
> single-subscriber only, and use global values for a specific user.
> What if there will be another independent user for this, which might
> want a different timeout? They fight over the trigger value to set in
> sysfs?

You can trivially multiplex without any additional wakeups. Something 
like devkit-disks can simply trigger on the lowest requested time and 
then schedule wakeups for subscribers who want a different timeout.

> From my perspective, the once-at-timeout wakeup is more acceptable
> than an in-kernel policy setting for a single-subscriber event
> interface.

I'd be open to it being something for multiple subscribers, though that 
would add to the complexity in the block code and I'm not sure that's 
needed.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
