Return-Path: <linux-kernel-owner+w=401wt.eu-S1751834AbXCSKLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbXCSKLg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 06:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbXCSKLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 06:11:36 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:35044 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751197AbXCSKLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 06:11:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=MfCB5uzrUYw5h16/9LliWcOPx2cKaTEsot5YZVEDQ9/JZR3Mr1qZ+6IbsG5YAGG7m4TnGSHtLiw6CIG+SOC0XSe8sTo+KY0B7W3SqprnNohoqp/g+VO6Rsnu8TC5n1xKxb/qANma2GmY/cjCFz1Cyfo7cIE+NNKakEe0OH2/VoE=  ;
X-YMail-OSG: UDvgxcAVM1ltqQH_ZQxknV1xrcZCY.gNFQXU4EAoQWwUSYI05H5PDcy9_fRfuvcPzSGBcZDK.2UIl0MdA2uSNjK4ZXr.mC4MBHMlONbozTdpdOE1lF.qLIQHDWPpP.OWzqcNpJrZq0eZr0Q-
Message-ID: <45FE61D3.90105@yahoo.com.au>
Date: Mon, 19 Mar 2007 21:11:31 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: David Chinner <dgc@sgi.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 1 of 2] block_page_mkwrite() Implementation V2
References: <20070318233008.GA32597093@melbourne.sgi.com> <20070319092222.GA1720@infradead.org>
In-Reply-To: <20070319092222.GA1720@infradead.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, Mar 19, 2007 at 10:30:08AM +1100, David Chinner wrote:
> 
>>Generic page_mkwrite functionality.
>>
>>Filesystems that make use of the VM ->page_mkwrite() callout will generally use
>>the same core code to implement it. There are several tricky truncate-related
>>issues that we need to deal with here as we cannot take the i_mutex as we
>>normally would for these paths.  These issues are not documented anywhere yet
>>so block_page_mkwrite() seems like the best place to start.
> 
> 
> This will need some updates when ->fault replaces ->page_mkwrite.
> 
> Nich, what's the plan for merging ->fault?

I've got the patches in -mm now. I hope they will get merged when the
the next window opens.

I didn't submit the ->page_mkwrite conversion yet, because I didn't
have any callers to look at. It is is slightly less trivial than for
nopage and nopfn, so having David's block_page_mkwrite is helpful.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
