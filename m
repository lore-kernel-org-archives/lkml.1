Return-Path: <linux-kernel-owner+w=401wt.eu-S1757201AbZGPClB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbZGPClB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 22:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757165AbZGPClB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 22:41:01 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52693 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757154AbZGPClA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 22:41:00 -0400
Date: Thu, 16 Jul 2009 03:40:57 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Richard Purdie <rpurdie@rpsys.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "lenb@kernel.org" <lenb@kernel.org>,
       "corentincj@iksaif.net" <corentincj@iksaif.net>
Subject: Re: [PATCH 1/3] backlight: Allow drivers to update the core, and
	generate events on changes
Message-ID: <20090716024057.GA2461@srcf.ucam.org>
References: <1247517685-7719-1-git-send-email-mjg@redhat.com> <1247574573.23871.8.camel@dax.rpnet.com> <1247644518.26272.88.camel@rzhang-dt> <1247646153.6248.3.camel@dax.rpnet.com> <1247647105.26272.99.camel@rzhang-dt> <1247649089.20241.5.camel@dax.rpnet.com> <20090715135808.GA19054@srcf.ucam.org> <1247711974.26272.190.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247711974.26272.190.camel@rzhang-dt>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 10:39:34AM +0800, Zhang Rui wrote:
> On Wed, 2009-07-15 at 21:58 +0800, Matthew Garrett wrote:
> > On Wed, Jul 15, 2009 at 10:11:29AM +0100, Richard Purdie wrote:
> > 
> > > So there are basically two values we're ever interested in at a given
> > > point in time. The current ambient light reading and the corresponding
> > > display luminance adjustment. Both of those could just be exposed as an
> > > input device really?
> > 
> > The alternative would be hwmon, I guess.
> 
> you mean convert an ACPI ALS device to a hwmon device?

Yes.

> > You want smoothing even in a default policy, and doing that well might 
> > be a bit much for the kernel?
> > 
> sorry, I don't understand.
> do you mean that there should be a default policy in the kernel?

No, I mean that the only default policy you could reasonably have in the 
kernel would be tying the backlight directly to the ALS. And that sucks. 
You need some degree of smoothing, and that's a job better left to 
userspace.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
