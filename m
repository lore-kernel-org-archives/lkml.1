Return-Path: <linux-kernel-owner+w=401wt.eu-S933381AbYCSXLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933381AbYCSXLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937874AbYCSVgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:36:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933045AbYCSVgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:36:42 -0400
Date: Tue, 18 Mar 2008 13:21:13 -0400
From: Bill Nottingham <notting@redhat.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kay.sievers@vrfy.org
Subject: race between SCSI uevents and media detection
Message-ID: <20080318172113.GB3089@nostromo.devel.redhat.com>
Mail-Followup-To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	kay.sievers@vrfy.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For a typical livecd boot using udev, you'd check for the root device
with a udev rule like:

KERNEL=="sr[0-9]", PROGRAM=="/lib/udev/vol_id -l %N", RESULT="<some label>",
	SYMLINK+="root"

This creates a /dev/root symlink to whichever CD device holds the proper
CD/DVD.

However, this currently fails repeatedly on some machines, as the run
of vol_id gets ENOMEDIUM attempting to open the CD device. I suspect
this is because the initial medium scan is actually done after the
uevent for /dev/sr0 is emitted.

Can the open path be fixed to block until the medium state is initially
known? I don't see how this can be worked around from userspace - you
don't get another uevent for the media detection.

Bill
