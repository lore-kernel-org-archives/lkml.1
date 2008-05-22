Return-Path: <linux-kernel-owner+w=401wt.eu-S935604AbYEVVYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935604AbYEVVYA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933784AbYEVVWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:22:38 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49172 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933700AbYEVVWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:22:36 -0400
Date: Thu, 22 May 2008 13:34:03 -0700
From: Greg KH <greg@kroah.com>
To: Sean Hefty <sean.hefty@intel.com>
Cc: rolandd@cisco.com, hal.rosenstock@gmail.com, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org
Subject: question about drivers/infiniband/core/cm.c's kobject usage
Message-ID: <20080522203403.GA27263@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was working on some changes to the driver core that is cleaning up the
struct class fields, when I ran accross the usage of cm.c and the
infiniband_cm class.

It looks like you are registering "raw" kobjects in this class, chaining
things off of it, as if they were devices.

If so, why not just use struct device in the first place?  You are
creating a tree, which on modern distros, userspace will never see as
they are expecting everything to be showing up in /sys/devices/

Entries in /sys/class/*/* now are symlinks into the /sys/devices tree,
showing the representation of everything in one tree, not lots of little
trees all over the place.

So I was curious, was this done on purpose?  If so, why?  If not, any
objection to me switching it over to be using struct device properly?

thanks,

greg k-h
