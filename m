Return-Path: <linux-kernel-owner+w=401wt.eu-S1752745AbZEIOmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbZEIOmo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 10:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbZEIOme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 10:42:34 -0400
Received: from kroah.org ([198.145.64.141]:54163 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbZEIOme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 10:42:34 -0400
Date: Sat, 9 May 2009 07:37:42 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>
Subject: [patch 00/13] devtmpfs patches
Message-ID: <20090509143742.GA27663@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the latest version of the devtmpfs patch, broken up into 13
different patches to make it easier to review and merge properly.

This series does the following:
  - creates a new callback within the driver core to allow drivers and
    subsystems to provide a name for their subsystem to properly reflect
    what userspace should use for their device nodes.  This allows for
    things like the sound/ and input/ subdirectories to be properly told
    to userspace.  Note these names and subdirectories are the ones that
    have been used for years, and are standardized across all
    distributions and synced up with the LANANA naming scheme which is
    specified by LSB.  We aren't creating anything new here.
  - fills in the callbacks by the various subsystems that need to define
    it, including the misc device layer.  This is the majority of the
    patches in the series.
  - adds the devtmpfs core code.  Description of what this is, why it is
    needed, and how it works is within this patch.

All of these patches have been tested for a number of weeks now in
SuSE's kernel trees and have proved to increase boot time a measurable
ammount (a few seconds at the very least) on both traditional systems
(servers / desktops) as well as on netbooks using a non-SuSE based
userspace infrastructure.

This feature also allows rescue systems to work properly by allowing
systems to boot into /bin/bash with full access to all of their device
nodes.  It is also a big win on embedded systems with no local users yet
they need to provide dynamic names as their hardware configuration can
be changed by external forces.

All of the previous objections to this patch series seems to have been
properly addressed, but as always, comments are welcome, just make them
substantial please :)

These patches are now in the driver-core git tree of quilt patches.

thanks,

greg k-h

