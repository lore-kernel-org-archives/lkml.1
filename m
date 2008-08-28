Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbYH1Hwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbYH1Hwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 03:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbYH1Hwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 03:52:37 -0400
Received: from mx.bridgeco.net ([213.173.191.47]:4364 "EHLO mx.bridgeco.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325AbYH1Hwg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 03:52:36 -0400
From: Wappler Marcel <Marcel.Wappler@bridgeco.net>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 28 Aug 2008 09:52:32 +0200
Subject: VM: page reclaim does not work on ARM9?
Thread-Topic: VM: page reclaim does not work on ARM9?
Thread-Index: Ach0m4cSiApNdLdFScC3DSTHVH8H7w==
Message-ID: <462ADBE7F1A69C438B7E2ED56007E6F5ABF9A43F21@exch10.BC-Int.NET>
Accept-Language: en-US, de-CH
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, de-CH
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 28 Aug 2008 07:52:07.0214 (UTC) FILETIME=[F7F094E0:01C908E2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I do need some help to understand what's going on in the VM of the Linux kernel...

I wrote a little script which generates a C app with millions of lines of dumb linear running code and a endless loop at the end. I run this app on both PC Linux (swapping enabled) and embedded Linux (Kernel 2.6.24.7, ARM9, swapping disabled).

The app shall consume a lot of code pages which are used only once (to run the linear code in it) and then stay in the endless loop and never touch all the other pages in memory. Then I consume all of the remaining memory of the system through generating a big file on the tmpfs (whose data resides in memory) with the help of /dev/zero and "dd".

My expectation was: the VM shall steal (reclaim) all the only once touched pages containing those dumb linear code of the app.

My observation is: "top" shows that the app is consuming constantly the same huge amount of residential memory during the decreasing free memory space. At some moment the kernel starts a OOM killer on the app instead of reclaiming its unused code pages.

Keep in mind: the behaviour is the same on both PC Linux (2 GB RAM) and ARM Linux (32MB RAM ) with and without swapping enabled.

So for me it looks like that any page which is containing code never gets reclaimed from the application it belongs to regardless of its usage.

Any idias, whats going on?

best regards,
Marcel

PS: Please CC me on reply...
