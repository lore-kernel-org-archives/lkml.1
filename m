Return-Path: <linux-kernel-owner+w=401wt.eu-S1753664AbXFNSVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbXFNSVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 14:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbXFNSVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 14:21:44 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:54095 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbXFNSVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 14:21:43 -0400
Message-ID: <467186EA.6090409@oracle.com>
Date: Thu, 14 Jun 2007 14:20:26 -0400
From: Chuck Lever <chuck.lever@oracle.com>
Reply-To: chuck.lever@oracle.com
Organization: Corporate Architecture team, Oracle USA
User-Agent: Thunderbird 2.0.0.0 (Macintosh/20070326)
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: John Stoffel <john@stoffel.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] Btrfs: a copy on write, snapshotting FS
References: <20070612161029.GB28279@think.oraclecorp.com> <18031.26764.586958.632146@stoffel.org>
In-Reply-To: <18031.26764.586958.632146@stoffel.org>
Content-Type: multipart/mixed;
 boundary="------------070306050908040203050904"
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070306050908040203050904
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Chris-

John Stoffel wrote:
> As a user of Netapps, having quotas (if only for reporting purposes)
> and some way to migrate non-used files to slower/cheaper storage would
> be great.
> 
> Ie. being able to setup two pools, one being RAID6, the other being
> RAID1, where all currently accessed files are in the RAID1 setup, but
> if un-used get migrated to the RAID6 area.  
> 
> And of course some way for efficient backups and more importantly
> RESTORES of data which is segregated like this.  

I like the way dump and restore was handled in AFS (and now ZFS and 
NetApp).  There is a simple command to flatten a file system and send it 
to another system, which can receive it and re-expand it.  The 
dump/restore process uses snapshots and can easily send incremental 
backups which are significantly smaller than 0-level.  This is somewhat 
better than rsync, because you don't need checksums to discover what 
data has changed -- you already have the new data segregated into 
copied-on-write blocks.

NetApp happens to use the standard NDMP protocol for sending the 
flattened file system.  NetApp uses it for synchronous replication, 
volume migration, and back up to nearline storage and tape.  AFS used 
"vol dump" and "vol restore" for migration, replication, and back-up. 
ZFS has the "zfs send" and "zfs receive" commands that do basically the 
same (Eric Kustarz recently published a blog entry that described how 
these work).  And of course, all file system objects are able to be sent 
this way:  streams, xattrs, ACLs, and so on are all supported.

Note also that NFSv4 supports the idea of migrated or replicated file 
objects.  All that is needed to support it is a mechanism on the servers 
to actually move the data.

--------------070306050908040203050904
Content-Type: text/x-vcard; charset=utf-8;
 name="chuck.lever.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="chuck.lever.vcf"

begin:vcard
fn:Chuck Lever
n:Lever;Chuck
org:Oracle Corporation;Corporate Architecture: Linux Projects Group
adr:;;1015 Granger Avenue;Ann Arbor;MI;48104;USA
email;internet:chuck dot lever at nospam oracle dot com
title:Principal Member of Staff
tel;work:+1 248 614 5091
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------070306050908040203050904--
