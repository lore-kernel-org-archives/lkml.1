Return-Path: <linux-kernel-owner+w=401wt.eu-S1755053AbZCFBKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbZCFBKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 20:10:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbZCFBK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 20:10:26 -0500
Received: from mail.lang.hm ([64.81.33.126]:35133 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbZCFBKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 20:10:25 -0500
Date: Thu, 5 Mar 2009 17:10:00 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
cc: David Newall <davidn@davidnewall.com>, linux-kernel@vger.kernel.org
Subject: Re: Failover Kernel
In-Reply-To: <49AE3BF6.2010600@turknet.net.tr>
Message-ID: <alpine.DEB.1.10.0903051707211.30837@asgard.lang.hm>
References: <49A659D0.2040903@turknet.net.tr>  <200902261802.56612.diegocg@gmail.com>  <49A80796.2070208@turknet.net.tr> <1235749850.4718.1.camel@localhost.localdomain> <49AC0799.5060306@turknet.net.tr> <49ACA433.5050400@davidnewall.com>
 <49AE3BF6.2010600@turknet.net.tr>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Mar 2009, Tarkan Erimer wrote:

> On 03/03/2009 05:29 AM, David Newall wrote:
>> It sounds like you want everything to just continue running.  I don't
>> 
> Yes, exactly. Backup kernel will take control when a crush occured without 
> need a reboot or halt.
>> see how that can be done.  All of those in-kernel tables and structures
>> would need to be migrated, and it follows, because there was a crash,
>> that any of them might have been corrupted.  Worse, you want this to
>> save you when you try running a new kernel which crashes, and being a
>> new kernel, it follows that any of those structures could be different;
>> it might not be possible to create equivalent structures for different
>> kernel versions.
>>
>> 
> Yes, that's right and it's the first thing needed to overcome. Maybe, it 
> could be implemented like this :
>
> - Primary kernel could be 2.6.x or 2.6.x.y (2.6.28 or 2.6.28.1)
> - Backup kernel could be one of these .y fix releases only: Like 2.6.28.5
>
> So; when they're from the same version, it will prevent kernel API and 
> structure changes.
> For resuming by backup kernel: The primary kernel could write a journal about 
> the needed things for backup to resume. Like process IDs, memory and process 
> situations etc. The same manner as the Journalled File Systems did (they 
> write a journal what they did to recover/resume at crash/disaster time).

wrong, kernel structures can change in any patch. they can even change 
with different configuration options.

but even if they are the same version and configuration options, that 
doesn't address the fact that you can't trust the in-kernel structures 
because they may have been damaged by whatever caused the crash.

David Lang
