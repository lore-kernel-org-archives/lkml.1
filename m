Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbZBRRdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbZBRRdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 12:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbZBRRdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 12:33:00 -0500
Received: from void.printf.net ([89.145.121.20]:57595 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbZBRRc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 12:32:59 -0500
From: Chris Ball <cjb@laptop.org>
To: mgross@linux.intel.com
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Pavel Machek <pavel@suse.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Arve Hj?nnev?g <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       "Woodruff\, Richard" <r-woodruff2@ti.com>,
       Uli Luckas <u.luckas@road.de>, Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
References: <200902160010.16955.rjw@sisk.pl> <20090216225831.GH1370@ucw.cz>
	<20090216231324.GA15435@srcf.ucam.org>
	<20090217215717.GA25605@linux.intel.com>
Date: Wed, 18 Feb 2009 12:30:46 -0500
In-Reply-To: <20090217215717.GA25605@linux.intel.com> (mark gross's message of
	"Tue, 17 Feb 2009 13:57:17 -0800")
Message-ID: <m3zlgjlkjd.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

   > Putting the wake on key event issue aside, is it possible to have
   > wake up's on the ms time scale?  I ask because I thought the XO did
   > exactly this (but left the screen live).

We're currently at 890ms for suspend+resume with USB on, and 180ms for
suspend+resume when booted "nousb".  Anything done upstream to make the
first number closer to the second one will be very valuable to us.

   > Why does it take 20 sec to get into or out of S3 on my laptop?

We found that the SMM version of S3 in our original development BIOS
also took that long.  We switched to using Open Firmware, turned off
ACPI, worked out exactly which registers to use to enter S3, and
scheduled device reinitialization such that hardware-required delays
(such as clock stabilization for our GPU) start in the right order to
keep the critical path short.

The main difference was the switch away from the vendor BIOS, though --
we were seeing something like a five-second delay between Linux entering
S3 and the hardware noticing and putting the system into suspend, for
example.  There's not much market pressure to write efficient EC code
for suspend/resume.  (Or, we discovered, to write EC code that's able
to handle suspend/resume more than a hundred times per boot without
crashing.)

- Chris.
-- 
Chris Ball   <cjb@laptop.org>
