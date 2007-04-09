Return-Path: <linux-kernel-owner+w=401wt.eu-S1752235AbXDIBpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbXDIBpP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 21:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbXDIBpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 21:45:15 -0400
Received: from thunk.org ([69.25.196.29]:55532 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbXDIBpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 21:45:13 -0400
Date: Sun, 8 Apr 2007 21:44:26 -0400
From: Theodore Tso <tytso@mit.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>
Subject: Re: If not readdir() then what?
Message-ID: <20070409014426.GA18580@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
	Christoph Hellwig <hch@infradead.org>,
	Ulrich Drepper <drepper@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Neil Brown <neilb@suse.de>
References: <a36005b50704070957v2d2e6c4g5fac49b5ff1a5789@mail.gmail.com> <20070407203633.GA21555@thunk.org> <20070407233037.GA16508@infradead.org> <46193048.6000606@zytor.com> <20070408184129.GA20871@lazybastard.org> <20070408191955.GD29180@thunk.org> <46194260.3050900@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46194260.3050900@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 08, 2007 at 12:28:32PM -0700, H. Peter Anvin wrote:
> Theodore Tso wrote:
> >It doesn't state explicitly that you can use the telldir cookie()
> >after closing the directory stream using closedir() and then reopening
> >it using opendir(), but given that it states that results are
> >undefined after a rewinddir() --- which is much less violent than a
> >closedir()/opendir(), I would definitely argue that an application
> >programmer would be very ill-advised to rely on this working.
> >
> >(Of course, I'd argue that an application programmer shouldn't use
> >telldir/seekdir at all.....)
> >
> >Ulrich, is it too late to insert a clarification that the telldir()
> >cookie isn't guaranteed to be valid after closedir() *or* rewinddir()?
> 
> More fundamentally, the telldir cookie should never be valid when 
> applied to a different DIR * (even one that refers to the same directory.)

Well, Joern thought that rm -rf might relying on the telldir cookie
being valid in precisely that circumstance.  If that is true, I'd
argue that this is a BUG in GNU coreutils that should be fixed...

						- Ted

