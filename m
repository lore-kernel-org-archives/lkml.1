Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbXDXKNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbXDXKNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 06:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbXDXKNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 06:13:34 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:33112 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753940AbXDXKNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 06:13:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=vZmHvAmiS0+/SY3ye1WyKsnLT60HMYCcn3TB6DvyO9YBqCkKP1msg0LJicG2oGIpAmBY2PN5SazXhqEUOhQVMjufMMiUJvMuW+GlbgQu7QA/yxue1lFrPKqNsgdeXoaRg2NNjOAgKiqJtNIZvHS+HQ2B4JvuUbAbLytrqLz/jPE=  ;
X-YMail-OSG: 3OLVOzEVM1n3ZBUPUI.4DcYrEV3D85KsWIeKbFxge2cK59cHxYlkKD3tdFtNQwVkz3SVILHG0g--
Message-ID: <462DD83B.40708@yahoo.com.au>
Date: Tue, 24 Apr 2007 20:13:15 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
CC: Hugh Dickins <hugh@veritas.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: PageLRU can be non-atomic bit operation
References: <6.0.0.20.2.20070423193641.0457f700@172.19.0.2> <Pine.LNX.4.64.0704231202390.29015@blonde.wat.veritas.com> <6.0.0.20.2.20070423210926.045668d0@172.19.0.2> <Pine.LNX.4.64.0704231438280.3516@blonde.wat.veritas.com> <6.0.0.20.2.20070424100507.049670d0@172.19.0.2> <462D6FD3.2090805@yahoo.com.au> <6.0.0.20.2.20070424165007.04921fd8@172.19.0.2>
In-Reply-To: <6.0.0.20.2.20070424165007.04921fd8@172.19.0.2>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hisashi Hifumi wrote:
> 
> At 11:47 07/04/24, Nick Piggin wrote:
> 
>  >As Hugh points out, we must have atomic ops here, so changing the generic
>  >code to use the __ version is wrong. However if there is a faster way 
> that
>  >i386 can perform the atomic variant, then doing so will speed up the 
> generic
>  >code without breaking other architectures.
>  >
> 
> Do you mean writing page-flags.h specific for i386 so improving generic 
> code
> and without breaking other architectures ?

I meant improving the i386 bitops specific code.

However if there is some variant of operation that is not captured
with the current bitop API, but could provide a useful speedup of
common page flag manipulations, then you might consider extending
the bitop API and making page-flags.h use that new operation.

-- 
SUSE Labs, Novell Inc.
