Return-Path: <linux-kernel-owner+w=401wt.eu-S1752856AbYDHHxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbYDHHxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 03:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbYDHHw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 03:52:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbYDHHw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 03:52:56 -0400
Subject: Re: [NFS] Increase size of struct fid raw buffer
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Neil Brown <neilb@suse.de>, "J. Bruce Fields" <bfields@fieldses.org>,
       Adrian Bunk <bunk@kernel.org>
In-Reply-To: <alpine.LFD.1.00.0804070850310.11277@woody.linux-foundation.org>
References: <1207561677.3635.166.camel@quoit>
	 <alpine.LFD.1.00.0804070850310.11277@woody.linux-foundation.org>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 08 Apr 2008 08:50:05 +0100
Message-Id: <1207641005.3635.238.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2008-04-07 at 08:54 -0700, Linus Torvalds wrote:
> 
> On Mon, 7 Apr 2008, Steven Whitehouse wrote:
> > 
> > GFS2 requires the NFS filehandle buffer to be larger than the
> > minimum size as per the bug report: http://lkml.org/lkml/2007/10/24/374
> > Its a pretty trivial fix for now and I've done a test which shows
> > that it works ok.
> 
> I'm not seeing the point of this.
> 
> Every single instance of "struct fid" that I saw in a quick grep was 
> created not as a "struct fid", but as some other data structure that was 
> then cast to a "struct fid *".
> 
> So the _underlying_ size of "struct fid" seems to be pretty random, and 
> totally unrelated to this declaration.
> 
> But admittedly that really was just a quick grep, and maybe I missed 
> something. But it seems like this patch doesn't really change anything, 
> just largely makes a change in a structure that is apparently used as an 
> opaque pointer.
> 
> Is there anything that actually uses "struct fid" as an _allocation_ 
> entity?
> 
> And if not, then that "_u32 raw[6]" should probably be a un-sized "_u32 
> raw[]" instead, no?
> 
> 		Linus

I'm happy with that solution, although I'd assumed that the reason this
field had a size in the first place was that the NFS people had a plan
to use the structure as an allocation entity in the future. Can an NFS
developer please confirm/deny this?

If everybody is happy with the plan, then I'll send a patch to make the
change as you suggest shortly,

Steve.


