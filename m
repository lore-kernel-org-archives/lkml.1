Return-Path: <linux-kernel-owner+w=401wt.eu-S933546AbYETU5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933546AbYETU5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 16:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759287AbYETU5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 16:57:00 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:57370 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758895AbYETU47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 16:56:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=MyFTpnDxYg0OF4CqcXuLhnj/Db63SryzKK+36FS0q/3lB68KY5gFs4aOXfZUynrXlKGSeBKCiLUb4Z/z5LJkNWGFvMcFOzcKRA7mb7Ae1ZXND080XXO0lY1DGn2WR0QmI7fMYlLA6At6A9BAwoTAZF2/9Z5XgI9N8N27YkjItrc=
Date: Wed, 21 May 2008 01:52:39 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Dave Jones <davej@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make (LIST_DEBUG WARN not BUG)
Message-ID: <20080520215238.GA25309@martell.zuzino.mipt.ru>
References: <20080502182745.GL14976@parisc-linux.org> <20080501133209.2c04dad0@infradead.org> <20080502184922.GM14976@parisc-linux.org> <20080520032448.GA19348@redhat.com> <20080520071458.707d6e90@infradead.org> <20080520142727.GC4843@redhat.com> <b6fcc0a0805200800k10264445n59bb56d24b80cd2f@mail.gmail.com> <alpine.LFD.1.10.0805200806340.32253@woody.linux-foundation.org> <20080520152227.GC542@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520152227.GC542@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 11:22:27AM -0400, Dave Jones wrote:
> On Tue, May 20, 2008 at 08:12:41AM -0700, Linus Torvalds wrote:
> 
>  > So no, lists aren't "special" in any inherent way, they are just special 
>  > in these kinds of "incidentally, a lot of random data structure corruption 
>  > has traditionally shown up in lists, because there are so many of them".
> 
> It's also been _really_ useful for showing up random bit flips in bad hardware.
> 
> "hey, if that bit had been a 1, this pointer would have looked valid and we
>  wouldn't have oopsed" has led to quite a few cases where the reporter then
> found a session with memtest86 enlightening.

Affirmative, LIST_DEBUG is very useful.

Let's look again at what patch actually does: writes to corrupted memory
will be done even if it's known for sure it's corrupted.

There is

	BUG_ON(!list_empty(&father->children));

in forget_original_parent(). Should it be changed to WARN_ON? Why [not]?

