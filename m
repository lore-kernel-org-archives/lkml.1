Return-Path: <linux-kernel-owner+w=401wt.eu-S1760346AbYBUCdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760346AbYBUCdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 21:33:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbYBUCdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 21:33:33 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:51228 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbYBUCdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 21:33:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=mzEUWQ6e3CKxS+mBXEjDTck+FueOAaANQehGsdPlU0nYh1rpmhendx+ocZUUOto+7aw1+/64W70zZvrbERBnruqTMG0IHbFJx+9tKtw9WcC36XWgNDIcT3zYzXeivn8w5nygwSN8qqiXGR3u8DqsMDtdfnMULlLDIFkX5wPC248=
Message-ID: <47BCE2F5.6020305@gmail.com>
Date: Thu, 21 Feb 2008 11:33:25 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mark Lord <mlord@pobox.com>, Jeff Garzik <jeff@garzik.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [ata crash] Re: Linux 2.6.25-rc1
References: <alpine.LFD.1.00.0802101603240.2920@woody.linux-foundation.org> <20080212081816.GA17820@elte.hu> <47B2BDAB.30606@gmail.com>
In-Reply-To: <47B2BDAB.30606@gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Ingo Molnar wrote:
>> On a second attempt to boot the same bzImage, another ATA related 
>> weirdness showed up:
>>
>> [    8.226144] Calling initcall 0xc09f3d8e: isapnp_init+0x0/0xf()
>> [    8.232017] Bad IO access at port 0x0 (outb(val,port))
>> [    8.232799] ------------[ cut here ]------------
>> [    8.232799] WARNING: at lib/iomap.c:44 bad_io_access+0x2f/0x34()
>> [    8.232799] Pid: 1, comm: swapper Not tainted 2.6.25-rc1 #5
>> [    8.232799]  [<c011fd63>] warn_on_slowpath+0x3c/0x4c
>> [    8.232799]  [<c0358e9d>] ? serial8250_console_write+0x0/0x14e
>> [    8.232799]  [<c01200a5>] ? __call_console_drivers+0x56/0x63
>> [    8.232799]  [<c06b7acf>] ? _spin_unlock_irqrestore+0x15/0x21
>> [    8.232799]  [<c0120556>] ? release_console_sem+0x1c1/0x1c9
>> [    8.232799]  [<c015c400>] ? print_trailer+0x6e/0xfc
>> [    8.232799]  [<c015c77f>] ? check_object+0x10b/0x181
>> [    8.232799]  [<c01209a0>] ? printk+0x15/0x17
>> [    8.232799]  [<c02cc2ce>] bad_io_access+0x2f/0x34
>> [    8.232799]  [<c02cc48a>] iowrite8+0x31/0x34
>> [    8.232799]  [<c04a1c8d>] ata_bmdma_freeze+0x1d/0x30
>> [    8.232799]  [<c04a2063>] __ata_port_freeze+0x2c/0x33
>> [    8.232799]  [<c04a224f>] ata_eh_freeze_port+0x21/0x2f
>> [    8.232799]  [<c0497fa9>] ata_host_start+0xe1/0x132
> 
> Does the following patch fix the above problem?  pata_isapnp is the
> only one which can have NULL ctl_addr and libata SFF layer wasn't
> ready for that.

Ping.

-- 
tejun
