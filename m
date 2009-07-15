Return-Path: <linux-kernel-owner+w=401wt.eu-S1753257AbZGOIhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbZGOIhj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 04:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbZGOIhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 04:37:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:43399 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970AbZGOIhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 04:37:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,403,1243839600"; 
   d="scan'208";a="474990369"
Subject: Re: [PATCH 1/3] backlight: Allow drivers to update the core, and
	generate events on changes
From: Zhang Rui <rui.zhang@intel.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Matthew Garrett <mjg@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "lenb@kernel.org" <lenb@kernel.org>,
       "corentincj@iksaif.net" <corentincj@iksaif.net>
In-Reply-To: <1247646153.6248.3.camel@dax.rpnet.com>
References: <1247517685-7719-1-git-send-email-mjg@redhat.com>
	 <1247574573.23871.8.camel@dax.rpnet.com>
	 <1247644518.26272.88.camel@rzhang-dt>
	 <1247646153.6248.3.camel@dax.rpnet.com>
Content-Type: text/plain
Date: Wed, 15 Jul 2009 16:38:25 +0800
Message-Id: <1247647105.26272.99.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-15 at 16:22 +0800, Richard Purdie wrote:
> On Wed, 2009-07-15 at 15:55 +0800, Zhang Rui wrote:
> > > Also, are "userspace" and "kernel" as meaningful as they could be?
> > Would
> > > "sysfs" and "hwkeys" make more sense and allow for other future hardware
> > > differences? Perhaps someone will tie the backlight to an ambient light
> > > sensor for example...
> > > 
> > 
> > Hah, I just finished a patch to introduce the ACPI als driver.
> > 
> > I'm not quite familiar with the status of ALS support in Linux kernel.
> > and here is my questions,
> > I don't think we have a generic sysfs driver for ALS, i.e. ALS class
> > device, right?
> > do you guys think it's reasonable to have one?
> 
> We don't have one that I'm aware of.
> 
> The first question is what information and configuration options are we
> likely to have with ALS sensors? If its just a light level reading, the
> input subsystem is ideally suited for sharing that. Is there
> configuration we need to expose?
> 
For an ACPI ALS device, only these two are mandatory
1. the current ambient light illuminance.
2. A list of luminance mappings, including the "display luminance
adjustment" and "ambient light illuminance", which can be used by OS to
determine the ambient light policy.

IMO, the ALS driver should just export these info to user space, and we
can do the display backlight adjustment in user space,
via /sys/class/backlight.

thanks,
rui


