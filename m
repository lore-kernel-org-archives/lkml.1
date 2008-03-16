Return-Path: <linux-kernel-owner+w=401wt.eu-S1753556AbYCPVia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbYCPVia (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 17:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbYCPViV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 17:38:21 -0400
Received: from phunq.net ([64.81.85.152]:33090 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752502AbYCPViU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 17:38:20 -0400
From: Daniel Phillips <phillips@phunq.net>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: Re: [RFC] Stacking bio support
Date: Sun, 16 Mar 2008 13:38:18 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200803110352.41479.phillips@phunq.net> <47DA84B7.1000409@hp.com>
In-Reply-To: <47DA84B7.1000409@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803161438.18878.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 March 2008 06:59, Alan D. Brunelle wrote:
> I was able to get the first 3 patches ported to the stable tree of
> 2.6.23, but there were compilation errors - fixed in the 4th patch
> in the stream I'll post next. Regardless of that, it still failed
> to boot on a 2-way AMD64. Do you have a set of these patches that
> builds correctly & boots! :-)    
 
Here you are:

http://code.google.com/p/zumastor/source/browse/www/lvm3/bio.single.alloc-2.6.24.3
http://code.google.com/p/zumastor/source/browse/www/lvm3/bio.hide.endio-2.6.24.3
http://code.google.com/p/zumastor/source/browse/www/lvm3/bio.stack-2.6.24.3
http://code.google.com/p/zumastor/source/browse/www/lvm3/dm.reduce.allocs-2.6.24.3

This compiles and boots for me, though I only tried device mapper
under UML, and then only lightly.  It would be nice to see some reports
on the stability on this, one way or the other.  Next move is to clean
up __clone_and_map the rest of the way.

Thanks for your merge.  Not easy, hmm?  The mainline bio changes
generated a bunch of tracking work, but they are sensible changes so
no regrets (the bogus endio bytes parameter and int return are gone).
Now... it appears to me that bi_size is an entirely redundant field,
so while we are turfing bio junk out...

Regards,

Daniel
