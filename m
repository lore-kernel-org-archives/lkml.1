Return-Path: <linux-kernel-owner+w=401wt.eu-S932193AbZJANwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193AbZJANwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 09:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756320AbZJANwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 09:52:33 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:43630 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756236AbZJANwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 09:52:33 -0400
Date: Thu, 1 Oct 2009 09:47:35 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: No more bits in vm_area_struct's vm_flags.
In-Reply-To: <Pine.LNX.4.64.0910011134240.10818@sister.anvils>
Message-ID: <alpine.DEB.1.10.0910010944480.26219@gentwo.org>
References: <4AB9A0D6.1090004@crca.org.au> <20090924100518.78df6b93.kamezawa.hiroyu@jp.fujitsu.com> <4ABC80B0.5010100@crca.org.au> <20090925174009.79778649.kamezawa.hiroyu@jp.fujitsu.com> <4AC0234F.2080808@crca.org.au> <20090928120450.c2d8a4e2.kamezawa.hiroyu@jp.fujitsu.com>
 <20090928033624.GA11191@localhost> <20090928125705.6656e8c5.kamezawa.hiroyu@jp.fujitsu.com> <Pine.LNX.4.64.0909281637160.25798@sister.anvils> <a0ea21a7cfe313202e2b51510aa5435a.squirrel@webmail-b.css.fujitsu.com> <Pine.LNX.4.64.0909282134100.11529@sister.anvils>
 <20090929105735.06eea1ee.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.1.10.0909291019100.15549@gentwo.org> <Pine.LNX.4.64.0910011134240.10818@sister.anvils>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Oct 2009, Hugh Dickins wrote:

> Are we doing that?  If you have some example like, when PG_slab is set
> then PG_owner_priv_1 means such-and-such, but if not not: okay, I'm
> fine with that.

Look at how compound pages are handled in include/linux/page-flags.h

> But if you're saying something like, if PG_reclaim is set at the same
> time as PG_buddy, then they mean the page is not a buddy or under
> reclaim, but brokenbacked: then I'm a bit (or even 32 bits) worried.

Of course you need to be careful not to use two bits that can be used
indepedently.

> > VM_HUGETLB cannot grow up and down f.e. and there are
> > certainly lots of other impossible combinations that can be used to put
> > more information into the flags.
>
> Where it makes sense, where it's understandable, okay: there may be a
> few which could naturally use combinations.  But in general, no, I
> think we'd be asking for endless maintenance trouble if we change the
> meaning of some flags according to other flags.

We made the page flags stuff configurable. On 64 bit we use more flags, on
32 bit we compress the page flags a bit. Maybe do the same for vm_flags?


