Return-Path: <linux-kernel-owner+w=401wt.eu-S1755746AbZCDI3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbZCDI3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 03:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbZCDI3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 03:29:47 -0500
Received: from mail.netone.net.tr ([193.192.98.182]:25586 "EHLO
	mail.turknet.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbZCDI3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 03:29:46 -0500
Message-ID: <49AE3BF6.2010600@turknet.net.tr>
Date: Wed, 04 Mar 2009 10:29:42 +0200
From: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1b3pre) Gecko/20090303 Lightning/1.0pre Shredder/3.0b3pre
MIME-Version: 1.0
To: David Newall <davidn@davidnewall.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Failover Kernel
References: <49A659D0.2040903@turknet.net.tr>	 <200902261802.56612.diegocg@gmail.com>  <49A80796.2070208@turknet.net.tr> <1235749850.4718.1.camel@localhost.localdomain> <49AC0799.5060306@turknet.net.tr> <49ACA433.5050400@davidnewall.com>
In-Reply-To: <49ACA433.5050400@davidnewall.com>
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Mar 2009 08:29:42.0821 (UTC) FILETIME=[5E0BE550:01C99CA3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2009 05:29 AM, David Newall wrote:
> It sounds like you want everything to just continue running.  I don't
>    
Yes, exactly. Backup kernel will take control when a crush occured 
without need a reboot or halt.
> see how that can be done.  All of those in-kernel tables and structures
> would need to be migrated, and it follows, because there was a crash,
> that any of them might have been corrupted.  Worse, you want this to
> save you when you try running a new kernel which crashes, and being a
> new kernel, it follows that any of those structures could be different;
> it might not be possible to create equivalent structures for different
> kernel versions.
>
>    
Yes, that's right and it's the first thing needed to overcome. Maybe, it 
could be implemented like this :

- Primary kernel could be 2.6.x or 2.6.x.y (2.6.28 or 2.6.28.1)
- Backup kernel could be one of these .y fix releases only: Like 2.6.28.5

So; when they're from the same version, it will prevent kernel API and 
structure changes.
For resuming by backup kernel: The primary kernel could write a journal 
about the needed things for backup to resume. Like process IDs, memory 
and process situations etc. The same manner as the Journalled File 
Systems did (they write a journal what they did to recover/resume at 
crash/disaster time).

