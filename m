Return-Path: <linux-kernel-owner+w=401wt.eu-S932215AbXGTTAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215AbXGTTAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 15:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757547AbXGTTAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 15:00:39 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:32159 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751813AbXGTTAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 15:00:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=yHbd1feJTdkf8rewTovMPwDXQ2pR+viaoTDuXiYe360NSoVs/EtU3wTNCgJcfM7U41rEA1FvASeUsIf1fA9MeYGVdcxQbaaZxig33TvyJOzwxILrIsYG4Fe6LVKtAKLkZn+LhjRi5y7YUC9QVtmTU+5/Y+2WDbXdiHseqsSEm44=  ;
X-YMail-OSG: 3ft4PL4VM1kM2i5ahaT_8s.gkRPBYj84QSCWJHbsg1tXVNSx
Message-ID: <46A03A17.8090708@yahoo.com.au>
Date: Fri, 20 Jul 2007 14:29:11 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Badari Pulavarty <pbadari@us.ibm.com>, Bill Irwin <bill.irwin@oracle.com>,
       nacc@us.ibm.com, lkml <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] hugetlbfs read() support
References: <1184376214.15968.9.camel@dyn9047017100.beaverton.ibm.com>	<20070718221950.35bbdb76.akpm@linux-foundation.org>	<1184860309.18188.90.camel@dyn9047017100.beaverton.ibm.com> <20070719095850.6e09b0e8.akpm@linux-foundation.org>
In-Reply-To: <20070719095850.6e09b0e8.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 19 Jul 2007 08:51:49 -0700 Badari Pulavarty <pbadari@us.ibm.com> wrote:
> 
> 
>>>>+		}
>>>>+
>>>>+		offset += ret;
>>>>+		retval += ret;
>>>>+		len -= ret;
>>>>+		index += offset >> HPAGE_SHIFT;
>>>>+		offset &= ~HPAGE_MASK;
>>>>+
>>>>+		page_cache_release(page);
>>>>+		if (ret == nr && len)
>>>>+			continue;
>>>>+		goto out;
>>>>+	}
>>>>+out:
>>>>+	return retval;
>>>>+}
>>>
>>>This code doesn't have all the ghastly tricks which we deploy to handle
>>>concurrent truncate.
>>
>>Do I need to ? Baaahh!!  I don't want to deal with them. 
> 
> 
> Nick, can you think of any serious consequences of a read/truncate race in
> there?  I can't..

As it doesn't allow writes, then I _think_ it should be OK. If you
ever did want to add write(2) support, then you would have transient
zeroes problems.

But why not just hold i_mutex around the whole thing just to be safe?

-- 
SUSE Labs, Novell Inc.
