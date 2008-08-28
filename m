Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbYH1H7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbYH1H7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 03:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754220AbYH1H7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 03:59:31 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:36416 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753527AbYH1H7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 03:59:24 -0400
X-SourceIP: 80.57.229.25
Subject: Re: [PATCH -V3 01/11] percpu_counters: make fbc->count read atomic
	on 32 bit architecture
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: aneesh.kumar@linux.vnet.ibm.com, cmm@us.ibm.com, tytso@mit.edu,
       sandeen@redhat.com, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080827142250.7397a1a7.akpm@linux-foundation.org>
References: <1219850916-8986-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <20080827120553.9c9d6690.akpm@linux-foundation.org>
	 <1219870912.6395.45.camel@twins>
	 <20080827142250.7397a1a7.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 28 Aug 2008 09:57:37 +0200
Message-Id: <1219910257.6443.6.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-27 at 14:22 -0700, Andrew Morton wrote:

> btw, what the heck is percpu_counter_init_irq()?  Some mysterious
> lockdep-specific thing?
> 
> <does git-fiddle.  Oh.  crappy changelog.>
> 
> I let that one leak through uncommented.  Must be getting old. 
> Probably it will need an EXPORT_SYMBOL() sometime.

Basically all it does it break the percpu_counter lock into two classes.

One for the irq-unsafe users and one for the irq-safe users. Without
this lockdep goes splat complaining about irq recursion deadlocks and
the like between these two separate users.

