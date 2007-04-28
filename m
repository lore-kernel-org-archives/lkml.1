Return-Path: <linux-kernel-owner+w=401wt.eu-S1031009AbXD1ELo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031009AbXD1ELo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 00:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031036AbXD1ELn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 00:11:43 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:34729 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1031009AbXD1ELm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 00:11:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=mKvlowbk9Nnwef8uZQ3iq8eZ7uDuY1IP0qWl/0TaJiZoH4jF1/b0qosCkLSLuWiguYu/GR4mVP5Wqm9/rg+RSEfqPQIy8/MJJQJiulhipUCj1vAHI0xdYSxmnbIzrmwuQBI/xCCmJWXDrZ9lLPM+3CStgLh75SAnwY4k5SrHiuY=  ;
X-YMail-OSG: cjhKYNUVM1nA5HhYoIkGuPEoRTwD3nX7a7wfzTpeObAtQ2OxCswsX435Eh2TmwmS4.TT4m9Eng--
Message-ID: <4632C977.1040105@yahoo.com.au>
Date: Sat, 28 Apr 2007 14:11:35 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
CC: rohitseth@google.com, Mike Stroyan <mike.stroyan@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>, "Luck, Tony" <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Fw: [PATCH] ia64: race flushing icache in do_no_page path
References: <20070425205548.fd51b301.akpm@linux-foundation.org>	 <46305A8D.2080003@yahoo.com.au> <20070426173544.GA30744@ldl.fc.hp.com>	 <4631E49C.2030501@yahoo.com.au> <1177723479.13482.371.camel@galaxy.corp.google.com> <4632AAB4.6030303@yahoo.com.au>
In-Reply-To: <4632AAB4.6030303@yahoo.com.au>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Rohit Seth wrote:

>> You mean by user space? If so, then it is user space responsibility to
>> do the appropriate operations (like flush icache in this case).
> 
> 
> No, I mean places that set PG_arch_1. flush_dcache_page. This can
> happen for mapped pages in write, splice, install_arg_page looks
> questionable, direct IO...

Oh, and also ptrace! I think I was almost fooled by that attempt to flush
the cache in copy_to_user_page.

But that also fails if you map the underlying page with multiple virtual
addresses (or processes, if the icache is not flushed on ctxsw), because
those others won't have their caches flushed, right?

-- 
SUSE Labs, Novell Inc.
