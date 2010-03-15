Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935743Ab0COKqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 06:46:07 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:36384 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756595Ab0COKqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 06:46:02 -0400
Date: Mon, 15 Mar 2010 16:15:55 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: KVM development list <kvm@vger.kernel.org>,
       Rik van Riel <riel@surriel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RF C/T/D] Unmapped page cache control - via boot
 parameter
Message-ID: <20100315104555.GD18054@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100315072214.GA18054@balbir.in.ibm.com>
 <4B9DE635.8030208@redhat.com>
 <20100315080726.GB18054@balbir.in.ibm.com>
 <4B9DEF81.6020802@redhat.com>
 <20100315091720.GC18054@balbir.in.ibm.com>
 <4B9DFD9C.8030608@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4B9DFD9C.8030608@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Avi Kivity <avi@redhat.com> [2010-03-15 11:27:56]:

> >>>The knobs are for
> >>>
> >>>1. Selective enablement
> >>>2. Selective control of the % of unmapped pages
> >>An alternative path is to enable KSM for page cache.  Then we have
> >>direct read-only guest access to host page cache, without any guest
> >>modifications required.  That will be pretty difficult to achieve
> >>though - will need a readonly bit in the page cache radix tree, and
> >>teach all paths to honour it.
> >>
> >Yes, it is, I've taken a quick look. I am not sure if de-duplication
> >would be the best approach, may be dropping the page in the page cache
> >might be a good first step. Data consistency would be much easier to
> >maintain that way, as long as the guest is not writing frequently to
> >that page, we don't need the page cache in the host.
> 
> Trimming the host page cache should happen automatically under
> pressure.  Since the page is cached by the guest, it won't be
> re-read, so the host page is not frequently used and then dropped.
>

Yes, agreed, but dropping is easier than tagging cache as read-only
and getting everybody to understand read-only cached pages. 

-- 
	Three Cheers,
	Balbir
