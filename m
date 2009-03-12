Return-Path: <linux-kernel-owner+w=401wt.eu-S1755244AbZCLCMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbZCLCMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 22:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754605AbZCLCMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 22:12:19 -0400
Received: from mail.windriver.com ([147.11.1.11]:48749 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382AbZCLCMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 22:12:18 -0400
Message-ID: <49B86C6E.2040300@windriver.com>
Date: Thu, 12 Mar 2009 09:59:10 +0800
From: Harry Ciao <qingtao.cao@windriver.com>
Reply-To: qingtao.cao@windriver.com
Organization: Wind River, CDC
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Doug Thompson <norsk5@yahoo.com>
CC: linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net
Subject: Re: [v2 PATCH 7/7] EDAC: AMD8131 driver Kconfig and Makefile - errors
References: <264247.38837.qm@web50102.mail.re2.yahoo.com>
In-Reply-To: <264247.38837.qm@web50102.mail.re2.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 12 Mar 2009 02:12:04.0619 (UTC) FILETIME=[F002A5B0:01C9A2B7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Thompson 写道:
> --- On Tue, 3/10/09, Harry Ciao <qingtao.cao@windriver.com> wrote:
>
>   
>> From: Harry Ciao <qingtao.cao@windriver.com>
>> Subject: [v2 PATCH 7/7] EDAC: AMD8131 driver Kconfig and Makefile
>> To: linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net
>> Date: Tuesday, March 10, 2009, 9:25 PM
>> Introduce Kconfig and Makefile
>> options for AMD8131 EDAC driver.
>>
>> Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
>> ---
>>  drivers/edac/Kconfig  |    7 +++++++
>>  drivers/edac/Makefile |    1 +
>>  2 files changed, 8 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
>> index 46f8e77..13ccec6 100644
>> --- a/drivers/edac/Kconfig
>> +++ b/drivers/edac/Kconfig
>> @@ -181,4 +181,11 @@ config EDAC_AMD8111
>>        Support for error detection and
>> correction on the
>>        AMD8111 HyperTransport I/O Hub
>> chip.
>>  
>> +config EDAC_AMD8131
>> +    tristate "AMD8131 HyperTransport PCI-X
>> Tunnel"
>> +    depends on EDAC_MM_EDAC && PCI
>> +    help
>> +      Support for error detection and
>> correction on the
>> +      AMD8131 HyperTransport PCI-X
>> Tunnel chip.
>> +
>>  endif # EDAC
>> diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
>> index c324956..407601f 100644
>> --- a/drivers/edac/Makefile
>> +++ b/drivers/edac/Makefile
>> @@ -35,4 +35,5 @@
>> obj-$(CONFIG_EDAC_MPC85XX)   
>>     += mpc85xx_edac.o
>>  obj-$(CONFIG_EDAC_MV64X60)   
>>     += mv64x60_edac.o
>>  obj-$(CONFIG_EDAC_CELL)   
>>         += cell_edac.o
>>  obj-$(CONFIG_EDAC_AMD8111)   
>>     += amd8111_edac.o
>> +obj-$(CONFIG_EDAC_AMD8131)   
>>     += amd8131_edac.o
>>  
>> -- 
>> 1.5.6.2
>>     
>
> Andrew,
>
> I notice that the above is different from what is now in mmotm.
>
> In the patches posted, amd8111 module IS and the amd8131 modules is NOT, configured in the Makefile to be compiled.
>
> In the mmotm version NEITHER is configured to be compiled. When I do add them I get the following errors:
>
> drivers/edac/amd8111_edac.c: In function ‘amd8111_lpc_bridge_init’:
> drivers/edac/amd8111_edac.c:259: error: implicit declaration of function ‘__do_inb’
> drivers/edac/amd8111_edac.c:273: error: implicit declaration of function ‘__do_outb’
> drivers/edac/amd8111_edac.c: In function ‘amd8111_dev_probe’:
> drivers/edac/amd8111_edac.c:383: warning: passing argument 2 of ‘edac_device_alloc_ctl_info’ discards qualifiers from pointer target type
>
>
> and
>
> drivers/edac/amd8111_edac.c: In function ‘amd8111_lpc_bridge_init’:
> drivers/edac/amd8111_edac.c:259: error: implicit declaration of function ‘__do_inb’
> drivers/edac/amd8111_edac.c:273: error: implicit declaration of function ‘__do_outb’
> drivers/edac/amd8111_edac.c: In function ‘amd8111_dev_probe’:
> drivers/edac/amd8111_edac.c:383: warning: passing argument 2 of ‘edac_device_alloc_ctl_info’ discards qualifiers from pointer target type
>
>
> I assume that is why it is currently not enabled. I just didn't see it mentioned anywhere, but you are probably aware of it.
>
> doug t
>
>   
Doug,

You're right!

the __do_inb() and __do_outb() are defined in the io.h under 
arch/powerpc/, rather than that under include/linux/:
cao@cao-desktop:/work/community/linux-2.6/arch/powerpc$ grep do_inb * -r
include/asm/io.h:#define __do_inb(port)        _rec_inb(port)
include/asm/io.h:#define __do_inb(port)        
readb((PCI_IO_ADDR)_IO_BASE + port);

I stupidly changed the asm/io.h to linux/io.h when I saw following 
warnings from checkpatch.pl:
cao@cao-desktop:/work/community/linux-2.6$ scripts/checkpatch.pl 
patches/0002-EDAC-AMD8111-driver-source-file.patch
WARNING: Use #include <linux/io.h> instead of <asm/io.h>
#48: FILE: drivers/edac/amd8111_edac.c:30:
+#include <asm/io.h>

total: 0 errors, 1 warnings, 595 lines checked

patches/0002-EDAC-AMD8111-driver-source-file.patch has style problems, 
please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

I guess by including <asm/io.h> back you won't see the error of implicit 
declaration of __do_inb() any more.(On a side note, what should we do 
with the checkpatch.pl to eliminate this false-positive warning?)

The second warning about passing argument 2 for 
edac_device_alloc_ctl_info discarding qualifiers is resulted from the 
fact that now the 2nd parameter is of type of char *, whereas I am 
passing a const char *, after I remove the "const" qualifier from 
amd8111_dev_info.ctl_name, this warning can be eliminated.

I will send out new version patches for amd8111_edac.[ch], please help 
verify them again on your side, thanks!!

Best regards,

Harry





