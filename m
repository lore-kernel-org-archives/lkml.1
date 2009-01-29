Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbZA2KYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbZA2KYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 05:24:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbZA2KYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 05:24:16 -0500
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:49046 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751635AbZA2KYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 05:24:14 -0500
X-DKIM: Sendmail DKIM Filter v2.6.0 mail-in-02.arcor-online.net 434E43FE7DA
Subject: Re: [Bugme-new] [Bug 12562] New: High overhead while switching or
 synchronizing threads on different cores
From: Thomas Pilarski <thomas.pi@arcor.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Galbraith <efault@gmx.de>,
       Gregory Haskins <ghaskins@novell.com>, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1233223979.5294.41.camel@bugs-laptop>
References: <bug-12562-10286@http.bugzilla.kernel.org/>
	 <20090128125604.94ed3fe0.akpm@linux-foundation.org>
	 <1233181507.6988.14.camel@bugs-laptop>  <1233220048.7835.19.camel@twins>
	 <1233223979.5294.41.camel@bugs-laptop>
Content-Type: text/plain
Date: Thu, 29 Jan 2009 11:24:04 +0100
Message-Id: <1233224644.5294.52.camel@bugs-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some explanation of the test program. 

./schedulerissue 1 4096 8 2000
1 producer and 1 consumer
buffer size of 4096 doubles * 8byte 
8 buffer (256kB total buffer)
2000 messages

./schedulerissue 2 4096 8 2000
2 producer and 2 consumer
buffer size of 4096 doubles * 8byte 
8 buffer (256kB total buffer)
2000 messages


It was not 512KB bytes in the test before, but 4MB.
But there is the same problem with a total buffer size of 48kB and 4
threads (./schedulerissue 2 2048 3 20000).


