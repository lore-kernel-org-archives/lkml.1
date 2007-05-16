Return-Path: <linux-kernel-owner+w=401wt.eu-S933307AbXEPSJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933307AbXEPSJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 14:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756332AbXEPSI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 14:08:57 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:45263
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbXEPSI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 14:08:56 -0400
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 May 2007 14:08:56 EDT
Date: Wed, 16 May 2007 11:04:16 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Andreas Dilger <adilger@clusterfs.com>
cc: Jeff Zheng <Jeff.Zheng@endace.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Software raid0 will crash the file-system, when each disk is
 5TB
In-Reply-To: <20070516140452.GC5286@schatzie.adilger.int>
Message-ID: <Pine.LNX.4.64.0705161058430.1280@asgard.lang.hm>
References: <659F626D666070439A4A5965CD6EBF406836C6@gazelle.ad.endace.com>
 <20070516140452.GC5286@schatzie.adilger.int>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007, Andreas Dilger wrote:

> On May 16, 2007  11:09 +1200, Jeff Zheng wrote:
>> We are using two 3ware disk array controllers, each of them is connected
>> 8 750GB harddrives. And we build a software raid0 on top of that. The
>> total capacity is 5.5TB+5.5TB=11TB
>>
>> We use jfs as the file-system, we have a test application that write
>> data continuously to the disks. After writing 52 10GB files, jfs
>> crashed. And we are not able to recover it, fsck doesn't recognise it
>> anymore.
>> We then tried xfs, same application, lasted a little longer, but gives
>> kernel crash later.
>
> Check if your kernel has CONFIG_LBD enabled.
>
> The kernel doesn't check if the block layer can actually write to
> a block device > 2TB.

my experiance is taht if you don't have CONFIG_LBD enabled then the kernel 
will report the larger disk as 2G and everything will work, you just won't 
get all the space.

plus he seems to be crashing around 500G of data

and finally (if I am reading the post correctly) if he configures the 
drives as 4x2.2TB=11TB instead of 2x5.5TB=11TB he doesn't have the same 
problem.

I'm getting ready to setup a similar machine that will have 3x10TB (3 15 
disk arrays with 750G drives), but won't be ready to try this for a few 
more days.

David Lang
