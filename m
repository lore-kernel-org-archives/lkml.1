Return-Path: <linux-kernel-owner+w=401wt.eu-S1753229AbXFORVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbXFORVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 13:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbXFORUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 13:20:54 -0400
Received: from il.qumranet.com ([82.166.9.18]:53290 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbXFORUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 13:20:53 -0400
Message-ID: <4672CA72.1010505@argo.co.il>
Date: Fri, 15 Jun 2007 20:20:50 +0300
From: Avi Kivity <avi@argo.co.il>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Neil Brown <neilb@suse.de>, david@lang.hm, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: limits on raid
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm> <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm> <18034.3676.477575.490448@notabene.brown> <467273AB.9010202@argo.co.il> <Pine.LNX.4.64.0706151823360.32724@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0706151823360.32724@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Fri, 15 Jun 2007 20:20:51 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jun 15 2007 14:10, Avi Kivity wrote:
>   
>> Some things are not achievable with block-level raid.  For example, with
>> redundancy integrated into the filesystem, you can have three copies for
>> metadata, two copies for small files, and parity blocks for large files,
>> effectively using different raid levels for different types of data on
>> the same filesystem.
>>     
>
> Sounds like you want RAIF, not RAID.
>
>   

If you mean taking a bunch of single-disk filesystems and layering
another filesystem on top, then no.  The underlying filesystems will
only serve as object allocators, and all the directory hierarchy,
journalling, and other capabilities will end up as overhead.  Fairly
significant overhead, too -- I've once worked on a similar environment. 
Performance sucked until the underlying filesystems were removed.

Abstraction layers are good for dividing large problems, but they have
their costs.  Consider NUMA for example: you can treat it as a large
blob of memory, but much performance can be gained of you don't. 
Similarly, with disks, you can put them in a big RAID and treat them as
a large disk, but if you don't, there are large rewards.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

