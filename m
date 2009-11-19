Return-Path: <linux-kernel-owner+w=401wt.eu-S1752316AbZKSNBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbZKSNBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:01:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbZKSNBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:01:13 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:58362 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbZKSNBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:01:13 -0500
Date: Thu, 19 Nov 2009 13:01:07 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: David Zeuthen <david@fubar.dk>, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, linux-hotplug@vger.kernel.org
Subject: Re: [PATCH] [RFC] Add support for uevents on block device idle
	changes
Message-ID: <20091119130107.GB20949@srcf.ucam.org>
References: <20091117185742.GA19829@srcf.ucam.org> <ac3eb2510911181130l6f25642cy1d5332f79a112cf9@mail.gmail.com> <20091118194053.GB12944@srcf.ucam.org> <ac3eb2510911181147ufeacb58u5194b0e1e5fd86d6@mail.gmail.com> <20091118195342.GA13627@srcf.ucam.org> <ac3eb2510911181203r1be5c3dajdacec94f196d550c@mail.gmail.com> <20091118200712.GA14026@srcf.ucam.org> <ac3eb2510911181306g221e8940xfbcf8b8e7fa9a56e@mail.gmail.com> <20091118213355.GA16630@srcf.ucam.org> <ac3eb2510911190309y6d0d8445wd907fc5664595c6f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510911190309y6d0d8445wd907fc5664595c6f@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 12:09:30PM +0100, Kay Sievers wrote:
> On Wed, Nov 18, 2009 at 22:33, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > My use cases are on the order of a second.
> 
> Ok, what's the specific use case, which should be triggered after a
> second? I thought you were thinking about disk spindown or similar.

The first is altering ALPM policy. ALPM will be initiated by the host if 
the number of queued requests hits zero - if there's no hysteresis 
implemented, then that can result in a significant performance hit. We 
don't need /much/ hysteresis, but it's the difference between a 50% 
performance hit and not having that.

The other I'm currently looking at is monitoring disk usage in order to 
be able to apply an adaptive policy to disk spindown. This doesn't need 
the information to be as accurate, but it would still be better at 
closer to the second granularity than the minute level.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
