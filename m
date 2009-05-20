Return-Path: <linux-kernel-owner+w=401wt.eu-S1755783AbZETDAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbZETDAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 23:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbZETDAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 23:00:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:30016 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbZETDAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 23:00:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=jMsLc95QMy2srK8rWfkA3+EZJmOXlqSnMWF3Io2LJeUYvk2CKPR8Nf3ZRJr134mTNK
         afkSVc2As3N4TEw1B72jN/uCbO5qryjOOhDPOVARyN1KyoX7nl/1i/zruHhn1TWE2W7a
         hii1/nz5uh2y8VzA3s1U1luv4oCn5CDLsN/X0=
Date: Tue, 19 May 2009 19:59:57 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: mt: Augment the event semantics documentation
Message-ID: <20090520025957.GE17649@dtor-d630.eng.vmware.com>
References: <1242593479-9238-1-git-send-email-rydberg@euromail.se> <1242593479-9238-2-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1242593479-9238-2-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Sun, May 17, 2009 at 10:51:19PM +0200, Henrik Rydberg wrote:
> Through the collaboration to adapt the N-trig and Stantum HID
> drivers to the MT protocol, some semantic clarifications to the
> protocol have been made. This patch adds them to the MT documentation.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> Tested-by: Stéphane Chatty <chatty@enac.fr>

I was wondering if the following changes would not make the text a bit
better:

diff --git a/Documentation/input/multi-touch-protocol.txt b/Documentation/input/multi-touch-protocol.txt
index dd755c2..12f98fb 100644
--- a/Documentation/input/multi-touch-protocol.txt
+++ b/Documentation/input/multi-touch-protocol.txt
@@ -21,9 +21,9 @@ packet. The end of a packet is marked by calling the input_mt_sync()
 function, which generates a SYN_MT_REPORT event. This instructs the
 receiver to accept the data for the current finger and prepare to receive
 another. The end of a multi-touch transfer is marked by calling the usual
-input_sync() function. This instructs the receiver to perform actions based
-on the received packets, and prepare to receive a new set of finger
-packets.
+input_sync() function. This instructs the receiver to act upon events
+accumulated since last EV_SYN/SYN_REPORT and prepare to receive a new
+set of events/packets.
 
 A set of ABS_MT events with the desired properties is defined. The events
 are divided into categories, to allow for partial implementation.  The
@@ -79,8 +79,8 @@ ABS_MT_ORIENTATION
 The orientation of the ellipse. The value should describe a signed quarter
 of a revolution clockwise around the touch center. The signed value range
 is arbitrary, but zero should be returned for a finger aligned along the Y
-axis of the surface, something negative when twisted to the left, and
-something positive when twisted to the right. When completely aligned with
+axis of the surface, a negative value when finger is turned to the left, and
+a positive value when finger turned to the right. When completely aligned with
 the X axis, the range max should be returned.  Orientation can be omitted
 if the touching object is circular, or if the information is not available
 in the kernel driver. Partial orientation support is possible if the device
@@ -176,7 +176,7 @@ could be used to derive tilt.
 time of writing (April 2009), the MT protocol is not yet merged, and the
 prototype implements finger matching, basic mouse support and two-finger
 scrolling. The project aims at improving the quality of current multi-touch
-functionality available in the synaptics X driver, and in addition
+functionality available in the Synaptics X driver, and in addition
 implement more advanced gestures.
 [4] See the section on event computation.
 [5] See the section on finger tracking.


-- 
Dmitry
