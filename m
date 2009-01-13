Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbZAMWNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbZAMWNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 17:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754846AbZAMWNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 17:13:22 -0500
Received: from krynn.se.axis.com ([193.13.178.10]:51644 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825AbZAMWNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 17:13:21 -0500
Date: Tue, 13 Jan 2009 23:12:35 +0100
From: Jesper Nilsson <Jesper.Nilsson@axis.com>
To: David Miller <davem@davemloft.net>
Cc: "tj@kernel.org" <tj@kernel.org>, "gregkh@suse.de" <gregkh@suse.de>,
       "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "hinko.kocevar@cetrtapot.si" <hinko.kocevar@cetrtapot.si>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: lib/klist.c: bit 0 in pointer can't be used as flag
Message-ID: <20090113221235.GD19262@axis.com>
References: <20090113151406.GC19262@axis.com> <20090113.131030.207355839.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113.131030.207355839.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 10:10:30PM +0100, David Miller wrote:
> From: Jesper Nilsson <jesper.nilsson@axis.com>
> Date: Tue, 13 Jan 2009 16:14:06 +0100
> 
> > The commit a1ed5b0cffe4b16a93a6a3390e8cee0fbef94f86
> > (klist: don't iterate over deleted entries) introduces use of the
> > low bit in a pointer to indicate if the knode is dead or not,
> > assuming that this bit is always free.
> > 
> > This is not true for all architectures, CRIS for example may align data
> > on byte borders.
> 
> There are many other spots in the kernel where the low bits of a
> pointer are hijacked as status bits.  Lots of other things cannot
> possible be working on CRIS because of this.

It may be that we've worked around the other spots, although I haven't
seen anything like that, we might just have been lucky until now.

Can you recall another place where this trick is used?

It seems that rt_mutex uses the same trick (with the lowest 2bits)
but AFAICT that's something we don't use on CRIS.

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
