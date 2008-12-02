Return-Path: <linux-kernel-owner+w=401wt.eu-S1755447AbYLBQrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbYLBQrB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 11:47:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbYLBQqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 11:46:50 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:35048 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbYLBQqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 11:46:49 -0500
Date: Tue, 2 Dec 2008 09:46:31 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Karel Zak <kzak@redhat.com>
Cc: Jamie Lokier <jamie@shareable.org>, Matthew Garrett <mjg@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mingo@redhat.com, val.henson@gmail.com
Subject: Re: [PATCH v4] relatime: Make relatime smarter
Message-ID: <20081202164631.GA25548@parisc-linux.org>
References: <20081127150126.GA20941@srcf.ucam.org> <20081127150341.GB20941@srcf.ucam.org> <20081127163535.775729bf@lxorguk.ukuu.org.uk> <20081127164754.GC22963@srcf.ucam.org> <20081127165929.GA23366@srcf.ucam.org> <20081127170615.GB14991@infradead.org> <20081127175813.GA24354@srcf.ucam.org> <20081128111809.GH6138@shareable.org> <20081128134055.GQ25548@parisc-linux.org> <20081202111025.GI2956@nb.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081202111025.GI2956@nb.net.home>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2008 at 12:10:25PM +0100, Karel Zak wrote:
> On Fri, Nov 28, 2008 at 06:40:55AM -0700, Matthew Wilcox wrote:
> > On Fri, Nov 28, 2008 at 11:18:09AM +0000, Jamie Lokier wrote:
> > > Matthew Garrett wrote:
> > > > The time between atime updates can be configured at boot
> > > > with the relatime_interval kernel argument, or at runtime through a sysctl.
> > > 
> > > Shouldn't it be a per-mount value, with defaults coming from the sysctl?
> > 
> > Perhaps a more sensible question would be "Why make it configurable at
> 
>  this is GNOME-mentality :-)

Yes, I frequently pal around with terrorists.

> > all?"  What's wrong with hardcoding 24 hours?  Or, to put it another
> > way, who wants to change it from 24 hours, and why?
> 
>  Why do you think that 24 hours is the right default value? Do you
>  have any logical argument for this setting?

Once a day seems like a good value to me.  It's a good human being
timescale and still cuts down the number of atime updates by a lot.

If somebody really cares, they could graph the relatime_update value
against number of writes performed in a given period and determine a
better cutoff.  I can think of a hundred better ways to spend my time
though.

Good job of not answering the question, by the way.  Why _not_ 24 hours?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
