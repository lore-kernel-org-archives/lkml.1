Return-Path: <linux-kernel-owner+w=401wt.eu-S1766755AbXEBWj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766755AbXEBWj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 18:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767132AbXEBWj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 18:39:59 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:40349
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766755AbXEBWju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 18:39:50 -0400
Message-ID: <46392142.2030201@microgate.com>
Date: Wed, 02 May 2007 17:39:46 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] synclink_gt add compat_ioctl
References: <1178137281.10111.8.camel@amdx2.microgate.com> <200705030009.11502.arnd@arndb.de>
In-Reply-To: <200705030009.11502.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
>> +	case MGSL_IOCGPARAMS32:
>> +		rc = get_params32(info, (struct MGSL_PARAMS32 __user *)compat_ptr(arg));
>> +		break;
> 
> No need for the cast here.

OK, for some reason I remember getting a warning
error without it. I must have been mistaken.

>> +
>> +	spin_lock_irqsave(&info->lock, flags);
> 
> no need for _irqsave, just use spin_{,un}lock_irq() when you know that
> interrupts are enabled.

That makes me a little uneasy. The locking
mechanisms (and just about everything else) above the driver
seem to change frequently. This involves not just the VFS but
the tty core as well.

If you are confident this will not change, I will
switch to spin_lock(). I used spin_lock_irqsave() to be
more robust against changes to behavior outside my driver.

>> +/* provide 32 bit ioctl compatibility on 64 bit systems */
>> +struct MGSL_PARAMS32
>> +{
>> +	unsigned int	mode;
>> +	unsigned char	loopback;
>> +	unsigned short	flags;
>> +	unsigned char	encoding;
>> +	unsigned int	clock_speed;
>> +	unsigned char	addr_filter;
>> +	unsigned short	crc_type;
>> +	unsigned char	preamble_length;
>> +	unsigned char	preamble;
>> +	unsigned int	data_rate;
>> +	unsigned char	data_bits;
>> +	unsigned char	stop_bits;
>> +	unsigned char	parity;
>> +};
> 
> The definition is correct, but by convention it would be better to use
> compat_ulong_t instead of unsigned int for those fields that are an
> unsigned long in native mode.

OK

--
Paul
