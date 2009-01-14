Return-Path: <linux-kernel-owner+w=401wt.eu-S1761253AbZANLDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761253AbZANLDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 06:03:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbZANLDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 06:03:19 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:41718 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbZANLDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 06:03:19 -0500
Date: Wed, 14 Jan 2009 12:02:57 +0100
From: Jesper Nilsson <Jesper.Nilsson@axis.com>
To: David Miller <davem@davemloft.net>
Cc: "roucaries.bastien@gmail.com" <roucaries.bastien@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tj@kernel.org" <tj@kernel.org>, "gregkh@suse.de" <gregkh@suse.de>,
       "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "hinko.kocevar@cetrtapot.si" <hinko.kocevar@cetrtapot.si>
Subject: Re: lib/klist.c: bit 0 in pointer can't be used as flag
Message-ID: <20090114110257.GI19262@axis.com>
References: <20090114101908.GF19262@axis.com> <20090114.022140.169499153.davem@davemloft.net> <20090114103624.GH19262@axis.com> <20090114.024528.80563421.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114.024528.80563421.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 11:45:28AM +0100, David Miller wrote:
> From: Jesper Nilsson <Jesper.Nilsson@axis.com>
> Date: Wed, 14 Jan 2009 11:36:24 +0100
> 
> > On Wed, Jan 14, 2009 at 11:21:40AM +0100, David Miller wrote:
> > > From: Jesper Nilsson <Jesper.Nilsson@axis.com>
> > > Date: Wed, 14 Jan 2009 11:19:08 +0100
> > > > The following patch works for CRIS, and is less intrusive than
> > > > my earlier patch. If this the way to go I can resubmit a proper patch.
> > > 
> > > Out of curiosity, is there a way to get gcc to output code such
> > > that data objects are aligned more naturally?  Some option or
> > > similar?
> > 
> > There's flags for alignment of objects, but no flags for changing
> > structure layout or size, which is probably what we run into here.
> 
> Really?

A quick test using 32bit alignment didn't work, but it could be
that I've missed a place to modify cflags.

> I thought the problem is that the base object can have any odd
> alignment in the kernel image.  And this is why the problem isn't run
> into for objects allocated using dynamic allocation.

I reasoned that the struct klist is actually allocated as a part of
another struct, which due to no padding got the odd alignment.
I'll research this more fully.

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
