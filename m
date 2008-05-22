Return-Path: <linux-kernel-owner+w=401wt.eu-S934092AbYEVIVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934092AbYEVIVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 04:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756076AbYEVIUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 04:20:49 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37534 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247AbYEVIUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 04:20:46 -0400
Message-ID: <48352CDA.2030603@np.css.fujitsu.com>
Date: Thu, 22 May 2008 17:20:42 +0900
From: Kentaro Makita <k-makita@np.css.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: akpm@linux-foundation.org, dgc@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC]fix soft lock up at NFS mount by per-SB LRU-list
 of unused dentries
References: <4834D8DA.30907@np.css.fujitsu.com> <20080521235510.22bff69f.akpm@linux-foundation.org>
In-Reply-To: <20080521235510.22bff69f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 22 May 2008 11:22:18 +0900 Kentaro Makita <k-makita@np.css.fujitsu.com> wrote:
> 
>> [Summary]
>>   Split LRU-list of unused dentries to each superblocks to avoid soft lock up
>>  at NFS mounts and remounting any filesystem.
>>
>>  Previosly I posted are:
>>  http://lkml.org/lkml/2008/3/5/590
>>
>> [Descriptions]
>> - background
>>  dentry_unused is a list of dentries which is not in use. This works
>>  as a cache against not-exisiting files. dentry_unused grows up when
>>  directories or files are removed. This list can be very long if
>>  there is huge free memory.
> 
> The dentry_unused inodes are not actually not-existing files.  They are
> dentries which refer to live files (and, iirc, negative dentries) but
> which nobody is actually using - for example, regular files which
> nobody currently has open.
> 
> I changed the changelog text to reflect that.
Oh, Thank you for your good information and fixing.
> 
>> - what's problem
>>
>>  This patch is against linux-2.6.26-rc3. Tested on x86_64.
> 
> Looks good to me, thanks.  And no, the loss of the strict global LRU
> handling of the dentry LRU is unlikely to be an issue.
> 
>> Based on David Chinner's "Per-superblock unused dentry LRU lists V3".
>> ...
>> Signed-off-by: Kentaro Makita <k-makita@np.css.fujitsu.com>
> 
> I guess we should ask David for his signed-off-by: on this.
Thank you for your works too, David.

Best Regards,
Kentaro Makita

