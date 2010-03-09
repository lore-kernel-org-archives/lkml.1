Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab0CINAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 08:00:45 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:17156 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab0CINAm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 08:00:42 -0500
X-IronPort-AV: E=Sophos;i="4.49,608,1262581200"; 
   d="scan'208";a="13837039"
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "gregkh@suse.de" <gregkh@suse.de>
CC: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
       Jonathan Cameron <jic23@cam.ac.uk>
Date: Tue, 9 Mar 2010 13:00:38 +0000
Subject: [PATCH] iio_trigger_find_by_name: Skip trailing newline if available
Thread-Topic: [PATCH] iio_trigger_find_by_name: Skip trailing newline if
 available
Thread-Index: Acq+ojCCqD8wjfStT1mzrkt7iCbLLwAyXmuQAAcCElA=
Message-ID: <544AC56F16B56944AEC3BD4E3D5917712D6B1D976A@LIMKCMBX1.ad.analog.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Skip trailing newline if available.

Signed-off-by: Michael Hennerich <Michael.Hennerich@analog.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>

Index: drivers/staging/iio/industrialio-trigger.c
===================================================================
--- drivers/staging/iio/industrialio-trigger.c  (revision 8368)
+++ drivers/staging/iio/industrialio-trigger.c  (working copy)
@@ -155,6 +155,9 @@
        struct iio_trigger *trig;
        bool found = false;

+       if (len && name[len - 1] == '\n')
+               len--;
+
        mutex_lock(&iio_trigger_list_lock);
        list_for_each_entry(trig, &iio_trigger_list, list) {
                if (strncmp(trig->name, name, len) == 0) {

------------------------------------------------------------------
********* Analog Devices GmbH              Open Platform Solutions
**  *****
**     ** Wilhelm-Wagenfeld-Strasse 6
**  ***** D-80807 Munich
********* Germany
Registergericht München HRB 40368,  Geschäftsführer: Thomas Wessel, William A. Martin, Margaret K. Seif


