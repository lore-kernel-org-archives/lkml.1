Return-Path: <linux-kernel-owner+w=401wt.eu-S1758955AbYGAVBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955AbYGAVBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 17:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbYGAVBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 17:01:41 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:9054 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbYGAVBk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 17:01:40 -0400
From: "Altobelli, David" <david.altobelli@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 1 Jul 2008 21:01:01 +0000
Subject: RE: [PATCH] HP iLO driver
Thread-Topic: [PATCH] HP iLO driver
Thread-Index: AcjbP/8GUqcRxcFSRgu8eJHAE1NWJwAfGL0Q
Message-ID: <CF70AA892F109448AEA269483B3A983903B7153201@G1W1215.americas.hpqcorp.net>
References: <20080616140729.GA377@ldl.fc.hp.com>
 <20080630230158.97e9d93b.akpm@linux-foundation.org>
In-Reply-To: <20080630230158.97e9d93b.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>
> Doing a GFP_KERNEL allocation inside spin_lock() is a flagrant bug
> which would have been detected had you enabled
> CONFIG_DEBUG_SPINLOCK_SLEEP (which ia64 appears to support (if this is
> an ia64-only driver?)) while testing.
>
> Please see Documentation/SubmitChecklist

Oops, sorry.  Right now, this is basically an x86 only driver.

> Using GFP_ATOMIC would be a poor solution for this - it is unreliable.
> Better would be to speculatively perform the allocation outside the
> spinlocked region and then toss it away if you didn't use it:

Will do.

> OK, so this is available on all architectures?
>
> There are pros and cons.  No avr32 user is likely to use this driver
> ;), but otoh having it compiled on other architectures can expose
> problems.

My hope was to write code that would work across architectures,
but the device is currently shipped only on x86.
