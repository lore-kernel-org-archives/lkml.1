Return-Path: <linux-kernel-owner+w=401wt.eu-S1760895AbYFZSDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760895AbYFZSDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760274AbYFZSDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:03:11 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:50522 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760166AbYFZSDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:03:09 -0400
Date: Thu, 26 Jun 2008 18:13:02 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Arjan van de Ven <arjan@infradead.org>
cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25.6  kernel BUG at mm/highmem.c:319!
In-Reply-To: <20080626083749.4fd0b403@infradead.org>
Message-ID: <Pine.LNX.4.64.0806261756160.32336@blonde.site>
References: <20080626145942.GA25295@redhat.com> <20080626083749.4fd0b403@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008, Arjan van de Ven wrote:
> On Thu, 26 Jun 2008 10:59:42 -0400
> Dave Jones <davej@redhat.com> wrote:
> 
> > Anyone know how this can happen ?
> > We just got a report from a user who is hitting the 
> > 
> >         BUG_ON(!PageHighMem(page));
> > 
> > in set_page_address().
> 
> we discussed this 2 or 3 weeks ago as part of the kerneloops reports...
> everyone is puzzled... it's the number 20 report right now.
> 
> http://www.kerneloops.org/search.php?search=set_page_address
> 
> it seems that fuse is a very popular module when this hits...

I'm as puzzled now as back then.  And fuse isn't in Dave's list.
But I did notice after reporting back on it, that i915 appears in all
of the reports I looked at; and Fedora does have some drm/i915
patches, which do involve kmap.

I know precious little about drm, but didn't spot anything in those
patches which was likely to cause this: they might be a good place
for Dave to start looking though.

If this user is suffering from it repeatedly, might s/he be prepared
to run a kernel with more debug in it?  Though at this moment,
I don't know what it is that I'd like to be looking for anyway -
it's always easier to come up with debug patches when you've a
hypothesis as to what's going on, which I don't have.

Hugh
