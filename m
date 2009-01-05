Return-Path: <linux-kernel-owner+w=401wt.eu-S1752798AbZAEDgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbZAEDgR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 22:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbZAEDgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 22:36:00 -0500
Received: from rcsinet14.oracle.com ([148.87.113.126]:39692 "EHLO
	rgminet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbZAEDf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 22:35:59 -0500
To: Rob Landley <rob@landley.net>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, tytso@mit.edu, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <fa.P4z5CJpM0xT37PWJuOuCHDkO76o@ifi.uio.no>
	<fa.26o5IHCAC3TQdXupl62CLYwQ+Wk@ifi.uio.no>
	<49614284.8040201@yahoo.com> <200901042051.14269.rob@landley.net>
Date: Sun, 04 Jan 2009 22:33:51 -0500
In-Reply-To: <200901042051.14269.rob@landley.net> (Rob Landley's message of "Sun\, 4 Jan 2009 20\:51\:13 -0600")
Message-ID: <yq1mye62zq8.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.49617FA3.0199:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Rob" == Rob Landley <rob@landley.net> writes:

Rob> I wonder if the flash filesystems could be told via mount options
Rob> that they're to use a normal block device as if it was a flash with
Rob> granularity X?

I posted some patches a few months ago that allowed us to do this.  In
particular they expose the underlying I/O topology to the filesystems.
That includes minimum, preferred and maximum I/O size for both read and
write as well as alignment.  The patches also allow stacking so we get
alignment right on say LVM on top of MD on top of a partitioned disk.

At Kernel Summit/Plumbers Linus absolutely hated this idea in the
context of SSDs.  And I don't necessarily disagree with his point that
intel (claim to have) solved this problem.

However, there's still lots of crappy devices out there that we need to
support.  And we absolutely need this for RAID (both software and
hardware) as well.  I've been meaning to post a new round of these
patches.  I'll take a look at them again this week.

The intent was to use the alignment and block sizes to honor erase block
boundaries when merging requests.

SCSI already has knobs that expose the appropriate sizes although not
many vendors implement them yet.  I've been talking to a few SSD vendors
about exposing similar parameters with SATA.  Most of them are willing
and will happily share this information.  Other vendors stop responding
when you ask them too many questions.

-- 
Martin K. Petersen	Oracle Linux Engineering

