Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbZHNABf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbZHNABf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 20:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753540AbZHNABe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 20:01:34 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:47528 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbZHNABd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 20:01:33 -0400
MIME-Version: 1.0
Date: Fri, 14 Aug 2009 10:01:34 +1000
Message-ID: <1d3f23370908131701w50f2c550r312b14b2c7f2d12c@mail.gmail.com>
Subject: GPIOLIB, GPIO_SYS and port-wide accesses
From: John Williams <john.williams@petalogix.com>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Cc: John Linn <John.Linn@xilinx.com>,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       David DeBonis <david.debonis@xilinx.com>,
       Michal Simek <michal.simek@petalogix.com>,
       Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As I see it the gpiolib and sysfs export insists on single bit
accesses even on gpio pins that are located on the same physical
device/port.

A couple of years ago there was mention of port-wide accesses being a
good thing:

http://lkml.indiana.edu/hypermail/linux/kernel/0608.0/0731.html
(towards the bottom)

Did anything ever come of that?

Per-bit access is pretty inflexible if you are driving a 7-segment
display or 8-LED bar display, holding lots of file descriptors open
etc, and lots of syscall overhead.

sysfs syntax like

$ echo "240-247" > export
$ echo 255 > gpio240-247/direction  (8-bit binary mask - output)
$ echo 255 > gpio240-247/value (all ones)

would be reasonably friendly, obviously the underlying gpiolib would
have to have some notion of coupled ports.

Any thoughts?

John
-- 
John Williams,
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com  p: +61-7-30090663  f: +61-7-30090663
