Return-Path: <linux-kernel-owner+w=401wt.eu-S1753524AbYAQHiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbYAQHiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 02:38:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbYAQHim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 02:38:42 -0500
Received: from mail.clusterfs.com ([74.0.229.162]:38474 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbYAQHik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 02:38:40 -0500
Date: Thu, 17 Jan 2008 00:38:38 -0700
From: Andreas Dilger <adilger@sun.com>
To: Rik van Riel <riel@redhat.com>
Cc: Daniel Phillips <phillips@google.com>, Pavel Machek <pavel@ucw.cz>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Al Boldi <a1426z@gawab.com>, Valerie Henson <val.henson@gmail.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch] document ext3 requirements (was Re: [RFD] Incremental
	fsck)
Message-ID: <20080117073838.GL3351@webber.adilger.int>
Mail-Followup-To: Rik van Riel <riel@redhat.com>,
	Daniel Phillips <phillips@google.com>, Pavel Machek <pavel@ucw.cz>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
	Al Boldi <a1426z@gawab.com>, Valerie Henson <val.henson@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200801090022.55589.a1426z@gawab.com> <200801090740.12989.a1426z@gawab.com> <70b6f0bf0801082345vf57951ey642e35c3d6e5194f@mail.gmail.com> <200801091452.14890.a1426z@gawab.com> <20080112145140.GB6751@mit.edu> <20080113171916.GB4132@ucw.cz> <20080113174125.5f39ac64@lxorguk.ukuu.org.uk> <20080115201653.GA5639@elf.ucw.cz> <4d47a5d10801151744t378ecdcbj1c326181b4360452@mail.gmail.com> <20080115220528.139da08a@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115220528.139da08a@bree.surriel.com>
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 15, 2008  22:05 -0500, Rik van Riel wrote:
> With a filesystem that is compartmentalized and checksums metadata,
> I believe that an online fsck is absolutely worth having.
> 
> Instead of the filesystem resorting to mounting the whole volume
> read-only on certain errors, part of the filesystem can be offlined
> while an fsck runs.  This could even be done automatically in many
> situations.

In ext4 we store per-group state flags in each group, and the group
descriptor is checksummed (to detect spurious flags), so it should
be relatively straight forward to store an "error" flag in a single
group and have it become read-only.

As a starting point, it would be worthwhile to check instances of
ext4_error() to see how many of them can be targetted at a specific
group.  I'd guess most of them could be (corrupt inodes, directory
and indirect blocks, incorrect bitmaps).

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

