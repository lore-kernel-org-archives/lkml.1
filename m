Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487AbZBQOV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbZBQOV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 09:21:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbZBQOVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 09:21:47 -0500
Received: from smtp-out.google.com ([216.239.45.13]:24106 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbZBQOVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 09:21:46 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:in-reply-to:organization:
	user-agent:x-system-of-record;
	b=iqZsacNhGTqno6Zhg5ow/HgOlCbJUTmAJaJSiNY93OGNCrUVH+4FVgntyZiIJLOFN
	VQHElIf4QJbbHHkbSIZlg==
Date: Tue, 17 Feb 2009 06:20:01 -0800
From: Brian Swetland <swetland@google.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Arjan van de Ven <arjan@infradead.org>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090217142001.GB12378@bulgaria.corp.google.com>
References: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com> <13B9B4C6EF24D648824FF11BE896716203771DD01B@dlee02.ent.ti.com> <20090216145948.6fea81c3@infradead.org> <200902170019.40599.rjw@sisk.pl> <20090216232329.GA15678@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216232329.GA15678@srcf.ucam.org>
Organization: Google, Inc.
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Matthew Garrett <mjg59@srcf.ucam.org>]
> On Tue, Feb 17, 2009 at 12:19:38AM +0100, Rafael J. Wysocki wrote:
> 
> > This, again, seems to be a bit x86-centric. :-)  The Android people are telling
> > us that on the hardware they deal with it does make sense to put the entire
> > system to sleep even for relatively short periods of time, since the latencies
> > involved are not too bad.
> 
> Arve said that the power state was equivalent in idle and suspend, but 
> that they preferred suspend because it stopped any periodic timers. I'd 
> be more interested in making sure that unnecessary timers aren't running 
> than focusing on automatically entering system-wide suspend - Nokia have 
> been managing this since 2005 with good results.

We'd totally agree that doing something about periodic timers would be a
big win.  There's also the situation that the longest ARM linux can sit
in idle right now is ~2s at a time (Arve can expand on the exact issue
relating to a 32bit signed nanosecond value somewhere iirc), which we'd
want to sort out as well.

Of course that still doesn't address userspace.  Aggressively going to
suspend lets us compensate for userspace programs that do somewhat silly
things (I agree that it would be best if they didn't but they do and
getting *everyone* to write their userspace code to avoid spinning or
avoid waking up on short-duration timers to poll is a losing battle).

Brian

