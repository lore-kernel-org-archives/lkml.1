Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbZDUA3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbZDUA3x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 20:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbZDUA3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 20:29:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47464 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbZDUA3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 20:29:41 -0400
Date: Tue, 21 Apr 2009 01:29:34 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: David Woodhouse <dwmw2@infradead.org>, hooanon05@yahoo.co.jp,
       hch@infradead.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] Fix i_mutex handling in nfsd readdir
Message-ID: <20090421002934.GB8633@ZenIV.linux.org.uk>
References: <8913.1237476890@jrobl> <1239960739.3428.33.camel@macbook.infradead.org> <20090417193233.GM26366@ZenIV.linux.org.uk> <1240006620.19059.41.camel@macbook.infradead.org> <20090417224350.GN26366@ZenIV.linux.org.uk> <20090417225306.GO26366@ZenIV.linux.org.uk> <1240013753.21423.86.camel@macbook.infradead.org> <1240144069.3589.156.camel@macbook.infradead.org> <20090419205154.GA18110@fieldses.org> <20090420195008.GE1823@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090420195008.GE1823@fieldses.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry for the delay.  Simpler might be just to drop and reacquire the
> mutex each time through nfsd4_list_rec_dir()'s loop, but I'd just as
> soon rework the called functions to expect the mutex be held (and get
> rid of the unused, probably fragile, clear_clid_dir() in the process).
> 
> So the following could be folded in to your patch.
> 
> I tested the combined patch over 2.6.30-rc2.  I also tested 2.6.29 +
> 05f4f678 + the combined patch.  Both look  OK.  Feel free to add a
> tested-by or acked-by for "J. Bruce Fields" <bfields@citi.umich.edu> as
> appropriate.  Or happy to add a s-o-b and shepherd it along myself if
> it's easier....

I can take both, but if you prefer to have that one go through nfs tree -
fine by me.

I'm going to push a queue into for-next in a couple of hours; running build
tests right now.  Patch from dwmw2 is in there...
