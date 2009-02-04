Return-Path: <linux-kernel-owner+w=401wt.eu-S1757789AbZBDNgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789AbZBDNgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 08:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760055AbZBDNeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 08:34:12 -0500
Received: from vena.lwn.net ([206.168.112.25]:36786 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759107AbZBDNeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 08:34:10 -0500
Date: Wed, 4 Feb 2009 06:34:07 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>,
       mpm@selenic.com, dada1@cosmosbay.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, oleg@redhat.com, viro@zeniv.linux.org.uk,
       davidel@xmailserver.org, davem@davemloft.net, linux-api@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 2/4] Convert epoll to a bitlock
Message-ID: <20090204063407.611d5436@bike.lwn.net>
In-Reply-To: <200902041820.20535.nickpiggin@yahoo.com.au>
References: <1233598811-6871-1-git-send-email-corbet@lwn.net>
	<20090203161931.4054a25e@bike.lwn.net>
	<20090204071320.GA19348@lst.de>
	<200902041820.20535.nickpiggin@yahoo.com.au>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.2; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009 18:20:18 +1100
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Wednesday 04 February 2009 18:13:20 Christoph Hellwig wrote:
> > On Tue, Feb 03, 2009 at 04:19:31PM -0700, Jonathan Corbet wrote:  
> > >  1) Use i_lock to protect accesses to f_flags.  This would enable
> > > some BKL usage to be removed, but would not fix fasync.  
> >
> > What about just turning f_ep_lock into f_lock and using it?  
> 
> Ah, yes I was going to say that too, but I confused i_lock with
> i_mutex because it sounded like Jon needed a sleeping lock here?

Sigh, obviously that's what I should do.  Sorry for being so dense.
Consider it done.

[About sleeping locks: *if* one puts a lock around ->fasync(), it needs
to be a sleeping lock.  But moving FASYNC bit handling down gets rid of
the need to do that, so f_lock would be fine.]

Thanks,

jon
