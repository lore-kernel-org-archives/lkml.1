Return-Path: <linux-kernel-owner+w=401wt.eu-S1751999AbZHaLUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbZHaLUB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 07:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbZHaLUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 07:20:00 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:60961 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751395AbZHaLT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 07:19:59 -0400
From: Frans Pop <elendil@planet.nl>
To: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH 2/6] thermal: sysfs-api.txt - document passive attribute for thermal zones
Date: Mon, 31 Aug 2009 13:19:58 +0200
User-Agent: KMail/1.9.9
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Thomas, Sujith" <sujith.thomas@intel.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>
References: <1251303445-25317-1-git-send-email-elendil@planet.nl> <1251303445-25317-3-git-send-email-elendil@planet.nl> <1251706691.3483.169.camel@rzhang-dt>
In-Reply-To: <1251706691.3483.169.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908311320.00632.elendil@planet.nl>
X-OriginalArrivalTime: 31 Aug 2009 11:20:01.0154 (UTC) FILETIME=[FB00C620:01CA2A2C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 August 2009, Zhang Rui wrote:
> > +passive
> > +	Attribute is only present for zones which do not have a passive
> > +	cooling policy (_PSV) defined in ACPI.
>
> We should not involve any platform specific stuff in this
> documentation. how about "Attribute is only present for zones in which
> the passive cooling policy is not supported by native thermal driver"
[...]
> > -If the processor is listed in _PSL method, and the fan is listed in
> > _AL0 -method, the sys I/F structure will be built like this:
> > +If the processor is listed in _PSL method, the fan is listed in _AL0
> > +method, and the zone has a _PSV method, the sys I/F structure will
> > be +built like this:
>
> For an ACPI thermal zone, supporting passive cooling means that both
> _PSL and _PSV are available.
> so I don't think we need to change this. :)

OK. Updated patch below.


From: Frans Pop <elendil@planet.nl>
Subject: thermal: sysfs-api.txt - document passive attribute for thermal zones

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Sujith Thomas <sujith.thomas@intel.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>

diff --git a/Documentation/thermal/sysfs-api.txt b/Documentation/thermal/sysfs-api.txt
index 895337f..a87dc27 100644
--- a/Documentation/thermal/sysfs-api.txt
+++ b/Documentation/thermal/sysfs-api.txt
@@ -199,6 +199,15 @@ cdev[0-*]_trip_point
 	point.
 	RO, Optional
 
+passive
+	Attribute is only present for zones in which the passive cooling
+	policy is not supported by native thermal driver. Default is zero
+	and can be set to a temperature (in millidegrees) to enable a
+	passive trip point for the zone. Activation is done by polling
+	with an interval of 1 second.
+	Unit: millidegrees Celsius
+	RW, Optional
+
 *****************************
 * Cooling device attributes *
 *****************************
