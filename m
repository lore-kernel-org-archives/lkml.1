Return-Path: <linux-kernel-owner+w=401wt.eu-S935332AbZAPQ76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935332AbZAPQ76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 11:59:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758987AbZAPQ7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 11:59:33 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38989 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812AbZAPQ7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 11:59:32 -0500
Subject: Re: [Ecryptfs-devel] [PATCH] ecryptfs: some inode attrs, and a
 question
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: hooanon05@yahoo.co.jp
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel@vger.kernel.org, ecryptfs-devel@lists.launchpad.net
In-Reply-To: <9829.1232091366@jrobl>
References: <7471.1231827621@jrobl>
	 <1231852628.6954.4.camel@norville.austin.ibm.com>
	 <496FAFE2.8020102@linux.vnet.ibm.com>  <9829.1232091366@jrobl>
Content-Type: text/plain
Date: Fri, 16 Jan 2009 10:59:29 -0600
Message-Id: <1232125169.15209.19.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-16 at 16:36 +0900, hooanon05@yahoo.co.jp wrote:
> Tyler Hicks:

> I guess the problem was related to the i_count including my fixes for
> ecryptfs_unlink() and ecryptfs_link(). Current ecryptfs_link() calls
> ecryptfs_interpose(), but obviously the inode is not I_NEW and the
> incremented i_count is decremented again (finally unchanged).
> The current unnecessary d_drop()s may help hiding the problem, but I am
> not sure.

I think you're hitting on something here.  I never understood  the need
for the d_drop()s, but taking them out broke things.  They probably are
just papering over bugs where the ecryptfs inode is not being properly
updated after changes are made to the lower inode.

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

