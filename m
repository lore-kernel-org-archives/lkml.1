Return-Path: <linux-kernel-owner+w=401wt.eu-S1762803AbXJESBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762803AbXJESBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 14:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758236AbXJESBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 14:01:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757636AbXJESBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 14:01:33 -0400
Date: Fri, 5 Oct 2007 14:00:37 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Valdis.Kletnieks@vt.edu
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Peter Staubach <staubach@redhat.com>, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net,
       Pierre Ossman <drzeus-list@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [NFS] What's slated for inclusion in 2.6.24-rc1 from the NFS
 client git tree...
Message-Id: <20071005140037.1309a8d3.jlayton@redhat.com>
In-Reply-To: <30494.1191605410@turing-police.cc.vt.edu>
References: <1191454876.6726.32.camel@heimdal.trondhjem.org>
	<20071004085206.0a8e37b5@poseidon.drzeus.cx>
	<1191506450.6685.17.camel@heimdal.trondhjem.org>
	<30494.1191605410@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Oct 2007 13:30:10 -0400
Valdis.Kletnieks@vt.edu wrote:
>
> How does Joe Sysadmin tell if he has an affected legacy app or not?
> 
> (The obvious "try it and see what breaks" is a non-starter for many places,
> because you too easily end up in a loop of "enable it, find 4-5 show stoppers,
> turn it off, fix them, lather rinse repease".  Been there, done that, got
> the tshirt - a project I got dragged into involves a large storage array that
> appears to insist on exporting 64-bit stuff, and a large farm of clients that
> are very 64-bit unclean....)
> 

In addition to Trond's suggestion, you might be able to use "nm" or
something like it and see if there are references to non-LFS (f)stat
calls in your binaries. For instance, if you see references to stat()
(and not stat64()), then the app is probably not built with 64-bit file
offsets.

This is probably not as reliable as Trond's method, but it might be
less invasive and reasonable for a first pass when looking for these
sorts of apps...

-- 
Jeff Layton <jlayton@redhat.com>
