Return-Path: <linux-kernel-owner+w=401wt.eu-S935404AbXHGX5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935404AbXHGX5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 19:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755884AbXHGX5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 19:57:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513AbXHGX5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 19:57:20 -0400
Message-ID: <46B906DD.5000501@redhat.com>
Date: Tue, 07 Aug 2007 19:57:17 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: paul.pinault@disk91.com
CC: linux-kernel@vger.kernel.org
Subject: Re: Data corruption
References: <200708072007.27343.paul.pinault@disk91.com>
In-Reply-To: <200708072007.27343.paul.pinault@disk91.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

paul wrote:
> Since 2-3 month I have some random data corruption on my Linux server, after 
> checking disks independently (i'm using raid1on 2 sata disk, the problem is 
> the same w/o raid) and memory, hardware simce to be out of cause...
> 
> Here is my problem:
> => head --bytes=300m  /dev/urandom > test
> => for i in `seq 0 9` ; do cp test test$i ; done
> => md5sum test*
> I got : 
> 014666c728c9e3b8299579fae499864a  test
> 014666c728c9e3b8299579fae499864a  test0
> 333fd93d093ac612cd8d5f65628f734e  test1
> 1ab6ee68c6a7d9ff5a05f9d63f0f6df6  test2
> 96e96483e3175a59c9c05b6720514e1e  test3
> 014666c728c9e3b8299579fae499864a  test4
> b24dbccc9f4831f8825ab4a55a3be4aa  test5
> 8493efc9c14e4b5c162ac23696fbc16a  test6
> 6a5f4301f66d0379049d79d0e14e2a87  test7
> 2c81cfa1c3a03aba134574922ee5d75c  test8
> 2ea15c8392bfd0123472a80125bb3abe  test9
> 
> ^^^ that sounds really bad for my data :(

It does indeed.  Can you try comparing the data to see precisely how much 
differs between the versions?  md5sums don't distinguish between a single-bit 
error and a block or page-sized error, but the distinction is critical in 
determining what broke.

Can you reproduce this on a recent upstream baremetal (non-Xen) kernel?  If so, 
does it go away when you boot with mem=3000M?

	-- Chris
