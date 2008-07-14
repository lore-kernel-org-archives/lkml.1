Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbYGNRfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbYGNRfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 13:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbYGNRfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 13:35:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226AbYGNRfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 13:35:21 -0400
Date: Mon, 14 Jul 2008 13:28:34 -0400
From: Dave Jones <davej@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
       gregkh@suse.de
Subject: Re: usb-storage: quirk around v1.11 firmware on Nikon D4
Message-ID: <20080714172834.GA23016@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-usb@vger.kernel.org, gregkh@suse.de
References: <20080704195940.GA17510@redhat.com> <Pine.LNX.4.44L0.0807041808100.17654-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0807041808100.17654-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2008 at 06:09:25PM -0400, Alan Stern wrote:
 > On Fri, 4 Jul 2008, Dave Jones wrote:
 > 
 > > usb-storage: quirk around v1.11 firmware on Nikon D40
 > ...
 > > -UNUSUAL_DEV(  0x04b0, 0x0411, 0x0100, 0x0110,
 > > +UNUSUAL_DEV(  0x04b0, 0x0411, 0x0100, 0x0111,
 > >  		"NIKON",
 > >  		"NIKON DSC D80",
 > 
 > You updated the entry for the D80, not the D40.  Maybe they both need 
 > to be updated?

usb-storage: quirk around v1.11 firmware on Nikon D40

https://bugzilla.redhat.com/show_bug.cgi?id=454028
Just as in earlier firmware versions, we need to perform this
quirk for the latest version too.

Speculatively do the entry for the D80 too, as they seem to
have the same firmware problems historically.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 39a7c11..c0b9d10 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -358,14 +358,14 @@ UNUSUAL_DEV(  0x04b0, 0x040f, 0x0100, 0x0200,
 		US_FL_FIX_CAPACITY),
 
 /* Reported by Emil Larsson <emil@swip.net> */
-UNUSUAL_DEV(  0x04b0, 0x0411, 0x0100, 0x0110,
+UNUSUAL_DEV(  0x04b0, 0x0411, 0x0100, 0x0111,
 		"NIKON",
 		"NIKON DSC D80",
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_CAPACITY),
 
 /* Reported by Ortwin Glueck <odi@odi.ch> */
-UNUSUAL_DEV(  0x04b0, 0x0413, 0x0110, 0x0110,
+UNUSUAL_DEV(  0x04b0, 0x0413, 0x0110, 0x0111,
 		"NIKON",
 		"NIKON DSC D40",
 		US_SC_DEVICE, US_PR_DEVICE, NULL,

-- 
http://www.codemonkey.org.uk
