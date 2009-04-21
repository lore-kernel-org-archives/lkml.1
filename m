Return-Path: <linux-kernel-owner+w=401wt.eu-S1758427AbZDUVQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427AbZDUVQj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 17:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755120AbZDUVQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 17:16:12 -0400
Received: from mail.fieldses.org ([141.211.133.115]:46833 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbZDUVQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 17:16:11 -0400
Date: Tue, 21 Apr 2009 17:15:59 -0400
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>, hooanon05@yahoo.co.jp,
       hch@infradead.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] Fix i_mutex handling in nfsd readdir
Message-ID: <20090421211559.GA27411@fieldses.org>
References: <1239960739.3428.33.camel@macbook.infradead.org> <20090417193233.GM26366@ZenIV.linux.org.uk> <1240006620.19059.41.camel@macbook.infradead.org> <20090417224350.GN26366@ZenIV.linux.org.uk> <20090417225306.GO26366@ZenIV.linux.org.uk> <1240013753.21423.86.camel@macbook.infradead.org> <1240144069.3589.156.camel@macbook.infradead.org> <20090419205154.GA18110@fieldses.org> <20090420195008.GE1823@fieldses.org> <20090421002934.GB8633@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090421002934.GB8633@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 01:29:34AM +0100, Al Viro wrote:
> > Sorry for the delay.  Simpler might be just to drop and reacquire the
> > mutex each time through nfsd4_list_rec_dir()'s loop, but I'd just as
> > soon rework the called functions to expect the mutex be held (and get
> > rid of the unused, probably fragile, clear_clid_dir() in the process).
> > 
> > So the following could be folded in to your patch.
> > 
> > I tested the combined patch over 2.6.30-rc2.  I also tested 2.6.29 +
> > 05f4f678 + the combined patch.  Both look  OK.  Feel free to add a
> > tested-by or acked-by for "J. Bruce Fields" <bfields@citi.umich.edu> as
> > appropriate.  Or happy to add a s-o-b and shepherd it along myself if
> > it's easier....
> 
> I can take both, but if you prefer to have that one go through nfs tree -
> fine by me.
> 
> I'm going to push a queue into for-next in a couple of hours; running build
> tests right now.  Patch from dwmw2 is in there...

However it makes it there is fine by me; I'll wait for one of you to
take care of it.

--b.
