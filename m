Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbYJPPpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbYJPPpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 11:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbYJPPpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 11:45:25 -0400
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:32371 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751209AbYJPPpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 11:45:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=TZr2AlKaNFnYZILX3lYPbK3xOR7Bk2V+oATD1EjAClamgfcLDWOfi7FjIXgwg0PL4Osp3Ov3MUtEOKbM2y+BJEK8tLV3A/ynE3UTkva3G2yH3BecQoXX/rxI3mCqqsPr63eQOGrbCoXPDypkXJT5QbrcFwI60dMWjRb+3Qdq6Dg=  ;
X-YMail-OSG: i2.4FhMVM1lDlWIkidCQeylyEenH1g8ag3VWtdh5q.o7yPQb8cAeEGVRe2EApIVxR9wp_KoZ60qM6iJsPGr22tIBc5hgPzKvYpsL48tqZnXBSa_oyxxOLZgKjB0LNMxmNCw-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [PATCH] gpiolib: fix oops on reading sysfs exported GPIOs
Date: Thu, 16 Oct 2008 08:43:08 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20081016144503.GA17455@oksana.dev.rtsoft.ru>
In-Reply-To: <20081016144503.GA17455@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810160843.08553.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 October 2008, Anton Vorontsov wrote:

> Oops: Kernel access of bad area, sig: 11 [#1]
> [...]
> NIP [00000000] 0x0
> LR [c0182fb0] gpio_get_value_cansleep+0x40/0x50
> Call Trace:
> [c7b79e80] [c0183f28] gpio_value_show+0x5c/0x94
> [c7b79ea0] [c01a584c] dev_attr_show+0x30/0x7c
> [c7b79eb0] [c00d6b48] fill_read_buffer+0x68/0xe0
> [c7b79ed0] [c00d6c54] sysfs_read_file+0x94/0xbc
> [c7b79ef0] [c008f24c] vfs_read+0xb4/0x16c
> [c7b79f10] [c008f580] sys_read+0x4c/0x90
> [c7b79f40] [c0013a14] ret_from_syscall+0x0/0x38

Rude.  But notice it's not unique to the sysfs path.
Trying to fix only the sysfs path allows oosping in
other cases.


> GPIO users should always issue the gpio_direction_input() call and
> check its return value prior to trying gpio_get_value().

Not true; the API explicitly allows GPIOs to be treated
as bidirectional, even when they're configured as outputs.
That's because most GPIOs *are* bidirectional.

See the better patch in my next message.
