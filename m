Return-Path: <linux-kernel-owner+w=401wt.eu-S932206AbXAaB3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206AbXAaB3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 20:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932248AbXAaB3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 20:29:32 -0500
Received: from smtp.osdl.org ([65.172.181.24]:32830 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932206AbXAaB3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 20:29:31 -0500
Date: Tue, 30 Jan 2007 17:28:38 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Layton <jlayton@redhat.com>
cc: Bodo Eggert <7eggert@gmx.de>, akpm@osdl.org, dev@sw.ru,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       torvalds@osdl.org
Subject: Re: [PATCH] pipefs unique inode numbers
In-Reply-To: <45BFEE85.30203@redhat.com>
Message-ID: <Pine.LNX.4.64.0701301726280.3611@woody.linux-foundation.org>
References: <Pine.LNX.4.58.0701302314210.2203@be1.lrz> <45BFEE85.30203@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Jan 2007, Jeff Layton wrote:
> 
> Also, that patch would break many 32-bit programs not compiled with large
> offsets when run in compatibility mode on a 64-bit kernel. If they were to
> do a stat on this inode, it would likely generate an EOVERFLOW error since
> the pointer address would probably not fit in a 32 bit field.
> 
> That problem was the whole impetus for this set of patches.

Well, we have that problem with the slowly incrementing "last_ino" too.

Should we make "last_ino" be "static unsigned int" instead of "long"?

Does anybody actually even use the old stat() with 32-bit interfaces? We 
warn for it, and we've done so for a long time.. I dont' remember people 
even complaining about the warning, so..

		Linus
