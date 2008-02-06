Return-Path: <linux-kernel-owner+w=401wt.eu-S1764197AbYBFX4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764197AbYBFX4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764030AbYBFXyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:54:10 -0500
Received: from ns1.suse.de ([195.135.220.2]:44976 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763720AbYBFXyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:54:07 -0500
Date: Wed, 6 Feb 2008 15:51:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       William Irwin <wli@holomorphy.com>, Mikael Pettersson <mikpe@it.uu.se>,
       Len Brown <len.brown@intel.com>
Subject: [patch 05/73] ACPI: video_device_list corruption
Message-ID: <20080206235101.GF13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-video_device_list-corruption.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: William Lee Irwin III <wli@holomorphy.com>

The ->cap fields of struct acpi_video_device and struct acpi_video_bus
are 1B each, not 4B. The oversized memset()'s corrupted the subsequent
list_head fields. This resulted in silent corruption without
CONFIG_DEBUG_LIST and BUG's with it. This patch uses sizeof() to pass
the proper bounds to the memset() calls and thereby correct the bugs.

upstream commit 98934def70b48dac74fac3738b78ab2d1a28edda

Signed-off-by: William Irwin <wli@holomorphy.com>
Acked-by: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/video.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -573,7 +573,7 @@ static void acpi_video_device_find_cap(s
 	struct acpi_video_device_brightness *br = NULL;
 
 
-	memset(&device->cap, 0, 4);
+	memset(&device->cap, 0, sizeof(device->cap));
 
 	if (ACPI_SUCCESS(acpi_get_handle(device->dev->handle, "_ADR", &h_dummy1))) {
 		device->cap._ADR = 1;
@@ -693,7 +693,7 @@ static void acpi_video_bus_find_cap(stru
 {
 	acpi_handle h_dummy1;
 
-	memset(&video->cap, 0, 4);
+	memset(&video->cap, 0, sizeof(video->cap));
 	if (ACPI_SUCCESS(acpi_get_handle(video->device->handle, "_DOS", &h_dummy1))) {
 		video->cap._DOS = 1;
 	}

-- 
