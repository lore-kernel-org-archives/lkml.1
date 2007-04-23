Return-Path: <linux-kernel-owner+w=401wt.eu-S1030782AbXDWE0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030782AbXDWE0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 00:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030787AbXDWE0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 00:26:05 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:31047 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030782AbXDWE0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 00:26:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=vbsR5hMZlPL3G7Cd8d6MR2X6WbPDlImTRHIY6LajlQfQoEc3SVnTrI1Ha5O/Iuy7nbvZPXLj3L4zXu3Eroyq9xCdWIvoO9KahpaaVeFRiJo0UkXaalbYladL8E0rlkO6xLTU25Iu97s6hdLtXhc5fvy/50pXYqBVdduFxHtnycs=  ;
X-YMail-OSG: Ds_P13AVM1mcuXGWWMjEPkn40JxwRpMnl8_LsbhSHVw8X6u3_R_paf9ekbPvPdXiVq6IYrnhLg--
Message-ID: <462C3554.5000906@yahoo.com.au>
Date: Mon, 23 Apr 2007 14:25:56 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Bhuvan Kumar MITTAL <bhuvan.mittal@st.com>
CC: "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: How to make mmap'ed kernel buffer non-cacheable
References: <008e01c7855d$7af41de0$142ec70a@dlh.st.com>
In-Reply-To: <008e01c7855d$7af41de0$142ec70a@dlh.st.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bhuvan Kumar MITTAL wrote:
> Hi Alan,
> 
> I believe that dma_alloc_coherent will mark the kernel buffer as uncached at alocation time. 
> But that is not my intention. I have mapped some user space memory to the kernel buffer and I wish to ensure that the contents of both are coherent and correctly ordered. 
> 
> In other words I wish to flush the contents of the kernel buffer to user space as soon as new data is available in my kernel buffer. How to do that? Will doing mysnc from the user space help?

msync is only for pagecache. If you modify user mapped RAM from the kernel, or wish
to read user modified RAM from the kernel, you should issue a flush_dcache_page after
and before, respectively. See Documentation/cachetlb.h.

Does that fix it? What are the details of your platform?

-- 
SUSE Labs, Novell Inc.
