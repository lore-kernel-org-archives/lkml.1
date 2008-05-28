Return-Path: <linux-kernel-owner+w=401wt.eu-S1752202AbYE1Pkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbYE1Pkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 11:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbYE1Pkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 11:40:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbYE1Pkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 11:40:35 -0400
Message-ID: <483D7CE8.4000600@redhat.com>
Date: Wed, 28 May 2008 11:40:24 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Performance Characteristics of All Linux RAIDs (mdadm/bonnie++)
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> Hardware:
> 
> 1. Utilized (6) 400 gigabyte sata hard drives.
> 2. Everything is on PCI-e (965 chipset & a 2port sata card)
> 
> Used the following 'optimizations' for all tests.
> 
> # Set read-ahead.
> echo "Setting read-ahead to 64 MiB for /dev/md3"
> blockdev --setra 65536 /dev/md3
> 
> # Set stripe-cache_size for RAID5.
> echo "Setting stripe_cache_size to 16 MiB for /dev/md3"
> echo 16384 > /sys/block/md3/md/stripe_cache_size
> 
> # Disable NCQ on all disks.
> echo "Disabling NCQ on all disks..."
> for i in $DISKS
> do
>   echo "Disabling NCQ on $i"
>   echo 1 > /sys/block/"$i"/device/queue_depth
> done

Given that one of the greatest benefits of NCQ/TCQ is with parity RAID, 
I'd be fascinated to see how enabling NCQ changes your results.  Of 
course, you'd want to use a single SATA controller with a known good NCQ 
implementation, and hard drives known to not do stupid things like 
disable readahead when NCQ is enabled.

-- Chris
