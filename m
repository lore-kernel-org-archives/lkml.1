Return-Path: <linux-kernel-owner+w=401wt.eu-S932288AbXBNDGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288AbXBNDGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 22:06:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932291AbXBNDGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 22:06:09 -0500
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:25046 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932288AbXBNDGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 22:06:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=Db+whABp/L4t3Yyh99LhUrVnGayp4nLvPF2FdXERrmphfWc8nvFkfHC6gaLDnh3xGlhjjzb6aLxraHwYum5FBJaQzmC8GvAdqbW+djdo/Fn2Le36O+zcwClLzbtvmldnDzZM03Ep0P5R+876RisGNBtUqE1IQgC+lonyvdcMDOk=  ;
X-YMail-OSG: d1DwycIVM1mllVY4KRZR5TCobXIVn1.Ut5d1ZMuzkc7Q16YCeGLWMm.PjgNt5Bn.ZSwYG3LeBJQKhe.IQrO0h_91T5nfmslXHy3adrakWFLkoebzxHadREb46xdc65YgOMHfzcwTo3G9oWutXGUNjXF7Lcxd0CGoGYpvtscujNbfvXNvAuJK
Message-ID: <45D27C88.5030605@yahoo.com.au>
Date: Wed, 14 Feb 2007 14:05:44 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Eric Van Hensbergen <ericvh@gmail.com>, linux-kernel@vger.kernel.org,
       v9fs-developer@lists.sourceforge.net
Subject: Re: [RESEND][PATCH] 9p: add write-cache support to loose cache mode
References: <11714109311262-git-send-email-ericvh@gmail.com>	<20070213161607.0ca21ea4.akpm@linux-foundation.org>	<a4e6962a0702131807n30b08dd6na2e0bbd53c6b9600@mail.gmail.com> <20070213181155.f7eebd83.akpm@linux-foundation.org>
In-Reply-To: <20070213181155.f7eebd83.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>>On Tue, 13 Feb 2007 20:07:44 -0600 "Eric Van Hensbergen" <ericvh@gmail.com> wrote:
>>On 2/13/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>>>>On Tue, 13 Feb 2007 17:55:31 -0600 Eric Van Hensbergen <ericvh@gmail.com> wrote:
>>>>+int v9fs_prepare_write(struct file *file, struct page *page,
>>>>+                    unsigned from, unsigned to)
>>>>+{
>>>>+     if (!PageUptodate(page)) {
>>>>+             if (to - from != PAGE_CACHE_SIZE) {
>>>>+                     void *kaddr = kmap_atomic(page, KM_USER0);
>>>>+                     memset(kaddr, 0, from);
>>>>+                     memset(kaddr + to, 0, PAGE_CACHE_SIZE - to);
>>>>+                     flush_dcache_page(page);
>>>>+                     kunmap_atomic(kaddr, KM_USER0);
>>>>+             }
>>>>+             SetPageUptodate(page);
>>>>+     }
>>>
>>>This will mark the page uptodate while the piece between `to' and `from' is
>>>uninitialised.  A concurrent pagefault can come in and permit a read of
>>>that uninitialised data.  Because filemap_nopage() doesn't lock the page if
>>>it is uptodate.
>>>
>>
>>Okay - I snagged this code from fs/libfs.c (simple_prepare_write) --
>>is that code also not correct, or am I just using it in the wrong
>>context?
>>
> 
> 
> libfs.c is wrong.  Nick has fixes, but they got tangled up in other stuff.

Yeah. 1/9 in that series should be applied on its own and sent upstream.

Need me to resend?

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
