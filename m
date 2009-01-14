Return-Path: <linux-kernel-owner+w=401wt.eu-S1760700AbZANAOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760700AbZANAOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 19:14:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757742AbZANANw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 19:13:52 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:24321 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757156AbZANANv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 19:13:51 -0500
X-IronPort-AV: E=Sophos;i="4.37,261,1231113600"; 
   d="scan'208";a="122294804"
From: Roland Dreier <rdreier@cisco.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: Remove extra KERN_INFO in the middle of a line
References: <adamydukawi.fsf@cisco.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 13 Jan 2009 16:13:49 -0800
In-Reply-To: <adamydukawi.fsf@cisco.com> (Roland Dreier's message of "Tue, 13
	Jan 2009 16:07:41 -0800")
Message-ID: <adaiqoikama.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Jan 2009 00:13:49.0679 (UTC) FILETIME=[F98CF7F0:01C975DC]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By the way, looking at nearby code:

	else {
		/* FIXME, make a readl uuid parser */
		printk(KERN_INFO "device fsid %llx-%llx ",
		       *(unsigned long long *)disk_super->fsid,
		       *(unsigned long long *)(disk_super->fsid + 8));
	}

aside from the readl typo here, it occurs to me that this is not
endian-safe, because AFAIK nothing ever swaps disk_super->fsid ... so
this would produce possibly confusing output if someone ever moved
storage with a btrfs filesystem on it from one endianness to another...
