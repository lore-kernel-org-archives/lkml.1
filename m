Return-Path: <linux-kernel-owner+w=401wt.eu-S1757435AbYDYBhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbYDYBhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 21:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754719AbYDYBhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 21:37:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:55211 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754711AbYDYBhq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 21:37:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,706,1199692800"; 
   d="scan'208";a="274512889"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 09/24] ia64: types: use <asm-generic/int-*.h> for the ia64 architecture
Date: Thu, 24 Apr 2008 18:37:44 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843EC012F9FDA@orsmsx424.amr.corp.intel.com>
In-Reply-To: <1209078352-7593-18-git-send-email-hpa@zytor.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 09/24] ia64: types: use <asm-generic/int-*.h> for the ia64 architecture
Thread-Index: AcimX9AXBdl/BaKETwSIWWgdWnHFdgAE5sqg
References: <1209078352-7593-1-git-send-email-hpa@zytor.com> <1209078352-7593-2-git-send-email-hpa@zytor.com> <1209078352-7593-3-git-send-email-hpa@zytor.com> <1209078352-7593-4-git-send-email-hpa@zytor.com> <1209078352-7593-5-git-send-email-hpa@zytor.com> <1209078352-7593-6-git-send-email-hpa@zytor.com> <1209078352-7593-7-git-send-email-hpa@zytor.com> <1209078352-7593-8-git-send-email-hpa@zytor.com> <1209078352-7593-9-git-send-email-hpa@zytor.com> <1209078352-7593-10-git-send-email-hpa@zytor.com> <1209078352-7593-11-git-send-email-hpa@zytor.com> <1209078352-7593-12-git-send-email-hpa@zytor.com> <1209078352-7593-13-git-send-email-hpa@zytor.com> <1209078352-7593-14-git-send-email-hpa@zytor.com> <1209078352-7593-15-git-send-email-hpa@zytor.com> <1209078352-7593-16-git-send-email-hpa@zytor.com> <1209078352-7593-17-git-send-email-hpa@zytor.com> <1209078352-7593-18-git-send-email-hpa@zytor.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linux Arch Mailing List" <linux-arch@vger.kernel.org>
X-OriginalArrivalTime: 25 Apr 2008 01:37:45.0171 (UTC) FILETIME=[F5E21230:01C8A674]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get an error while building the ia64 sim_defconfig (which
uses CONFIG_HZ=32)

kernel/time.c: In function `msecs_to_jiffies':
kernel/time.c:472: error: `MSEC_TO_HZ_MUL32UL' undeclared (first use in this function)
kernel/time.c:472: error: (Each undeclared identifier is reported only once
kernel/time.c:472: error: for each function it appears in.)


The generated timeconst.h has:
#define MSEC_TO_HZ_MUL32        0x83126e98

So some weird cpp thing happened and the UL got concatenated
before the MSEC_TO_HZ_MUL32 was swapped out for its defined
value.

All the rest of the ia64 configs build ok.

-Tony
