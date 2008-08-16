Return-Path: <linux-kernel-owner+w=401wt.eu-S1753106AbYHPJkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbYHPJkr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 05:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYHPJki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 05:40:38 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:57800 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751955AbYHPJkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 05:40:36 -0400
Date: Sat, 16 Aug 2008 05:39:52 -0400
From: Theodore Tso <tytso@mit.edu>
To: Peter Dolding <oiaohm@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, david@lang.hm, rmeijer@xs4all.nl,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, capibara@xs4all.nl,
       Eric Paris <eparis@redhat.com>, Rik van Riel <riel@redhat.com>,
       davecb@sun.com, linux-security-module@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>, Mihai Don??u <mdontu@bitdefender.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       Pavel Machek <pavel@suse.cz>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon
	access scanning
Message-ID: <20080816093952.GF22395@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Peter Dolding <oiaohm@gmail.com>,
	Arjan van de Ven <arjan@infradead.org>, david@lang.hm,
	rmeijer@xs4all.nl, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	capibara@xs4all.nl, Eric Paris <eparis@redhat.com>,
	Rik van Riel <riel@redhat.com>, davecb@sun.com,
	linux-security-module@vger.kernel.org,
	Adrian Bunk <bunk@kernel.org>,
	Mihai Don??u <mdontu@bitdefender.com>, linux-kernel@vger.kernel.org,
	malware-list@lists.printk.net, Pavel Machek <pavel@suse.cz>
References: <18129.82.95.100.23.1218802937.squirrel@webmail.xs4all.nl> <e7d8f83e0808150627m7a5c8738n8ac42d77c45eea76@mail.gmail.com> <alpine.DEB.1.10.0808151024120.15109@asgard.lang.hm> <e7d8f83e0808152057h5c607cfbnecdc6f0bd05c5d89@mail.gmail.com> <20080815210942.4e342c6c@infradead.org> <e7d8f83e0808152219j50827f49nb9dd48cf44e082d2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7d8f83e0808152219j50827f49nb9dd48cf44e082d2@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2008 at 03:19:43PM +1000, Peter Dolding wrote:
> Lets look at the general disk to memory path.
> 
> [file system driver]
> [file system drivers caches]
> [inode's]  TALPA links in here and basically runs its own scan cache.
> 
> Long term TALPA need to move from the inode layor down and the design
> of the file system path needs to change.

Huh?  What are you talking about?  In Linux just about all of the
serious filesystems the only caching for file data happens in the page
cache layer.  So what you're saying doesn't make much sense, unless
you're talking about the user space samba daemon --- but even there,
Samba doesn't do any shortcut routing of data; as far as I know
everything goes from Samba, into the filesystem, before it gets served
out to other clients via Samba back out from the filesystem.  So
everything goes through the page cache.

> Reasons
> 1. That shape even if file system extra permissions are decided to be
> kept hidden from the rest of Linux anti-virus can scanning can see it

No one else is taking about checking permissions; I thought this was
all about file *data* that we've been talking about.

If your argument means that we have to take every single
$Proprietary_OS's wacky permissions system, and push them into to core
Linux system so the AV system can evaluate it, I'm pretty sure
everyone is going to vomit all over such a proposal (and over you).

	    	     	       	    	   - Ted
