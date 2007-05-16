Return-Path: <linux-kernel-owner+w=401wt.eu-S1760959AbXEPPtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959AbXEPPtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 11:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756223AbXEPPtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 11:49:12 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:45008 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755269AbXEPPtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 11:49:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=oEcmUHdU7H4rHB5WCCfCsJXiZhhKVdGZUSHzScvNaqGOvhzEjcGQtwZ7iqgwlgSVj7XX5/hxxPGQkg7rVI37Lx1WwWHa3LefuxOkNcEifYlbadvjG9FmVrlG4s2Grov3MGBqOsJmiDvKggn/aVoCjin7ReMDBqAkRfRh2muGFm4=  ;
X-YMail-OSG: 4NufXaUVM1lnc3nkaGzw2bQ.b1nEc_9fVVpZZiBiDDETmfd3epvFlupV2vR5IPk2.iZrwM_nDg--
Message-ID: <464B27F2.90806@yahoo.com.au>
Date: Thu, 17 May 2007 01:49:06 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Johann Lombardi <johann@clusterfs.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Clear PG_error before reading a page
References: <20070515143726.GC2160@chiva> <20070515101144.f7072476.akpm@linux-foundation.org> <20070515210124.GA23698@chiva> <20070515142339.4d9098f3.akpm@linux-foundation.org> <20070516153919.GC2630@chiva>
In-Reply-To: <20070516153919.GC2630@chiva>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Johann Lombardi wrote:
> On Tue, May 15, 2007 at 02:23:39PM -0700, Andrew Morton wrote:

>>If get_block() failed then we don't know what blocks to read to
>>bring this page uptodate, so the pagecache page should remain in state
>>!PageUptodate(), !PageError().  But then, we shouldn't have populated
>>pagecache at that offset at all.
> 
> 
> Yes, indeed. do_generic_mapping_read() doesn't populate the pagecache if an
> error occurred.
> Still, __do_page_cache_readahead()->read_pages()->ext3_readpages()->mpage_readpages()
> does populate the pagecache even if the page reads failed.

Doesn't really matter. If the read failed then the page is not uptodate.
If it didn't, then it isn't error.

-- 
SUSE Labs, Novell Inc.
