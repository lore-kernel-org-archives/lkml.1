Return-Path: <linux-kernel-owner+w=401wt.eu-S1760102AbXHBTzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760102AbXHBTzy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 15:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235AbXHBTzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 15:55:47 -0400
Received: from mail.gmx.net ([213.165.64.20]:58043 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757333AbXHBTzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 15:55:46 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX193G2ANVJp3v75knDlUaVyu3pf8exHnEpGVruP18Z
	/HMC52vx7duLFM
Date: Thu, 2 Aug 2007 21:55:51 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: gcc fixed size char array initialization bug - known?
Message-ID: <Pine.LNX.4.60.0708022141420.6774@poirot.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I've run across the following gcc "feature":

	char c[4] = "01234";

gcc emits a nice warning

warning: initializer-string for array of chars is too long

But do a

	char c[4] = "0123";

and - a wonder - no warning. No warning with gcc 3.3.2, 3.3.5, 3.4.5, 
4.1.2. I was told 4.2.x does produce a warning. Now do a

	struct {
		char c[4];
		int i;
	} t;
	t.i = 0x12345678;
	strcpy(t.c, c);

and t.i is silently corrupted. Just wanted to ask if this is known, 
really...

Thanks
Guennadi
---
Guennadi Liakhovetski
