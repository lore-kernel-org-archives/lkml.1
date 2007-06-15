Return-Path: <linux-kernel-owner+w=401wt.eu-S1753929AbXFOLxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929AbXFOLxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 07:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbXFOLxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 07:53:38 -0400
Received: from il.qumranet.com ([82.166.9.18]:44231 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbXFOLxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 07:53:37 -0400
X-Greylist: delayed 1168 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jun 2007 07:53:37 EDT
Message-ID: <467273AB.9010202@argo.co.il>
Date: Fri, 15 Jun 2007 14:10:35 +0300
From: Avi Kivity <avi@argo.co.il>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: david@lang.hm, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: limits on raid
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>	<18034.479.256870.600360@notabene.brown>	<Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm> <18034.3676.477575.490448@notabene.brown>
In-Reply-To: <18034.3676.477575.490448@notabene.brown>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Fri, 15 Jun 2007 14:10:36 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown wrote:
>   
>> while I consider zfs to be ~80% hype, one advantage it could have (but I 
>> don't know if it has) is that since the filesystem an raid are integrated 
>> into one layer they can optimize the case where files are being written 
>> onto unallocated space and instead of reading blocks from disk to 
>> calculate the parity they could just put zeros in the unallocated space, 
>> potentially speeding up the system by reducing the amount of disk I/O.
>>     
>
> Certainly.  But the raid doesn't need to be tightly integrated
> into the filesystem to achieve this.  The filesystem need only know
> the geometry of the RAID and when it comes to write, it tries to write
> full stripes at a time.  If that means writing some extra blocks full
> of zeros, it can try to do that.  This would require a little bit
> better communication between filesystem and raid, but not much.  If
> anyone has a filesystem that they want to be able to talk to raid
> better, they need only ask...
>   

Some things are not achievable with block-level raid.  For example, with
redundancy integrated into the filesystem, you can have three copies for
metadata, two copies for small files, and parity blocks for large files,
effectively using different raid levels for different types of data on
the same filesystem.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

