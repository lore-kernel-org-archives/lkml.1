Return-Path: <linux-kernel-owner+w=401wt.eu-S1754962Ab0A1WqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab0A1WqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 17:46:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600Ab0A1WqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 17:46:08 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:56754 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754537Ab0A1WqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 17:46:07 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, jy0922.shim@samsung.com,
       mika.kuoppala@nokia.com, peter.hutterer@who-t.net,
       Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 2/2] input: mt: update the multi-touch protocol documentation
Date: Thu, 28 Jan 2010 23:42:49 +0100
Message-Id: <1264718569-9772-2-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1264718569-9772-1-git-send-email-rydberg@euromail.se>
References: <1264718569-9772-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1Nad7a-0001eZ-Bh.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1Nad7a-0001eZ-Bh 392816e8f2156ecb18794f038b6276bb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch documents a new ABS_MT parameter and adds further text to
clarify some points around the MT protocol.

Requested-by: Yoonyoung Shim <jy0922.shim@samsung.com>
Requested-by: Mika Kuoppala <mika.kuoppala@nokia.com>
Requested-by: Peter Hutterer <peter.hutterer@who-t.net>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 Documentation/input/multi-touch-protocol.txt |   48 +++++++++++++++++++++----
 1 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/Documentation/input/multi-touch-protocol.txt b/Documentation/input/multi-touch-protocol.txt
index a12ea3b..8490480 100644
--- a/Documentation/input/multi-touch-protocol.txt
+++ b/Documentation/input/multi-touch-protocol.txt
@@ -27,12 +27,30 @@ set of events/packets.
 
 A set of ABS_MT events with the desired properties is defined. The events
 are divided into categories, to allow for partial implementation.  The
-minimum set consists of ABS_MT_TOUCH_MAJOR, ABS_MT_POSITION_X and
-ABS_MT_POSITION_Y, which allows for multiple fingers to be tracked.  If the
-device supports it, the ABS_MT_WIDTH_MAJOR may be used to provide the size
-of the approaching finger. Anisotropy and direction may be specified with
-ABS_MT_TOUCH_MINOR, ABS_MT_WIDTH_MINOR and ABS_MT_ORIENTATION.  The
-ABS_MT_TOOL_TYPE may be used to specify whether the touching tool is a
+minimum set consists of ABS_MT_POSITION_X and ABS_MT_POSITION_Y, which
+allows for multiple fingers to be tracked.  If the device supports it, the
+ABS_MT_TOUCH_MAJOR and ABS_MT_WIDTH_MAJOR may be used to provide the size
+of the contact area and approaching finger, respectively.
+
+The TOUCH and WIDTH parameters have a geometrical interpretation; imagine
+looking through a window at someone gently holding a finger against the
+glass.  You will see two regions, one inner region consisting of the part
+of the finger actually touching the glass, and one outer region formed by
+the perimeter of the finger. The diameter of the inner region is the
+ABS_MT_TOUCH_MAJOR, the diameter of the outer region is
+ABS_MT_WIDTH_MAJOR. Now imagine the person pressing the finger harder
+against the glass. The inner region will increase, and in general, the
+ratio ABS_MT_TOUCH_MAJOR / ABS_MT_WIDTH_MAJOR, which is always smaller than
+unity, is related to the finger pressure. For pressure-based devices,
+ABS_MT_PRESSURE may be used to provide the pressure on the contact area
+instead.
+
+In addition to the MAJOR parameters, the oval shape of the finger can be
+described by adding the MINOR parameters, such that MAJOR and MINOR are the
+major and minor axis of an ellipse. Finally, the orientation of the oval
+shape can be describe with the ORIENTATION parameter.
+
+The ABS_MT_TOOL_TYPE may be used to specify whether the touching tool is a
 finger or a pen or something else.  Devices with more granular information
 may specify general shapes as blobs, i.e., as a sequence of rectangular
 shapes grouped together by an ABS_MT_BLOB_ID. Finally, for the few devices
@@ -42,11 +60,9 @@ report finger tracking from hardware [5].
 Here is what a minimal event sequence for a two-finger touch would look
 like:
 
-   ABS_MT_TOUCH_MAJOR
    ABS_MT_POSITION_X
    ABS_MT_POSITION_Y
    SYN_MT_REPORT
-   ABS_MT_TOUCH_MAJOR
    ABS_MT_POSITION_X
    ABS_MT_POSITION_Y
    SYN_MT_REPORT
@@ -87,6 +103,12 @@ the contact. The ratio ABS_MT_TOUCH_MAJOR / ABS_MT_WIDTH_MAJOR approximates
 the notion of pressure. The fingers of the hand and the palm all have
 different characteristic widths [1].
 
+ABS_MT_PRESSURE
+
+The pressure, in arbitrary units, on the contact area. May be used instead
+of TOUCH and WIDTH for pressure-based devices or any device with a spatial
+signal intensity distribution.
+
 ABS_MT_ORIENTATION
 
 The orientation of the ellipse. The value should describe a signed quarter
@@ -170,6 +192,16 @@ There are a few devices that support trackingID in hardware. User space can
 make use of these native identifiers to reduce bandwidth and cpu usage.
 
 
+Gestures
+--------
+
+In the specific application of creating gesture events, the TOUCH and WIDTH
+parameters can be used to, e.g., approximate finger pressure or distinguish
+between index finger and thumb. With the addition of the MINOR parameters,
+one can also distinguish between a sweeping finger and a pointing finger,
+and with ORIENTATION, one can detect twisting of fingers.
+
+
 Notes
 -----
 
-- 
1.6.3.3

