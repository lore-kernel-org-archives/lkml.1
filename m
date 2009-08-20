Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbZHTP6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbZHTP6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 11:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750815AbZHTP6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 11:58:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbZHTP6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 11:58:17 -0400
Date: Thu, 20 Aug 2009 18:56:55 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: davidel@xmailserver.org, avi@redhat.com, gleb@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] eventfd: new EFD_STATE flag
Message-ID: <20090820155655.GA8764@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davide,
Looks like I got an ack from Avi and no comments from others,
so the following patchset is identical to the last RFC.
Can it be merged for 2.6.32?
Thanks!

This series implements a new EFD_STATE flag for eventfd.
When set, this changes eventfd behaviour in the following way:
- write simply stores the value written, and is always non-blocking
- read unblocks when the value written changes, and
  returns the value written

Motivation: we'd like to use eventfd in qemu to pass interrupts from
(emulated or assigned) devices to guest. For level interrupts, the
counter supported currently by eventfd is not a good match: we really
need to set interrupt to a level, typically 0 or 1, wake the guest if
there was a change and give the guest ability to see the last value
written. The level can be set either from kernel (e.g. with assigned
devices) or from userspace.

Michael S. Tsirkin (2):
  eventfd: reorganize the code to simplify new flags
  eventfd: EFD_STATE flag

 fs/eventfd.c            |   83 +++++++++++++++++++++++++++++++++++++++--------
 include/linux/eventfd.h |    3 +-
 2 files changed, 71 insertions(+), 15 deletions(-)
