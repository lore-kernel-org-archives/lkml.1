Return-Path: <linux-kernel-owner+w=401wt.eu-S1754358AbYHMAVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbYHMAVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 20:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbYHMAVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 20:21:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:49807 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240AbYHMAVW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 20:21:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,198,1217833200"; 
   d="scan'208";a="428699574"
From: "Luck, Tony" <tony.luck@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 12 Aug 2008 17:21:09 -0700
Subject: RE: ia64 allmodconfig on current mainline
Thread-Topic: ia64 allmodconfig on current mainline
Thread-Index: Acj8z2T/vdMWgikbSYWwVcmWR8gQzwACi5zg
Message-ID: <57C9024A16AD2D4C97DC78E552063EA30844B247@orsmsx505.amr.corp.intel.com>
References: <20080812150608.231a948a.akpm@linux-foundation.org>
	<200808130022.50501.rjw@sisk.pl>
 <20080812155806.4e8554a9.akpm@linux-foundation.org>
In-Reply-To: <20080812155806.4e8554a9.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> /opt/crosstool/gcc-3.4.5-glibc-2.3.6/ia64-unknown-linux-gnu/bin/ia64-unknown-linux-gnu-ld: section .data [0000000004ea0000 -> 0000000004f656e7] overlaps section .data.percpu [0000000004e90000 -> 0000000004ea0d17]

This means there is too much DEFINE_PER_CPU() going on.  Current
ia64 limit for the sum of all per cpu objects is 64K.  For a
build using defconfig we seem to be close (56K/64K ... look for
the address of __per_cpu_end and see how close it is to the top
of the address space: 0xffffffffffffffff).

-Tony
