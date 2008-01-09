Return-Path: <linux-kernel-owner+w=401wt.eu-S1755665AbYAIJSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbYAIJSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 04:18:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027AbYAIJRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 04:17:05 -0500
Received: from mail.clusterfs.com ([74.0.229.162]:47954 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333AbYAIJQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 04:16:58 -0500
Date: Wed, 9 Jan 2008 02:16:56 -0700
From: Andreas Dilger <adilger@sun.com>
To: Alan <alan@clueserver.org>
Cc: Al Boldi <a1426z@gawab.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFD] Incremental fsck
Message-ID: <20080109091656.GL3351@webber.adilger.int>
Mail-Followup-To: Alan <alan@clueserver.org>, Al Boldi <a1426z@gawab.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200801090022.55589.a1426z@gawab.com> <60808.198.182.194.170.1199827911.squirrel@clueserver.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60808.198.182.194.170.1199827911.squirrel@clueserver.org>
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Theodore Tso <tytso@mit.edu> writes:
>> > Now, there are good reasons for doing periodic checks every N mounts
>> > and after M months.  And it has to do with PC class hardware.  (Ted's
>> > aphorism: "PC class hardware is cr*p").
>>
>> If these reasons are good ones (some skepticism here) then the correct
>> way to really handle this would be to do regular background scrubbing
>> during runtime; ideally with metadata checksums so that you can actually
>> detect all corruption.
>>
>> But since fsck is so slow and disks are so big this whole thing
>> is a ticking time bomb now. e.g. it is not uncommon to require tens
>> of minutes or even hours of fsck time and some server that reboots
>> only every few months will eat that when it happens to reboot.
>> This means you get a quite long downtime.
>
> Has there been some thought about an incremental fsck?

While an _incremental_ fsck isn't so easy for existing filesystem types,
what is pretty easy to automate is making a read-only snapshot of a
filesystem via LVM/DM and then running e2fsck against that.  The kernel
and filesystem have hooks to flush the changes from cache and make the
on-disk state consistent.

You can then set the the ext[234] superblock mount count and last check
time via tune2fs if all is well, or schedule an outage if there are
inconsistencies found.

There is a copy of this script at:
http://osdir.com/ml/linux.lvm.devel/2003-04/msg00001.html

Note that it might need some tweaks to run with DM/LVM2 commands/output,
but is mostly what is needed.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

