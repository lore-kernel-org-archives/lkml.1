Return-Path: <linux-kernel-owner+w=401wt.eu-S932931AbYEUBS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931AbYEUBS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 21:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953AbYEUBSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 21:18:48 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60967 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbYEUBSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 21:18:47 -0400
Date: Wed, 21 May 2008 02:18:43 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Al Viro <viro@ftp.linux.org.uk>, mchehab@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] or51132.c: unaligned
Message-ID: <20080521011843.GH28946@ZenIV.linux.org.uk>
References: <E1JycGV-0004yJ-SP@ZenIV.linux.org.uk> <1211330472.5915.228.camel@brick> <20080521004548.GD28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0805201752230.3081@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805201752230.3081@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 05:55:38PM -0700, Linus Torvalds wrote:
> > > > +	return buf[0] | (buf[1] << 8);
> > > 
> > > return get_unaligned_le16(buf);
> > 
> > And the point of that would be?
> 
> Perhaps better code generation?

FWIW, I wonder how they really compare on misaligned and whether it would
make sense for gcc to try and generate a single load on targets that are
known to allow that...

Hell knows; I still find explicit variant more readable in this case and
AFAICS it's not a critical path...
