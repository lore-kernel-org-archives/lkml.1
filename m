Return-Path: <linux-kernel-owner+w=401wt.eu-S1753256AbZFHSE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbZFHSE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 14:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750924AbZFHSET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 14:04:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750725AbZFHSES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 14:04:18 -0400
Date: Mon, 8 Jun 2009 11:01:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Miklos Szeredi <miklos@szeredi.hu>, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, hugh@veritas.com,
       tj@kernel.org, adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk,
       gregkh@suse.de, npiggin@suse.de, akpm@linux-foundation.org,
       hch@infradead.org
Subject: Re: [PATCH 0/23] File descriptor hot-unplug support v2
In-Reply-To: <20090608175018.GM8633@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.01.0906081100000.6847@localhost.localdomain>
References: <m1skkf761y.fsf@fess.ebiederm.org> <m1oct739xu.fsf@fess.ebiederm.org> <20090606080334.GA15204@ZenIV.linux.org.uk> <E1MDbLz-0003wm-Db@pomaz-ex.szeredi.hu> <20090608162913.GL8633@ZenIV.linux.org.uk> <E1MDhxh-0004nz-Qm@pomaz-ex.szeredi.hu>
 <20090608175018.GM8633@ZenIV.linux.org.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 8 Jun 2009, Al Viro wrote:
> 
> Welcome to reality...
> 
> * bread() is non-interruptible
> * so's copy_from_user()/copy_to_user()
> * IO we are stuck upon _might_ be interruptible, but by sending a signal
> to some other process

We can probably improve on these, though.

Like the copy_to/from_user thing. We might well be able to do that whole 
"if it's a fatal signal, return early" thing.

So in the _general_ case - no, we probably can't fix things. But we could 
likely at least improve in some common cases if we cared.

			Linus
