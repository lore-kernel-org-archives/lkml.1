Return-Path: <linux-kernel-owner+w=401wt.eu-S1753259AbZGOHyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbZGOHyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 03:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbZGOHya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 03:54:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:41979 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbZGOHy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 03:54:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,403,1243839600"; 
   d="scan'208";a="430350314"
Subject: Re: [PATCH 1/3] backlight: Allow drivers to update the core, and
	generate events on changes
From: Zhang Rui <rui.zhang@intel.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Matthew Garrett <mjg@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "lenb@kernel.org" <lenb@kernel.org>,
       "corentincj@iksaif.net" <corentincj@iksaif.net>
In-Reply-To: <1247574573.23871.8.camel@dax.rpnet.com>
References: <1247517685-7719-1-git-send-email-mjg@redhat.com>
	 <1247574573.23871.8.camel@dax.rpnet.com>
Content-Type: text/plain
Date: Wed, 15 Jul 2009 15:55:18 +0800
Message-Id: <1247644518.26272.88.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-14 at 20:29 +0800, Richard Purdie wrote:
> On Mon, 2009-07-13 at 21:41 +0100, Matthew Garrett wrote:
> > Certain hardware will send us events when the backlight brightness
> > changes. Add a function to update the value in the core, and
> > additionally send a uevent so that userspace can pop up appropriate
> > UI. The uevents are flagged depending on whether the update originated
> > in the kernel or from userspace, making it easier to only display UI
> > at the appropriate time.
> 
> This looks good and I like the idea. 
> 
> My main concern is that we don't start getting bug reports of 'missing'
> events and have clearly defined expectations of when we see what kind of
> events. For example, should an event be emitted when low battery causes
> the backlight to be limited? How about console blanking events turning
> off the backlight? Are there any other occasions we should be emitting
> change events and do we need to audit other drivers?
> 
> I did look to see if we could integrate this more into the backlight
> core but that doesn't look to be possible unfortunately, at least not
> without changing the drivers which these patches start.
> 
> Also, are "userspace" and "kernel" as meaningful as they could be? Would
> "sysfs" and "hwkeys" make more sense and allow for other future hardware
> differences? Perhaps someone will tie the backlight to an ambient light
> sensor for example...
> 

Hah, I just finished a patch to introduce the ACPI als driver.

I'm not quite familiar with the status of ALS support in Linux kernel.
and here is my questions,
I don't think we have a generic sysfs driver for ALS, i.e. ALS class
device, right?
do you guys think it's reasonable to have one?

thanks,
rui

