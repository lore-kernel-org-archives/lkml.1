Return-Path: <linux-kernel-owner+w=401wt.eu-S1760917AbYBTJjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760917AbYBTJjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 04:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756454AbYBTJjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 04:39:03 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:44154 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115AbYBTJjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 04:39:00 -0500
Message-ID: <47BBF532.4030704@s5r6.in-berlin.de>
Date: Wed, 20 Feb 2008 10:38:58 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Karl Dahlke <eklhad@comcast.net>
CC: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, Valdis.Kletnieks@vt.edu
Subject: Re: adapter, what's in a name
References: <20080119181606.eklhad@comcast.net>
In-Reply-To: <20080119181606.eklhad@comcast.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karl Dahlke wrote:
> The longer I stay on this list, the more I will learn.
> But it's high volume, so I may not be able to stay for long.

Because of the high volume at this list, it is essential that
  - you keep everyone who posted in a tread in the Cc: list of your
    replies, (that way it is possible to discuss on LKML even with
    people who are not subscribed; but more importantly, people who
    take part in a discussion are less likely to miss replies),
  - you actually reply rather than start new threads all the time.

So, as Randy already asked you, please use reply-to-all when continuing
this discussion.  That way (and with other measures like good subjects,
or respectively keeping the subject in replies if applicable) the list
volume becomes easily manageable.

> Drivers and modules designed to make linux more accessible
> could be placed in drivers/accessibility in the source tree.
> It's just a suggestion.
> If there is a better word for this concept, please let me know.
> 
> And I finally understand what you are trying to say about /proc.
> Processes, and perhaps memory and raid by extension,
> but not everything under the planet.
> Would it be better for accessibility drivers to create files through sysfs, e.g.
> /sys/accessibility/jupiter/synth
> Naturally the jupiter subtree would appear when that module was loaded,
> and disappear when it was removed.

Aren't those drivers ones for
  - input devices,
  - display devices (in a more general sense than visual displays, i.e.
    also including audible and tactile displays)?
Besides, if you had for example an USB device of that type, the most
natural place for its sources would be somewhere beneath drivers/usb/.

About the userspace interfaces of such drivers:

  - As was noted, /proc is generally not for userspace ABIs except to
expose properties of processes and a few selected other core properties
of the kernel.

  - /sys is for userspace ABIs which specifically pertain to properties
of kernel objects, notably properties of the kernel representations of
devices and of kernel modules.  Have a look into /sys/devices, /sys/bus,
and /sys/modules to get an idea.  Note, a lot of what is exposed in /sys
does not constitute stable long-time supported ABIs; see
Documentation/sysfs-rules.txt.

  - There are other types of ABIs for I/O (character device files, block
device files), message-based(?) I/O (netlink), configuration (configfs),
and more.

I have no idea what kind of communication with userspace the various
accessibility related drivers maintain.
-- 
Stefan Richter
-=====-==--- --=- =-=--
http://arcgraph.de/sr/
