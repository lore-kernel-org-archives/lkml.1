Return-Path: <linux-kernel-owner+w=401wt.eu-S1754471Ab0AICn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab0AICn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 21:43:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215Ab0AICn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 21:43:58 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43905 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab0AICn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 21:43:57 -0500
Date: Sat, 9 Jan 2010 02:43:53 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-nfs@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Fix up the NFS mmap code
Message-ID: <20100109024353.GJ30528@ZenIV.linux.org.uk>
References: <1262913974.2659.101.camel@localhost> <20100109005624.7473.33215.stgit@localhost.localdomain> <alpine.LFD.2.00.1001081709470.7821@localhost.localdomain> <20100109013825.GD30528@ZenIV.linux.org.uk> <alpine.LFD.2.00.1001081750080.7821@localhost.localdomain> <20100109021124.GG30528@ZenIV.linux.org.uk> <alpine.LFD.2.00.1001081814240.7821@localhost.localdomain> <20100109023035.GH30528@ZenIV.linux.org.uk> <20100109024005.GI30528@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100109024005.GI30528@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 09, 2010 at 02:40:05AM +0000, Al Viro wrote:
> On Sat, Jan 09, 2010 at 02:30:35AM +0000, Al Viro wrote:
> 
> > Interesting...  There's nfs_update_inode(), but it ought to scream bloody
> > murder on the type change (and its return value is ignore by nfs_fhget(),
> > BTW).
> 
> Uh-oh...  Just what will happen if we get FATTR_MODE without FATTR_TYPE,
> BTW?  AFAICS, the check for changed type won't trigger, but we will
> get type bits in i_mode set to 0.  Probably unrelated, but...

Definitely unrelated - we'll get i_mode buggered, but i_op remains set.
