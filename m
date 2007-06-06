Return-Path: <linux-kernel-owner+w=401wt.eu-S934723AbXFFQH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934723AbXFFQH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 12:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbXFFQHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 12:07:20 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:46319 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208AbXFFQHS (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 12:07:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BnQdSq9WbHL4H1KvPdhWZxpO44q+KTDW6MjEsslkv+1kqZa1FUlGKQmupSSKanB411Q/cjsGosQ6xS2Olsfzy6/qKmcdyvkyp7B047znA/3UO/EhiRsS3BgWoxfTIuCSPwOTL6X3hYXNakoW7NMvHs5jotgvpSa8QnMoiq25nW8=
Message-ID: <6934efce0706060907n209fe6bcnb470101196aa9c55@mail.gmail.com>
Date: Wed, 6 Jun 2007 09:07:16 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>,
       "Jared Hulbert" <jaredeh@gmail.com>, carsteno@de.ibm.com,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       "Richard Griffiths" <res07ml0@verizon.net>,
       Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
In-Reply-To: <20070606113351.GA11701@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1179871779.24163.11.camel@localhost.localdomain>
	 <20070522154905.1d7e8a2e.akpm@linux-foundation.org>
	 <4653F264.1030807@de.ibm.com> <465BB5BA.3050900@yahoo.com.au>
	 <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com>
	 <46612D6F.6000002@yahoo.com.au> <46641472.3080802@de.ibm.com>
	 <6934efce0706060413y6e74512s19d5f468106d4b85@mail.gmail.com>
	 <20070606113351.GA11701@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/6/07, Christoph Hellwig <hch@infradead.org> wrote:
> I might be a little late in the discussion, but I somehow missed this
> before.  Please don't add this xip support to cramfs, because the
> whole point of cramfs is to be a simple _compressed_ filesystem,
> and we really don't want to add more complexity to it.

I estimate something on the order 5-10 million Linux phones use
something similar to these patches.  I wonder if there are that many
provable users of of the simple cramfs.  This is where the community
has taken cramfs.

Nevertheless, I understand your point.  I wrote AXFS in part because
the hacks required to do XIP on cramfs where ugly, hacky, and complex.
 Please review the latest patch in the thread, it's just a draft but
the changes required are not very complex now, especially in light of
the filemap_xip.c APIs being used.  It just happens not to work, yet.

>  Please
> use something like the existing ext2 xip mode instead of add support
> to romfs using the generic filemap methods.

What??  You mean like use xip_file_mmap() and implement
get_xip_page()?  Did you read my latest patch?
