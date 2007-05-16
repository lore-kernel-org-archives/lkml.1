Return-Path: <linux-kernel-owner+w=401wt.eu-S1761675AbXEPCiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761675AbXEPCiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 22:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759779AbXEPCiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 22:38:05 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:52011 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531AbXEPCiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 22:38:03 -0400
X-IronPort-AV: i="4.14,538,1170662400"; 
   d="scan'208"; a="486135819:sNHT50964356"
To: =?iso-8859-1?Q?J=C3=B6rn?= Engel <joern@lazybastard.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: [PATCH] LogFS take three
X-Message-Flag: Warning: May contain useful information
References: <20070515151919.GA32510@lazybastard.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 15 May 2007 19:37:36 -0700
In-Reply-To: <20070515151919.GA32510@lazybastard.org> (=?iso-8859-1?Q?J=C3?=
 =?iso-8859-1?Q?=B6rn?= Engel's message of "Tue, 15 May 2007 17:19:20
 +0200")
Message-ID: <adar6pho5n3.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 May 2007 02:37:37.0440 (UTC) FILETIME=[2A871200:01C79763]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There are rather a lot of of FIXME comments, including scary stuff like

 > +	/*
 > +	 * FIXME: this cannot be right but it does "fix" a bug of i_count
 > +	 * dropping too low.  Needs more thought.
 > +	 */
 > +	atomic_inc(&old_dentry->d_inode->i_count);

and

 > +int __logfs_write_inode(struct inode *inode)
 > +{
 > +	/*
 > +	 * FIXME: Those two inodes are 512 bytes in total.  Not good to
 > +	 * have on the stack.  Possibly the best solution would be to bite
 > +	 * the bullet and do another format change before release and
 > +	 * shrink the inodes.
 > +	 */
 > +	struct logfs_disk_inode old, new;

are you going to change the format?  or fix this some other way?

I think a sweep through the code searching for FIXME and at least
rewriting all such comments to look like stuff that can be deferred
would be warranted ;)

 - R.
