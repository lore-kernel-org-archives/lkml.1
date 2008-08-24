Return-Path: <linux-kernel-owner+w=401wt.eu-S1755903AbYHXRVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbYHXRVU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 13:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbYHXRVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 13:21:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752018AbYHXRVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 13:21:08 -0400
Date: Sun, 24 Aug 2008 10:20:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Jan Harkes <jaharkes@cs.cmu.edu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] readdir mess
In-Reply-To: <20080824101014.GN28946@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.1.10.0808241017580.3363@nehalem.linux-foundation.org>
References: <20080812062241.GQ28946@ZenIV.linux.org.uk> <87ej4u9nf5.fsf@devron.myhome.or.jp> <alpine.LFD.1.10.0808121009370.3462@nehalem.linux-foundation.org> <20080812181057.GR28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121316570.3462@nehalem.linux-foundation.org>
 <20080812203808.GV28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121351570.3462@nehalem.linux-foundation.org> <20080813000433.GZ28946@ZenIV.linux.org.uk> <20080815050613.GJ4422@cs.cmu.edu> <alpine.LFD.1.10.0808150940110.3324@nehalem.linux-foundation.org>
 <20080824101014.GN28946@ZenIV.linux.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 24 Aug 2008, Al Viro wrote:
> 
> One obvious note: that'll break old_readdir() on coda.  There you need to
> change the existing check (you need to check buf.result, then ignore error
> unless buf.result ended up 0).

Hmm? old_readdir() was the only one that I didn't change, because it 
didn't need changing. It already ignores the return value of 
"vfs_readdir()" entirely if it is positive or zero, and takes it from 
buf.result.

So old_readdir() literally doesn't care at all (and never has) whether a 
->readdir() function returns zero or a positive number. So changing coda 
readdir() it to return zero _instead_ of a positive number makes 
absolutely zero difference: old_readdir() will do the same thing 
regardless.

What am I missing?

		Linus
