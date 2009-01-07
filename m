Return-Path: <linux-kernel-owner+w=401wt.eu-S1762765AbZAGXhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762765AbZAGXhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 18:37:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbZAGXg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 18:36:59 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:16991 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbZAGXg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 18:36:58 -0500
Message-ID: <49653C8C.7050908@oracle.com>
Date: Wed, 07 Jan 2009 15:36:44 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-media@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for January 5 (multimedia #3)
References: <20090105173517.deeff918.sfr@canb.auug.org.au>	<20090105120927.1f044f59.randy.dunlap@oracle.com>	<20090106223612.180e32f5@pedra.chehab.org>	<4964F5A3.9020101@oracle.com> <20090107212731.6bccd1a0@pedra.chehab.org>
In-Reply-To: <20090107212731.6bccd1a0@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.49653C8F.021D:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab wrote:
> On Wed, 07 Jan 2009 10:34:11 -0800
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
>> Mauro Carvalho Chehab wrote:
>>> On Mon, 5 Jan 2009 12:09:27 -0800
>>> Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>>
>>>> On Mon, 5 Jan 2009 17:35:17 +1100 Stephen Rothwell wrote:
>>>>
>>>>> Hi all,
>>>>>
>>>>> This tree will not build a powerpc ppc4xx_defconfig due to a kvm problem.
>>>>>
>>>>> Changes since 20090102:
>>>> drivers/built-in.o: In function `cx88_call_i2c_clients':
>>>> (.text+0x20af17): undefined reference to `videobuf_dvb_get_frontend'
>>>> drivers/built-in.o: In function `cx8802_probe':
>>>> cx88-mpeg.c:(.devinit.text+0x268c4): undefined reference to `videobuf_dvb_alloc_frontend'
>>>> cx88-mpeg.c:(.devinit.text+0x268ea): undefined reference to `videobuf_dvb_dealloc_frontends'
>>> This one were trickier. Patch enclosed.
>>>
>>> Cheers,
>>> Mauro
>> Hi Mauro,
>>
>> After applying this patch, now I get these build errors:
>>
>> drivers/built-in.o: In function `mpeg_release':
>> cx88-blackbird.c:(.text+0x21096d): undefined reference to `cx8802_cancel_buffers'
>> cx88-blackbird.c:(.text+0x2109a3): undefined reference to `cx8802_get_device'
>> cx88-blackbird.c:(.text+0x2109bd): undefined reference to `cx8802_get_driver'
>> drivers/built-in.o: In function `bb_buf_queue':
>> cx88-blackbird.c:(.text+0x210a06): undefined reference to `cx8802_buf_queue'
>> drivers/built-in.o: In function `bb_buf_prepare':
>> cx88-blackbird.c:(.text+0x210a25): undefined reference to `cx8802_buf_prepare'
>> drivers/built-in.o: In function `mpeg_open':
>> cx88-blackbird.c:(.text+0x210a59): undefined reference to `cx8802_get_device'
>> cx88-blackbird.c:(.text+0x210aa2): undefined reference to `cx8802_get_driver'
>> drivers/built-in.o: In function `blackbird_init':
>> cx88-blackbird.c:(.text+0x210d18): undefined reference to `cx8802_register_driver'
>> drivers/built-in.o: In function `blackbird_fini':
>> cx88-blackbird.c:(.text+0x210fbc): undefined reference to `cx8802_unregister_driver'
> 
> 
> Sorry, I sent the wrong version. The correct one is here. Btw, I've committed
> it yesterday on my linux-next tree. It is likely that it were already added upstream.

Ack, that builds cleanly.  Thanks.

> Cheers,
> Mauro.
> 
> commit 3adb75fc5c8b2b0401e51067db07992d616c7711
> Author: Mauro Carvalho Chehab <mchehab@redhat.com>
> Date:   Tue Jan 6 16:06:07 2009 -0300
> 
>     V4L/DVB (10190): cx88: Fix some Kbuild troubles
>     
>     As Randy Dunlap <randy.dunlap@oracle.com> reported, cx88 has some compilation issues:
>     
>     drivers/built-in.o: In function `cx88_call_i2c_clients':
>     (.text+0x20af17): undefined reference to `videobuf_dvb_get_frontend'
>     drivers/built-in.o: In function `cx8802_probe':
>     cx88-mpeg.c:(.devinit.text+0x268c4): undefined reference to `videobuf_dvb_alloc_frontend'
>     cx88-mpeg.c:(.devinit.text+0x268ea): undefined reference to `videobuf_dvb_dealloc_frontends'
>     
>     With those configs:
>     
>     CONFIG_VIDEO_CX88=y
>     CONFIG_VIDEO_CX88_BLACKBIRD=y
>     CONFIG_VIDEO_CX88_DVB=m
>     CONFIG_DVB_CORE=m
>     
>     After carefully examining the code, with the current code, several cx88 drivers
>     (cx8800, cx8802, cx88_dvb and cx88_blackbird) should be compiled as a module,
>     if one of them is marked as such. Just fixing Kconfig could create a very complex
>     set of rules. Also, this hides a problem with the current approach where the dvb
>     functionality weren't confined inside dvb module.
>     
>     What happens is that:
>     	- cx88-i2c (part of cx8800) has some special rules if DVB;
>     	- cx88-mpeg (cx8802 module) has also part of DVB init code;
>     	- cx88-dvb has the rest of the dvb code;
>     	- cx88-blackbird can be used with cx88-mpeg, having cx88-dvb or not.
>     
>     So, instead of doing some tricks at Kconfig and wait for a next breakage,
>     this patch moves the dvb code inside cx88-i2c and cx88-mpeg into cx88-dvb.
>     
>     Another problem is that cx8802 were being compiled, even without cx88-dvb
>     and cx88-blackbird modules.
>     
>     While on this code, let's fix also a reported problem:
>     http://www.linuxtv.org/pipermail/linux-dvb/2009-January/031225.html
>     
>     A solution for the issue were proposed here:
>     http://www.mail-archive.com/linux-media@vger.kernel.org/msg00021.html
>     
>     Thanks to Randy, Andy, Gregoire and Thomas for helping us to detect
>     and solve the issues.
>     
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>


-- 
~Randy
