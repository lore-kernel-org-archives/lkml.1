Return-Path: <linux-kernel-owner+w=401wt.eu-S1760831AbYBLGnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760831AbYBLGnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 01:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754291AbYBLGnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 01:43:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33040
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754085AbYBLGnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 01:43:07 -0500
Date: Mon, 11 Feb 2008 22:43:38 -0800 (PST)
Message-Id: <20080211.224338.07019204.davem@davemloft.net>
To: chris.mason@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       btrfs-devel@oss.oracle.com
Subject: Re: [ANNOUNCE] Btrfs v0.12 released
From: David Miller <davem@davemloft.net>
In-Reply-To: <200802110842.21312.chris.mason@oracle.com>
References: <200802061200.14690.chris.mason@oracle.com>
	<20080210.171257.233096646.davem@davemloft.net>
	<200802110842.21312.chris.mason@oracle.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Mason <chris.mason@oracle.com>
Date: Mon, 11 Feb 2008 08:42:20 -0500

> The kernel is actually worse, because the set/get macros are more complex.  
> Some live in ctree.h like in the progs, but the nasty ones live in 
> struct-funcs.c

This is really problematic, because you've got these things called
"btrfs_item_ptr()" which really isn't a pointer, it's a relative
'unsigned long' offset cast to a pointer.  The source of this
seems to be btrfs_leaf_data().

And then those things get passed down into the SETGET functions!

Then deeper down we have terribly inconsistent things like
btrfs_item_nr_offset() and
btrfs_item_offset_nr().

Sigh... I'll see what I can do.
