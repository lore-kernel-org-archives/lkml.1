Return-Path: <linux-kernel-owner+w=401wt.eu-S1752389AbZA1Ro2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbZA1Ro2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 12:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751262AbZA1RoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 12:44:17 -0500
Received: from vena.lwn.net ([206.168.112.25]:38589 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbZA1RoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 12:44:16 -0500
Date: Wed, 28 Jan 2009 10:44:14 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Christoph Hellwig <hch@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, hch@infradead.org,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       linux-api@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH, RFC] Remove fasync() BKL usage, take 3325
Message-ID: <20090128104414.09aee3f9@bike.lwn.net>
In-Reply-To: <20090128173618.GA3174@infradead.org>
References: <20090115153211.663df310@bike.lwn.net>
	<20090122065104.2787df2d.akpm@linux-foundation.org>
	<20090122203248.GA20159@infradead.org>
	<20090123045646.GK15750@one.firstfloor.org>
	<20090127165504.53ed7a2d.akpm@linux-foundation.org>
	<20090128031439.GA11025@redhat.com>
	<20090128173618.GA3174@infradead.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009 12:36:18 -0500
Christoph Hellwig <hch@infradead.org> wrote:

> ->f_flags is an unsigned int and the bit macros need an unsigned
> long. Increasing the size of struct file for this is probably a bad
> idea.

That was my concern too, initially, but akpm told me it was OK.  From
earlier in the thread:

> > The problem there is that this bloats struct file, and that seemed like
> > something worth avoiding.  
> 
> Not a big deal, really.  There's one of these for each presently-open file.
> It's not like dentries and inodes, which we cache after userspace has
> closed off the file handles.

If others disagree, and using bitops is not an idea which will fly, I'd
sure like to know sooner rather than later.

jon
