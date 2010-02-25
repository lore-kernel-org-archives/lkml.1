Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934222Ab0BYWLw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 17:11:52 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:39164 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934167Ab0BYWLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 17:11:51 -0500
Message-ID: <4B86F564.9000105@oracle.com>
Date: Thu, 25 Feb 2010 14:10:44 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
       Peter Osterlund <petero2@telia.com>, Jens Axboe <jens.axboe@oracle.com>,
       Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH -next] pktcdvd: improve BKL and compat_ioctl.c usage
References: <20100225183523.80361261.sfr@canb.auug.org.au> <4B86B97D.6030208@oracle.com> <201002252227.11472.arnd@arndb.de>
In-Reply-To: <201002252227.11472.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4B86F59D.00C0:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/10 13:27, Arnd Bergmann wrote:
> The pktcdvd driver uses proper locking and does not need the
> BKL in the ioctl and llseek functions of the character device,
> so kill both. Moving the compat_ioctl handling from common code
> into the driver itself fixes build problems when CONFIG_BLOCK is
> disabled.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> ---
> On Thursday 25 February 2010, Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> fs/compat_ioctl.c should omit pktcdvd.h and its ioctl when CONFIG_BLOCK
>> is not enabled.  This fixes these build errors:
>>
>> In file included from fs/compat_ioctl.c:105:
>> include/linux/pktcdvd.h:166: error: field 'read_queue' has incomplete type
>> include/linux/pktcdvd.h:167: error: field 'write_queue' has incomplete type
>> include/linux/pktcdvd.h:207: error: field 'orig_bios' has incomplete type
>> make[2]: *** [fs/compat_ioctl.o] Error 1
> 
> How about this one instead, cleaning pktcdvd ioctl handling up for good?

OK, that works too.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


thanks,
-- 
~Randy
