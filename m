Return-Path: <linux-kernel-owner+w=401wt.eu-S1751883AbXDHTUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbXDHTUo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 15:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbXDHTUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 15:20:43 -0400
Received: from thunk.org ([69.25.196.29]:56931 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbXDHTUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 15:20:42 -0400
Date: Sun, 8 Apr 2007 15:19:55 -0400
From: Theodore Tso <tytso@mit.edu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>
Subject: Re: If not readdir() then what?
Message-ID: <20070408191955.GD29180@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Christoph Hellwig <hch@infradead.org>,
	Ulrich Drepper <drepper@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Neil Brown <neilb@suse.de>
References: <a36005b50704070957v2d2e6c4g5fac49b5ff1a5789@mail.gmail.com> <20070407203633.GA21555@thunk.org> <20070407233037.GA16508@infradead.org> <46193048.6000606@zytor.com> <20070408184129.GA20871@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070408184129.GA20871@lazybastard.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 08, 2007 at 08:41:30PM +0200, Jörn Engel wrote:
> 
> Garbage-collecting them on closedir() does not work.  It surprised me as
> well, but there seem to be applications that keep the telldir() cookie
> around after closedir().  Iirc, "rm -r" was one of them.
> 
> Neil, is this correct?

Well, according to the Single Unix Specification:

    If the value of loc was not obtained from an earlier call to
    telldir(), or if a call to rewinddir() occurred between the call
    to telldir() and the call to seekdir(), the results of subsequent
    calls to readdir() are unspecified.

It doesn't state explicitly that you can use the telldir cookie()
after closing the directory stream using closedir() and then reopening
it using opendir(), but given that it states that results are
undefined after a rewinddir() --- which is much less violent than a
closedir()/opendir(), I would definitely argue that an application
programmer would be very ill-advised to rely on this working.

(Of course, I'd argue that an application programmer shouldn't use
telldir/seekdir at all.....)

Ulrich, is it too late to insert a clarification that the telldir()
cookie isn't guaranteed to be valid after closedir() *or* rewinddir()?

						- Ted
