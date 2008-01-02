Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbYABPfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbYABPfP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 10:35:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbYABPfC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 10:35:02 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42072 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387AbYABPfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 10:35:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [ANNOUNCE] Userland suspend/hibernation tool v0.8 released
Date: Wed, 2 Jan 2008 16:36:35 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>,
       "suspend-devel List" <suspend-devel@lists.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801021636.35851.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New version 0.8 of the userland suspend/hibernation tools (aka uswsusp) has
been released.  The source code package is available for download at:

http://downloads.sourceforge.net/suspend/suspend-0.8.tar.gz

(changelog and release notes within).

The following utilities are included in the package (among other things):

s2ram
- Wrapper around the kernel's suspend-to-RAM mechanism allowing the user to
  perform some graphics adapter manipulations from the user land before
  suspending and after resuming that may help to bring the graphics (and the
  entire system) back to life after the resume.  Incorporates the functionality
  of vbetool and radeontool as well as some tricks of its own.  Includes a list
  of working hardware configurations along with the appropriate sets of
  operations to be performed to resume them successfully.

s2disk
- Saves hibernation images created by the kernel using the /dev/snapshot
  special device and its ioctl interface.  Supports image compression, image
  encryption (in particular, it is possible to use RSA to safely pass the
  session key information between s2disk and its resume counterpart)
  and splash-based graphical progress meters (bootsplash, splashy and fbsplash
  are supported).

s2both
- Saves a hibernation image like s2disk and then suspends the system to RAM
  like s2ram, allowing it to either resume from RAM, if the system memory is
  still powered, or resume from the hibernation image (still considered as
  experimental).

resume
- Loads a hibernation image saved by s2disk/s2both and makes the kernel restore
  the system memory state from it using the /dev/snapshot special device and
  its ioctl interface.  Intended for running from initrd/initramfs images.
