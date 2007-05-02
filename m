Return-Path: <linux-kernel-owner+w=401wt.eu-S1767172AbXEBWxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767172AbXEBWxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 18:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767168AbXEBWxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 18:53:33 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:34250 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767172AbXEBWxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 18:53:32 -0400
Message-ID: <46391730.2080003@oracle.com>
Date: Wed, 02 May 2007 15:56:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>, jwboyer@linux.vnet.ibm.com,
       grant.likely@secretlab.ca, jketreno@linux.intel.com
Subject: Re: [PATCH] lib/hexdump
References: <20070502153556.3c995de7.randy.dunlap@oracle.com> <20070502154557.b463c9c3.akpm@linux-foundation.org>
In-Reply-To: <20070502154557.b463c9c3.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 2 May 2007 15:35:56 -0700
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Based on ace_dump_mem() from Grant Likely for the Xilinx 
>> SystemACE CompactFlash interface.
>>
>> Add hex_dumper() to lib/hexdump.c and linux/kernel.h.
>>
>> This patch adds the function 'hex_dumper' which can be used to perform a 
>> hex + ASCII dump of data to syslog, in an easily viewable format, thus
>> providing a common text hex dump format.
>>
>> It does not provide a hexdump_to_buffer() function.
>> if someone needs that, we'll have to add it.
>>
>> Example usage:
>> 	hex_dumper(KERN_DEBUG, data, length);
>>
> 
> Fair enough.  This is the sort of thing one could easily overdesign ;)

The Intel version also returned the number of bytes printed.
and they had a hexdump_to_buffer() for sysfs output.


>>  include/linux/kernel.h |    1 
>>  lib/Makefile           |    2 -
>>  lib/hexdump.c          |   51 +++++++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 53 insertions(+), 1 deletion(-)
>>
>> --- /dev/null
>> +++ linux-2.6.21-git4/lib/hexdump.c
>> @@ -0,0 +1,51 @@

>> +/**
>> + * hex_dumper - print a text hex dump to syslog for a binary blob of data
>> + * @level: kernel log level (e.g. KERN_DEBUG)
>> + * @buf: data blob to dump
>> + * @len: number of bytes in the @buf
>> + *
>> + * Given a buffer of u8 data, hex_dumper() will print a hex + ASCII dump
>> + * to the kernel log at the specified kernel log level.
>> + *
>> + * E.g.:
>> + *	hex_dumper(KERN_DEBUG, frame->data, frame->len);
>> + *
>> + * Prints the offsets of the block of memory, not addresses:
>> + * 0009ab42: 40414243 44454647 48494a4b 4c4d4e4f-@ABCDEFG HIJKLMNO
> 
> But I suspect it should be printing the addresses, for many callers.
> 
> In which case we'd need a separate arg (base_address or somesuch) so that
> callers who want to show real virtual addresses can pass in `base' and
> callers who want to display relative offsets can pass in 0.

OK, that's one way to do it.  I'll wait a bit for other comments.

> Which implies that the address will need to be printed as a 16-digit number
> on 64-bit kernels.

Yep.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
