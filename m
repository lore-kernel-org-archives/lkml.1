Return-Path: <linux-kernel-owner+w=401wt.eu-S1752092AbYHLGA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbYHLGA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 02:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbYHLGAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 02:00:49 -0400
Received: from smtp114.mail.mud.yahoo.com ([209.191.84.67]:30452 "HELO
	smtp114.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750878AbYHLGAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 02:00:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=3L8gspbx5wkxBo+mGxfk3i3G0iX+GKKTp8R0/FoMK5sQ+E5JIszzXSyQTXvS/GGOQYahmft+/TqSsfcBACqDP2w8+l/HdaCXJbT8GJVacg3D6DUMDdtMEUFQuoHU4ca31emkR7VnGmlTmFMdvwZ7l1aeMXIy6G2La41y4g7C2K8=  ;
X-YMail-OSG: eTr8xsUVM1nqJTtMhtkSK8wGocf8aXXwvlbv_KkhJyPMs3WU6ZnLrkYwk7mLYfi7yXY4LCBsPX9LH6tX0ovvWpu5eTLPaAe4tRexipump.d1YqEj2Sc4ZQr3AqFtGiGxPiU-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Ryan Hope" <rmh3093@gmail.com>
Subject: Re: [PATCH 3/3][reiser4] dont get radix-tree dirty tagging out of sync
Date: Tue, 12 Aug 2008 16:00:40 +1000
User-Agent: KMail/1.9.5
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Edward Shishkin" <edward.shishkin@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Reiserfs mailing list" <reiserfs-devel@vger.kernel.org>
References: <48A0BFC9.40502@gmail.com> <200808121236.51599.nickpiggin@yahoo.com.au> <48f7fe350808112112k5e92330epa8345cbe4eb4c1b5@mail.gmail.com>
In-Reply-To: <48f7fe350808112112k5e92330epa8345cbe4eb4c1b5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808121600.40293.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 August 2008 14:12, Ryan Hope wrote:
> I tried just using __set_page_dirty_nobuffers but that caused issues
> with ext3/ext4 (i can send a bug trace later if needed).
>
>                                 __inc_bdi_stat(mapping->backing_dev_info,
>                                                 BDI_RECLAIMABLE);
>                                 task_io_account_write(PAGE_CACHE_SIZE);
>
> ^^^ the above code in __set_page_dirty_nobuffers causes an issue with
> do_writepages in ext3/4 when I use something like the code below:
>
> int reiser4_set_page_dirty_internal(struct page *page)
> {
>      return __set_page_dirty_nobuffers(page);
> }

Hmm, it causes issues in ext3/4 even though it doesn't change any
code executed by ext3/4? Yes, if you could send a trace...
