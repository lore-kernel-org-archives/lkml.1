Return-Path: <linux-kernel-owner+w=401wt.eu-S1765437AbXHOQfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765437AbXHOQfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 12:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764713AbXHOQex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 12:34:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:18765 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761084AbXHOQew convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 12:34:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,267,1183359600"; 
   d="scan'208";a="279310687"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] ia64: default the NUMA node distance when there is no ACPI SLIT
Date: Wed, 15 Aug 2007 09:34:50 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A022DB21A@scsmsx411.amr.corp.intel.com>
In-Reply-To: <b6b031e56608ee8acf4c84cb1f413403@pinky>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] ia64: default the NUMA node distance when there is no ACPI SLIT
Thread-Index: AcffS8gcMnokOix3QJSZMDypyndSVgADVxJg
References: <b6b031e56608ee8acf4c84cb1f413403@pinky>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Andy Whitcroft" <apw@shadowen.org>
Cc: <linux-ia64@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 15 Aug 2007 16:34:51.0006 (UTC) FILETIME=[33A831E0:01C7DF5A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

+	printk(KERN_INFO "Building NUMA distance from ACPI 2.0 SLIT\n");

This printk just looks like noise during boot.  Surely this
is normal behavior on a NUMA system?

+	printk(KERN_INFO "No SLIT table, defaulting NUMA distance\n");

But this one deserves more prominence than just KERN_INFO.  I'd
say that it deserves a KERN_ERR rating (without accurate information
we'll make some highly questionable scheduling and memory placement
decisions).  On the other hand the only way for the end-user to fix
this is to complain to their system vendor to fix firmware.  So perhaps
it is just a KERN_NOTICE.

-Tony
