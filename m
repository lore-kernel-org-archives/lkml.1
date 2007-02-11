Return-Path: <linux-kernel-owner+w=401wt.eu-S932580AbXBKWUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580AbXBKWUp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 17:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932588AbXBKWUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 17:20:44 -0500
Received: from llsb232-a02.servidoresdns.net ([82.223.190.38]:37324 "EHLO
	llsb232-a02.servidoresdns.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932580AbXBKWU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 17:20:27 -0500
X-Greylist: delayed 1236 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Feb 2007 17:20:27 EST
Message-ID: <45CF91D2.4060508@albentia.com>
Date: Sun, 11 Feb 2007 22:59:46 +0100
From: Iratxo Pichel Ortiz <ipichel@albentia.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Multicast "ipmr.c" misunderstood / bug / new feature.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi !

I have been working with multicast routing to build a multicast router.
The target system uses static multicast routers and we have used
smcroute user-space daemon. After some issues with that sofware I have
built a some kind of custom daemon.

This router has support for hotpluggable interfaces like wifi and usb ones.

I think that there is something I don't understand or is not supported
in the net/ipv4/ipmr.c Kernel router. This routing system registers the
function "ipmr_device_event" as a notifier so that when a device is
unregistered from the system the correspondings multicast virtual
interfaces are also unregistered.

This is fine, but the problem is that the function "vif_delete()", used
in the notifier and in the corresponding IOCTL does not release the
active routes (mfc_cache entries). When doing "cat /proc/net/ip_mr_vif"
the unregistered interfaces are no longer available, but when doing "cat
/proc/net/ip_mr_cache" weird entries are displayed. If the unregistered
device was an output vif the route entry is shown with no output vif. If
it was an input vif  the entry is shown but not really valid.

I don't know if this is really the expected behaviour of the multicast
routing system or even this is the correct place to ask.

I have coded a small patch for the ipmr.c file that purges all the
routes related to a device when it is unregistered, leaving the tables
in a coherent state always. I am know debugging this feature.

So: Is this the correct behaviour or is a bug? And is this patch
interesting for the Kernel?

Thank you very much,

    Iratxo Pichel Ortiz.
