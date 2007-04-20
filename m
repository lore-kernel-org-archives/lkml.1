Return-Path: <linux-kernel-owner+w=401wt.eu-S2993001AbXDTLpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993001AbXDTLpE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 07:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992947AbXDTLpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 07:45:03 -0400
Received: from ns.suse.de ([195.135.220.2]:43313 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993013AbXDTLpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 07:45:00 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [d_path 0/7] Fixes to d_path: Respin
Date: Fri, 20 Apr 2007 13:45:09 +0200
User-Agent: KMail/1.9.5
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, Andrew Morton <akpm@linux-foundation.org>
References: <20070412090809.917795000@suse.de> <20070419232303.300441585@schurl.suse.de> <20070420103008.15f37eec@the-village.bc.nu>
In-Reply-To: <20070420103008.15f37eec@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704201345.09858.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 April 2007 11:30, Alan Cox wrote:
> > As far as I can see, glibc internally looks at /proc/mounts (or else
> > mtab) to find out where tmpfs is mounted for opening files there, and to
> > look up filesystem information for statfs(), while accessing that path,
> > too. Fstatfs() also looks into the same files, but it only matches by
> > filesystem type, so this is only a very unreliable heuristic, anyway.
> >
> > So judging from that, glibc users should be fine.
>
> So glibc does use it and you will change behaviour

Not for statfs(), shm_open(), and sem_open().

Possibly for fstatfs(): fstatfs() has no way of looking up mount points per 
path name in /proc/mounts, and so it resorts to mapping from the numeric 
statfs->f_type to the filesystem name (e.g., "ext3"), looks up the first 
mount point with that name, and sets the statfs->f_flag flags based on that 
entry. This field may change from one arbitrary value to another.

Andreas
