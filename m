Return-Path: <linux-kernel-owner+w=401wt.eu-S1758173AbZIQN43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173AbZIQN43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 09:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756251AbZIQN42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 09:56:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48762 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755277AbZIQN41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 09:56:27 -0400
Date: Thu, 17 Sep 2009 15:56:28 +0200
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, pbadari@us.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Is nobh code still useful?
Message-ID: <20090917135627.GB13660@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  during my page_mkwrite() work, I've looked at who uses nobh_ versions of
various functions in fs/buffer.c. It seems only ext2 and jfs use them. ext3
uses them only from writepage() (which means we needn't attach buffers to a
page when it was written via mmap in writeback mode) and ext4 tries to use
them but in fact it's nop because it always attaches buffers to the page
earlier. So it's not really widely used, there's quite some code to support
it (including one page flag), and it also slightly complicates my
page_mkwrite() fixes.
  So I wanted to ask does somebody actually remember what it is good for?
Buffer heads obviously consume some memory so was that the reason? OTOH we
have to map the page whenever we write to it or send it to disk via
writepage().

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
