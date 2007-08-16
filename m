Return-Path: <linux-kernel-owner+w=401wt.eu-S1764793AbXHPQ1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764793AbXHPQ1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 12:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933795AbXHPQ0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 12:26:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:41824 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933779AbXHPQ0o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 12:26:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,272,1183359600"; 
   d="scan'208";a="279854269"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: scripts/mod/file2alias.c cross compile problem
Date: Thu, 16 Aug 2007 09:26:42 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A022DBC43@scsmsx411.amr.corp.intel.com>
In-Reply-To: <1187274435.8780.780.camel@queen.suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: scripts/mod/file2alias.c cross compile problem
Thread-Index: AcfgEZCxdOEJsOxeTUKTEguWO2GblgAEAw2A
References: <617E1C2C70743745A92448908E030B2A0211AFF0@scsmsx411.amr.corp.intel.com> <1186092501.6131.154.camel@localhost.localdomain> <1187274435.8780.780.camel@queen.suse.de>
From: "Luck, Tony" <tony.luck@intel.com>
To: <trenn@suse.de>, "Rusty Russell" <rusty@rustcorp.com.au>
Cc: "Adrian Bunk" <bunk@stusta.de>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Jan Dittmer" <jdi@l4x.org>, "Len Brown" <lenb@kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <linux-ia64@vger.kernel.org>
X-OriginalArrivalTime: 16 Aug 2007 16:26:43.0474 (UTC) FILETIME=[3B7A7720:01C7E022]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -#define ACPI_ID_LEN	9
> +#define ACPI_ID_LEN	16 /* only 9 bytes needed here, 16 bytes are used */

What will happen if someone uses more than 9 bytes?  With the old
limit there would be a compile time error it someone initialized
with:

	{"PNP0C0ABCDEFGH", 0},

But if we change ACPI_ID_LEN the error will move to run-time.

-Tony
