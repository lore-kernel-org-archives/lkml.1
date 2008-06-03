Return-Path: <linux-kernel-owner+w=401wt.eu-S1757878AbYFCRvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878AbYFCRvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757266AbYFCRu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:50:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38952 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310AbYFCRu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:50:57 -0400
Date: Tue, 3 Jun 2008 18:50:53 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ian Kent <raven@themaw.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, jesper@krogh.cc,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Linux 2.6.26-rc4
Message-ID: <20080603175053.GF28946@ZenIV.linux.org.uk>
References: <20080603105258.GV28946@ZenIV.linux.org.uk> <1212499623.3025.46.camel@raven.themaw.net> <alpine.LFD.1.10.0806030751040.3473@woody.linux-foundation.org> <1212509263.3025.66.camel@raven.themaw.net> <alpine.LFD.1.10.0806030926330.3473@woody.linux-foundation.org> <20080603164102.GB28946@ZenIV.linux.org.uk> <20080603165042.GC28946@ZenIV.linux.org.uk> <1212514104.3025.110.camel@raven.themaw.net> <20080603174125.GE28946@ZenIV.linux.org.uk> <1212514893.3025.123.camel@raven.themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212514893.3025.123.camel@raven.themaw.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2008 at 01:41:32AM +0800, Ian Kent wrote:

> OK, I'll need to look at vfs_readdir().
> I thought vfs_readdir() would take the containing directory mutex as
> does ->lookup().

vfs_readdir() takes i_mutex on directory it reads.  I.e. on the victim
in this case.  lookup has i_mutex on directory it does lookup in, i.e.
root in this case...
