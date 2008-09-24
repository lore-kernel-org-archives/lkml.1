Return-Path: <linux-kernel-owner+w=401wt.eu-S1752847AbYIXN4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbYIXN4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 09:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbYIXN4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 09:56:40 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:46985 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbYIXN4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 09:56:39 -0400
Date: Wed, 24 Sep 2008 10:56:57 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: hamid.jahanjou@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VM: Implements the swap-out page-clustering technique
Message-ID: <20080924105657.78265a63@doriath.conectiva>
In-Reply-To: <48BFCECE.90103@gmail.com>
References: <48BFCECE.90103@gmail.com>
Organization: Mandriva
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.2; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 04 Sep 2008 15:34:30 +0330
"Hamid R. Jahanjou" <hamid.jahanjou@gmail.com> escreveu:

| From: Hamid R. Jahanjou
| 
| Implements the idea of swap-out page clustering from *BSD for
| Linux. Each time a candidate page is to be swapped out,
| virtually-nearby pages are scanned to find eligible pages to be
| swapped out too as a cluster. This technique increases the likelihood of
| bringing in related data on a page fault and decreases swap space
| fragmentation in the long run. Currently, Linux searches only
| physically-nearby pages which is not optimal since, over time, physically-
| adjacent pages may become unrelated.
| 
| The code can be statically tuned. No benchmarks. I'm not sure whether
| the added complexity is acceptable.

 Sorry for this (very) late response, but I ran some very simple tests
this week and thought you might be interested in the results.

 The test machine has 512MB of RAM. For the tests I booted with 64MB
and setup a 512MB swap file.

 For the first test I let an allyesconfig kernel building for several
hours with six jobs (make -j6). I did not have any problems, so
considering that your code was used I think it is stable enough.

 In the second test I have built an allnoconfig kernel with and without
your patches, still with six jobs. Results:

	2.6.27-rc7-vanilla   44:12 minutes
	2.6.27-rc7-pgc       52:09 minutes

 (pgc means page-clustering patches).

 For both builds I did not change any swap paramenter and I could
observe that about 80MB of swap were used most of the time.

 But please, note that these tests were quite far from being 'scientific'
eg. I should have built the kernel more times and should have tried other
setups...

 I will wait for the next version of the patches to run more serious
tests.

-- 
Luiz Fernando N. Capitulino
