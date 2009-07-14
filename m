Return-Path: <linux-kernel-owner+w=401wt.eu-S1752611AbZGNMdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbZGNMdD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 08:33:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbZGNMdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 08:33:03 -0400
Received: from dan.rpsys.net ([93.97.175.187]:64691 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541AbZGNMdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 08:33:02 -0400
Subject: Re: [PATCH 1/3] backlight: Allow drivers to update the core, and
	generate events on changes
From: Richard Purdie <rpurdie@rpsys.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, lenb@kernel.org,
       rui.zhang@intel.com, corentincj@iksaif.net
In-Reply-To: <1247517685-7719-1-git-send-email-mjg@redhat.com>
References: <1247517685-7719-1-git-send-email-mjg@redhat.com>
Content-Type: text/plain
Date: Tue, 14 Jul 2009 13:29:33 +0100
Message-Id: <1247574573.23871.8.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-13 at 21:41 +0100, Matthew Garrett wrote:
> Certain hardware will send us events when the backlight brightness
> changes. Add a function to update the value in the core, and
> additionally send a uevent so that userspace can pop up appropriate
> UI. The uevents are flagged depending on whether the update originated
> in the kernel or from userspace, making it easier to only display UI
> at the appropriate time.

This looks good and I like the idea. 

My main concern is that we don't start getting bug reports of 'missing'
events and have clearly defined expectations of when we see what kind of
events. For example, should an event be emitted when low battery causes
the backlight to be limited? How about console blanking events turning
off the backlight? Are there any other occasions we should be emitting
change events and do we need to audit other drivers?

I did look to see if we could integrate this more into the backlight
core but that doesn't look to be possible unfortunately, at least not
without changing the drivers which these patches start.

Also, are "userspace" and "kernel" as meaningful as they could be? Would
"sysfs" and "hwkeys" make more sense and allow for other future hardware
differences? Perhaps someone will tie the backlight to an ambient light
sensor for example...

Cheers,

Richard

-- 
Richard Purdie
Intel Open Source Technology Centre

