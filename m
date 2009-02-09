Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbZBICw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbZBICw7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 21:52:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbZBICwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 21:52:50 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33725 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084AbZBICwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 21:52:49 -0500
Message-ID: <498F9A53.3090409@sandeen.net>
Date: Sun, 08 Feb 2009 20:52:03 -0600
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Alessandro Bono <alessandro.bono@gmail.com>
CC: Christoph Hellwig <hch@infradead.org>, linux-xfs <linux-xfs@oss.sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: XFS kernel BUG at fs/buffer.c:470! with 2.6.28.4
References: <1234011974.7435.11.camel@champagne.cantina>	<20090208222859.GA2532@infradead.org>	<1234132752.12370.0.camel@champagne.cantina>	<20090208224249.GA11931@infradead.org> <1234133120.12370.7.camel@champagne.cantina>
In-Reply-To: <1234133120.12370.7.camel@champagne.cantina>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alessandro Bono wrote:
> On Sun, 2009-02-08 at 17:42 -0500, Christoph Hellwig wrote:
>> On Sun, Feb 08, 2009 at 11:39:12PM +0100, Alessandro Bono wrote:
>>> On Sun, 2009-02-08 at 17:28 -0500, Christoph Hellwig wrote:
>>>> On Sat, Feb 07, 2009 at 02:06:13PM +0100, Alessandro Bono wrote:
>>>>> Feb  7 12:43:12 champagne kernel: [ 5828.167041] ------------[ cut
>>>>> here ]------------
>>>>> Feb  7 12:43:12 champagne kernel: [ 5828.167048] kernel BUG at
>>>>> fs/buffer.c:470!
>>>> Per
>>>> http://git.kernel.org/?p=linux/kernel/git/hpa/linux-2.6-allstable.git;a=blob;f=fs/buffer.c;h=665d446b25bc034241ef54c3c6b1d239c0ccf0f9;hb=d5b562330ec766292a3ac54ae5e0673610bd5b3d
>>>>
>>>> line 470 in fs/buffer.c of 2.6.28.4 has a comment and no actual code.
>>>>
>>>> What additional patches do you have applied?
>>>>
>>> vanilla kernel
>>> no additional patches at all
>> Well, the 2.6.28.4 clearly doesn't have a bug there.  Can you
>> attach the fs/buffer.c you built the kernel from?
>>
> 
> sure, attached

Well, that seems to not be from the kernel you were running; there is no
BUG() on line 470:

$ cat -n buffer.c | grep -8 "   470"
   462				       bdevname(bh->b_bdev, b));
   463			}
   464			set_bit(AS_EIO, &page->mapping->flags);
   465			set_buffer_write_io_error(bh);
   466			clear_buffer_uptodate(bh);
   467			SetPageError(page);
   468		}
   469	
   470		first = page_buffers(page);
   471		local_irq_save(flags);
   472		bit_spin_lock(BH_Uptodate_Lock, &first->b_state);
   473	
   474		clear_buffer_async_write(bh);
   475		unlock_buffer(bh);
   476		tmp = bh->b_this_page;
   477		while (tmp != bh) {
   478			if (buffer_async_write(tmp)) {

