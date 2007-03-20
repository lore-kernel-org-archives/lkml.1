Return-Path: <linux-kernel-owner+w=401wt.eu-S1753241AbXCTFRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbXCTFRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 01:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbXCTFRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 01:17:19 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:30804 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934019AbXCTFRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 01:17:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type;
  b=2vljdGNUbGjgUz7MG56rWT1Pbj12g5Q+D1GjtK1KhQo65q39oiLpxIoQX4XQ+MbqjTIio7RFWTgv3oMLu9deFwYUR9Wg0srww/14Hi7CsrBSPx89KD8wbrfU+ymN5tZQazDM42LXCax2IS1szWDQbbBw9PixUmbf29E9u+lb6eM=  ;
X-YMail-OSG: 70MEdygVM1l0bq8fIGjyISzlRVyt8YKwXrjkR5jvdYVSKZXANQTLRKf0jtgfV.bamvFHX9upxwW0na2xc5ejWVM6QxwV9JL0aNj7IB5_rYaT4F7NVvKD4K52aD97r5S_KEJh176slRw658W3uaZAnCiwIQ--
Message-ID: <45FF6E55.4060101@yahoo.com.au>
Date: Tue, 20 Mar 2007 16:17:09 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm snapshot broken-out-2007-03-18-02-44.tar.gz uploaded
References: <200703180946.l2I9kTVc020636@shell0.pdx.osdl.net>	<45FEE33C.1020706@googlemail.com>	<20070319140827.285dcc7f.akpm@linux-foundation.org>	<6bffcb0e0703191437i2ee706d4xaec3bc11ca7c3234@mail.gmail.com>	<20070319175852.c73406f1.akpm@linux-foundation.org>	<20070319180234.6b7826b2.akpm@linux-foundation.org>	<45FF4B59.3060107@yahoo.com.au> <20070319205645.4918d978.akpm@linux-foundation.org>
In-Reply-To: <20070319205645.4918d978.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------080206040101020305030703"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080206040101020305030703
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Andrew Morton wrote:
> On Tue, 20 Mar 2007 13:47:53 +1100 Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> 
>>Andrew Morton wrote:
>>

>>Hang on a sec... I'll try fixing the thing before you next make a
>>release.
>>
> 
> 
> Too late.  hot-fixes/ awaits thee.

Awww... well thanks very much Michal for reporting the bug, I reproduced
it easily and it turns out to be a typo.

In my testing I never had a lot of writeout going on, so most of the pages
will have been truncated in the first loop...

-- 
SUSE Labs, Novell Inc.

--------------080206040101020305030703
Content-Type: text/plain;
 name="mm-dnp-invp-race-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mm-dnp-invp-race-fix.patch"

Fix typo in do_no_page vs invalidate race fix patch.

Index: linux-2.6/mm/truncate.c
===================================================================
--- linux-2.6.orig/mm/truncate.c
+++ linux-2.6/mm/truncate.c
@@ -235,7 +235,7 @@ void truncate_inode_pages_range(struct a
 			wait_on_page_writeback(page);
 			if (page_mapped(page)) {
 				unmap_mapping_range(mapping,
-				  (loff_t)page_index<<PAGE_CACHE_SHIFT,
+				  (loff_t)page->index<<PAGE_CACHE_SHIFT,
 				  PAGE_CACHE_SIZE, 0);
 			}
 			if (page->index > next)

--------------080206040101020305030703--
Send instant messages to your online friends http://au.messenger.yahoo.com 
