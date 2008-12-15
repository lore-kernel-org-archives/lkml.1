Return-Path: <linux-kernel-owner+w=401wt.eu-S1757374AbYLOVDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbYLOVDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 16:03:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756045AbYLOVDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 16:03:38 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:56487 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419AbYLOVDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 16:03:37 -0500
Date: Mon, 15 Dec 2008 14:03:23 -0700
From: Andreas Dilger <adilger@sun.com>
Subject: Re: Btrfs trees for linux-next
In-reply-to: <1229006596.22236.46.camel@think.oraclecorp.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       linux-btrfs@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Message-id: <20081215210323.GB5000@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <1227183484.6161.17.camel@think.oraclecorp.com>
 <1228962896.21376.11.camel@think.oraclecorp.com>
 <20081211141436.030c2d65.sfr@canb.auug.org.au>
 <20081210200604.8e190b0d.akpm@linux-foundation.org>
 <1229006596.22236.46.camel@think.oraclecorp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 11, 2008  09:43 -0500, Chris Mason wrote:
> The multi-device code uses a very simple brute force scan from userland
> to populate the list of devices that belong to a given FS.  Kay Sievers
> has some ideas on hotplug magic to make this less dumb.  (The scan isn't
> required for single device filesystems).

This should use libblkid to do the scanning of the devices, and it can
cache the results for efficiency.  Best would be to have the same LABEL+UUID
for all devices in the same filesystem, and then once any of these devices
are found the mount.btrfs code can query the rest of the devices to find
the remaining parts of the filesystem.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

