Return-Path: <linux-kernel-owner+w=401wt.eu-S1757099AbZIRRIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099AbZIRRIZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 13:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756986AbZIRRIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 13:08:24 -0400
Received: from alpha.arachsys.com ([91.203.57.7]:54076 "EHLO
	alpha.arachsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756935AbZIRRIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 13:08:22 -0400
Date: Fri, 18 Sep 2009 18:07:42 +0100
From: Chris Webb <chris@arachsys.com>
To: Tejun Heo <tj@kernel.org>
Cc: Neil Brown <neilb@suse.de>, Ric Wheeler <rwheeler@redhat.com>,
       Andrei Tanas <andrei@tanas.ca>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>,
       Mark Lord <mlord@pobox.com>
Subject: Re: MD/RAID time out writing superblock
Message-ID: <20090918170742.GJ2141@arachsys.com>
References: <20090917115728.GA13854@arachsys.com>
 <4AB2596D.10809@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB2596D.10809@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Chris Webb wrote:
>
> > Would such very slow (but ultimately successful) flushes be
> > consistent with the theory of power supply issues affecting the
> > drives? It feels like the 30s timeouts on flush could be just a more
> > severe version of the 15s very slow flushes.
> 
> Probably not.  Power problems usually don't resolve themselves with
> longer timeout.  If the drive genuinely takes longer than 30s to
> flush, it would be very interesting tho.  That's something people have
> been worrying about but hasn't materialized yet.  The timeout is
> controlled by SD_TIMEOUT in drivers/scsi/sd.h.  You might want to bump
> it up to, say, 60s and see whether anything changes.

I'll add that to the list of things to check out on the test machine with a
more disposable installation on it! The 15s flushes we're seeing on
superblock barrier writes do already feel dangerously close to the 30s
hardcoded timeout to me: it's only a factor of two.

Cheers,

Chris.
