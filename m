Return-Path: <linux-kernel-owner+w=401wt.eu-S1762159AbXIXR7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762159AbXIXR7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 13:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756255AbXIXR7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 13:59:42 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:59993 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581AbXIXR7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 13:59:40 -0400
Subject: Re: 2.6.23-rc6: hanging ext3 dbench tests
From: Badari Pulavarty <pbadari@gmail.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, sct@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, adilger@clusterfs.com,
       ext4 <linux-ext4@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       mel@csn.ul.ie
In-Reply-To: <20070919181546.GA4343@shadowen.org>
References: <20070911124202.GI9556@shadowen.org>
	 <alpine.LFD.0.999.0709110949250.16478@woody.linux-foundation.org>
	 <20070911173049.GA10499@shadowen.org> <20070914094905.GA32670@shadowen.org>
	 <20070919181546.GA4343@shadowen.org>
Content-Type: text/plain
Date: Mon, 24 Sep 2007 11:01:58 -0700
Message-Id: <1190656918.13955.7.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

I managed to reproduce the dbench problem. (not sure if its the same
thing or not - but symptoms are same). My problem has nothing to do 
with ext3. I can produce it on ext2, jfs also.

Whats happening on my machine is ..

dbench forks of 4 children and sends them a signal to start the work.
3 out of 4 children gets the signal and does the work. One of the child
never gets the signal so, it waits forever in pause(). So, parent waits
for a longtime to kill it.

BTW, I was trying to find out when this problem started showing up.
So far, I managed to track it to 2.6.23-rc4. (2.6.23-rc3 doesn't seem
to have this problem). I am going to do bi-sect and find out which
patch caused this.

I am using dbench-2.0 which consistently reproduces the problem on
my x86-64 box. Did you find anything new with your setup ?

Thanks,
Badari



