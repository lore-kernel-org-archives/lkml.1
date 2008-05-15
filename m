Return-Path: <linux-kernel-owner+w=401wt.eu-S1761929AbYEOQd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761929AbYEOQd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 12:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758257AbYEOQdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 12:33:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757406AbYEOQdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 12:33:16 -0400
Date: Thu, 15 May 2008 12:33:15 -0400
From: Bill Nottingham <notting@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: Problems with suspend and USB storage
Message-ID: <20080515163315.GA17779@nostromo.devel.redhat.com>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've been testing suspend/hibernate with various USB devices under
2.6.25.2. Test box is a Thinkpad T60 (uhci, ehci).
The results are somewhat dismal.

Using USB as a hibernate device:
- A directly connected USB stick works OK as a hibernate device
- A directly connected USB hard drive works OK as a hibernate device
- A USB stick connected via an ExpressCard reader does not - it appears
  to just not be there when the hibernate code attemps to write
  the data.

On resume (from either hibernate or suspend from RAM):
- Any 'in use' USB storage, whether it be as swap (a hibernate device),
  or a mounted filesystem, immediately generates errors on resume. It
  appears the filesystem and/or swap tasks are woken up before the
  actual USB device - it enumerates the disks after the errors have
  already been thrown.
- As a consequence, the USB devices shift their device names
- Using USB_PERSIST has no effect on this problem
- This appears to happen for all USB connection types (hard drive,
  stick, via ExpressCard reader.)

Is there any way to get sane behavior out of suspend/resume with
USB storage?

Bill
