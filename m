Return-Path: <linux-kernel-owner+w=401wt.eu-S1752025AbZGRNuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbZGRNuF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 09:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbZGRNuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 09:50:03 -0400
Received: from THUNK.ORG ([69.25.196.29]:35034 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbZGRNuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 09:50:01 -0400
Date: Sat, 18 Jul 2009 09:49:46 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andreas Dilger <adilger@sun.com>,
       device-mapper development <dm-devel@redhat.com>,
       Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: How to handle >16TB devices on 32 bit hosts ??
Message-ID: <20090718134946.GA25546@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andi Kleen <andi@firstfloor.org>, Andreas Dilger <adilger@sun.com>,
	device-mapper development <dm-devel@redhat.com>,
	Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <19041.4714.686158.130252@notabene.brown> <20090718043155.GI4231@webber.adilger.int> <871voewm6y.fsf@basil.nowhere.org> <20090718065213.GK4231@webber.adilger.int> <20090718074811.GA2682@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090718074811.GA2682@basil.fritz.box>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 18, 2009 at 09:48:11AM +0200, Andi Kleen wrote:
> 
> > Also, for filesystems like btrfs or ZFS the checking can be done
> > online and incrementally without storing a full representation of
> > the state in memory.
> 
> You could, but I suspect it would be cheaper to just use a
> 64bit system than to rewrite fsck. 64bit is available
> for a lot of embedded setups these days too.

We don't have to rewrite fsck; most of the framework for supporting an
run-length-conding for compressed bitmaps is already in patches that
add > 32-bit block numbers to e2fsprogs; we've just been more focused
on getting 64-bit block numbers support merged than implementing
compressed bitmaps, but it's only one file that would need to be
added, and we might be able to steal the compressed bitmap support
from xfsprogs --- which does this already.

						- Ted
