Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099AbZKRVpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbZKRVpM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 16:45:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbZKRVpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 16:45:11 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:43377 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbZKRVpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 16:45:10 -0500
Date: Wed, 18 Nov 2009 21:45:06 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: David Zeuthen <david@fubar.dk>, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, linux-hotplug@vger.kernel.org
Subject: Re: [PATCH] [RFC] Add support for uevents on block device idle
	changes
Message-ID: <20091118214506.GA17019@srcf.ucam.org>
References: <ac3eb2510911181130l6f25642cy1d5332f79a112cf9@mail.gmail.com> <20091118194053.GB12944@srcf.ucam.org> <ac3eb2510911181147ufeacb58u5194b0e1e5fd86d6@mail.gmail.com> <20091118195342.GA13627@srcf.ucam.org> <ac3eb2510911181203r1be5c3dajdacec94f196d550c@mail.gmail.com> <20091118200712.GA14026@srcf.ucam.org> <ac3eb2510911181306g221e8940xfbcf8b8e7fa9a56e@mail.gmail.com> <ac3eb2510911181329v26c334a3oab9c554ec64ad0d5@mail.gmail.com> <20091118213526.GB16630@srcf.ucam.org> <ac3eb2510911181339q616c56f7rd31b93caed0286c5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510911181339q616c56f7rd31b93caed0286c5@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 10:39:26PM +0100, Kay Sievers wrote:
> On Wed, Nov 18, 2009 at 22:35, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > On Wed, Nov 18, 2009 at 10:29:23PM +0100, Kay Sievers wrote:
> >
> >> I guess, the "idle_since" file could be made poll()able, and throw an
> >> event when the idle time is re-set to 0, so the value checking needs
> >> only to happen as long we wait for the disk to become idle. As long as
> >> it's busy anyway, the rare wakeups should not matter much. :)
> >
> > That'd be a userspace wakeup every time something gets submitted to the
> > block device, which sounds far from ideal...
> 
> No, you would only poll() when you reached the timeout and the disk
> entered the idle state. This can not happen more frequently than the
> timeout itself.

I don't understand. idle_since would be reset on every access to the 
block device. The alternative is to generate an event when the disk goes 
idle, but that goes back to requiring a timer in the kernel...

-- 
Matthew Garrett | mjg59@srcf.ucam.org
