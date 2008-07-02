Return-Path: <linux-kernel-owner+w=401wt.eu-S1764154AbYGBLwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764154AbYGBLwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 07:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761261AbYGBLwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 07:52:07 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:58534 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755267AbYGBLwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 07:52:06 -0400
Date: Wed, 2 Jul 2008 21:52:01 +1000
From: Bron Gondwana <brong@fastmail.fm>
To: Andi Kleen <andi@firstfloor.org>
Cc: Rob Mueller <robm@fastmail.fm>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Bron Gondwana <brong@fastmail.fm>, Philippe De Muyter <phdm@macqel.be>,
       linux-kernel@vger.kernel.org
Subject: Re: mmap'ed memory in core files ?
Message-ID: <20080702115201.GA12974@brong.net>
References: <20080701132149.GA32510@frolo.macqel> <517f3f820807011116g6ce1b3e1qf166070f7a4c523f@mail.gmail.com> <20080701214423.GA29875@brong.net> <cfd18e0f0807012214o78353faal84a5fa764d3210bf@mail.gmail.com> <3f2201c8dc0d$d1012d60$0b01a8c0@robmhp> <87vdzosfx1.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vdzosfx1.fsf@basil.nowhere.org>
Organization: brong.net
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 01:07:22PM +0200, Andi Kleen wrote:
> "Rob Mueller" <robm@fastmail.fm> writes:
> >
> > It's clearly sparse, but slightly unintuitive that the ulimit doesn't
> > actually limit the filesize, just the size of the data written to the
> > file.
> 
> It's the only sane semantic. Imagine ulimit would limit the address
> range as you seem to be asking for. This means if you set e.g. ulimit
> -c 1G then the kernel would never dump any address (mmap or not) above
> 1GB. Never dumping the process stack for example. Clearly doesn't make
> any sense. And mmap'ed files are not different from any other 
> mappings in this regard.

Hmm.. the IO hit we got with those Cyrus crashes suggested that it was
more than just a small amount of IO being caused.  I didn't check if the
files were sparse or not.

I guess we can probably create a test case that recreates it, even if it's
just running up a dodgy Cyrus instance on the machine that had the crashes
before and deliberately recreating a broken cache file to trigger it.

Bron.
