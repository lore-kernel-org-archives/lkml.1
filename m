Return-Path: <linux-kernel-owner+w=401wt.eu-S1760921AbXHHGbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760921AbXHHGbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 02:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbXHHGbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 02:31:14 -0400
Received: from smtp2a.orange.fr ([80.12.242.139]:26145 "EHLO smtp2a.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813AbXHHGbN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 02:31:13 -0400
X-ME-UUID: 20070808063111810.C5CEC700008C@mwinf2a11.orange.fr
From: paul <paul.pinault@disk91.com>
Reply-To: paul.pinault@disk91.com
To: Chris Snook <csnook@redhat.com>
Subject: Re: Data corruption
Date: Wed, 8 Aug 2007 08:31:09 +0200
User-Agent: KMail/1.9.5
References: <200708072007.27343.paul.pinault@disk91.com> <46B906DD.5000501@redhat.com>
In-Reply-To: <46B906DD.5000501@redhat.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708080831.10141.paul.pinault@disk91.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, thank you for your answer, actually I removed 2Gb of physical memory and 
the problem gone away .. but my system needs 4Gb.

I reproduce it under Xen and without xen (on a standard kernel) I can't tell 
you how mutch difference I have betwwen files, regarding a 4 month system 
running on these condition, I think the number of errors are rare but 
existing, during my tests with 100M files I did not get a lot of error, so we 
can assume 2 or 3 bytes in error in 300M files... (expectation)

I try to avaoid it by disabeling memory relocation on my MB ... in that case 
the system only detect 2.8G (and Linux too), The probem still there.

It seems to be based on an Asus P5B-VM problem as this one have a lot of with 
4Gb... But it should be certified on Windows up to 8Gb... (but I did not have 
that strange OS to check). So a workaround should exists.


Le mercredi 8 août 2007 01:57, vous avez écrit :
> paul wrote:
> > Since 2-3 month I have some random data corruption on my Linux server,
> > after checking disks independently (i'm using raid1on 2 sata disk, the
> > problem is the same w/o raid) and memory, hardware simce to be out of
> > cause...
> >
> > Here is my problem:
> > => head --bytes=300m  /dev/urandom > test
> > => for i in `seq 0 9` ; do cp test test$i ; done
> > => md5sum test*
> > I got :
> > 014666c728c9e3b8299579fae499864a  test
> > 014666c728c9e3b8299579fae499864a  test0
> > 333fd93d093ac612cd8d5f65628f734e  test1
> > 1ab6ee68c6a7d9ff5a05f9d63f0f6df6  test2
> > 96e96483e3175a59c9c05b6720514e1e  test3
> > 014666c728c9e3b8299579fae499864a  test4
> > b24dbccc9f4831f8825ab4a55a3be4aa  test5
> > 8493efc9c14e4b5c162ac23696fbc16a  test6
> > 6a5f4301f66d0379049d79d0e14e2a87  test7
> > 2c81cfa1c3a03aba134574922ee5d75c  test8
> > 2ea15c8392bfd0123472a80125bb3abe  test9
> >
> > ^^^ that sounds really bad for my data :(
>
> It does indeed.  Can you try comparing the data to see precisely how much
> differs between the versions?  md5sums don't distinguish between a
> single-bit error and a block or page-sized error, but the distinction is
> critical in determining what broke.
>
> Can you reproduce this on a recent upstream baremetal (non-Xen) kernel?  If
> so, does it go away when you boot with mem=3000M?
>
> 	-- Chris

