Return-Path: <linux-kernel-owner+w=401wt.eu-S1755204AbZG1Rzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbZG1Rzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbZG1Rzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:55:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35621 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606AbZG1Rzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:55:38 -0400
Date: Tue, 28 Jul 2009 20:54:35 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: davidel@xmailserver.org, avi@redhat.com, gleb@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH-RFC 0/2] eventfd: new EFD_STATE flag
Message-ID: <20090728175435.GA21549@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davide, all,

This RFC series implements a new EFD_STATE flag for eventfd.
When set, this changes eventfd behaviour in the following way:
- write simply stores the value written, and is always non-blocking
- read unblocks when the value written changes, and
  returns the value written

Motivation: we'd like to use eventfd in qemu to pass interrupts from
(emulated or assigned) devices to guest. For level interrupts, the
counter supported currently by eventfd is not a good match: we really
need to set interrupt to a level, typically 0 or 1, wake the guest if
there was a change and and give the guest ability to see the last value
written.

Does extending eventfd in this way make sense?  Please comment.

Michael S. Tsirkin (2):
  eventfd: reorganize the code to simplify new flags
  eventfd: EFD_STATE flag

 fs/eventfd.c            |   83 +++++++++++++++++++++++++++++++++++++++--------
 include/linux/eventfd.h |    3 +-
 2 files changed, 71 insertions(+), 15 deletions(-)
