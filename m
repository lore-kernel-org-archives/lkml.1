Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab0BJV3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 16:29:44 -0500
Received: from intermatrixgroup.ru ([195.178.208.66]:57085 "EHLO
	tservice.net.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab0BJV3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 16:29:42 -0500
Date: Thu, 11 Feb 2010 00:29:33 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [WTF] ... is going on with current->fs->{root,mnt} accesses in pohmelfs
Message-ID: <20100210212933.GA19919@ioremap.net>
References: <20100210100428.GL30031@ZenIV.linux.org.uk> <20100210101246.GA3509@ioremap.net> <20100210102422.GM30031@ZenIV.linux.org.uk> <20100210104515.GA6207@ioremap.net> <20100210110011.GN30031@ZenIV.linux.org.uk> <20100210111115.GA8376@ioremap.net> <20100210115938.GO30031@ZenIV.linux.org.uk> <20100210133007.GA17744@ioremap.net> <20100210210248.GP30031@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100210210248.GP30031@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 10, 2010 at 09:02:48PM +0000, Al Viro (viro@ZenIV.linux.org.uk) wrote:
> Which would be... ?  E.g. between writepages() and rename().  What serializes
> your write_inode_create() wrt renames?  IOW, how can the server decide that
> data from writepages() should go to the same object regardless of the
> rename?

rename and some other metadata operations as well as write itself
request remote lock (if not grabbed already), acknowledge forces writeback to old path.

-- 
	Evgeniy Polyakov
