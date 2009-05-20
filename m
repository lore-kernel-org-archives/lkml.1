Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbZETQto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbZETQto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 12:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbZETQtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 12:49:36 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:49559 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbZETQtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 12:49:35 -0400
Message-ID: <4A14352C.5020508@oracle.com>
Date: Wed, 20 May 2009 09:51:56 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, dougthompson@xmission.com
Subject: Re: linux-next: Tree for May 20 (amd64_edac)
References: <20090520170807.b75a9d86.sfr@canb.auug.org.au> <4A142CC9.4050904@oracle.com> <20090520164112.GA29913@aftab>
In-Reply-To: <20090520164112.GA29913@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt003.oracle.com [141.146.116.12]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010203.4A14349A.0097:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> Hi,
> 
> On Wed, May 20, 2009 at 09:16:09AM -0700, Randy Dunlap wrote:
>> Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20090519:
>>>
>>> Undropped tree:
>>> 	edac-amd
>>>
>>> The edac-amd tree lost its build failure.
>>
>> When K8_NB is not enabled:
>>
>> drivers/built-in.o: In function `amd64_edac_init':
>> amd64_edac.c:(.init.text+0x254f6): undefined reference to `cache_k8_northbridges'
>> amd64_edac.c:(.init.text+0x25c38): undefined reference to `num_k8_northbridges'
> 
> ah, well, one dependency goes another one comes in :(. Thanks, will fix...
> 
>> Error with EDAC_AMD64 =y or =m.
>> Error on both i386 and on x86_64.
>>
>>
>> Comments on Kconfig for EDAC_AMD64:
>>
>> config EDAC_AMD64
>> 	tristate "AMD64 (Opteron, Athlon64) K8, F10h, F11h"
>> 	depends on EDAC_MM_EDAC && X86 && PCI
>> 	default m
>> 	help
>> 	Support for error detection and correction on the AMD 64
>> 	Families of Memory Controllers (K8, F10h and F11h)
>>
>>
>> Does this actually apply to X86_32 or should the depends be on
>> X86_64 instead of X86?
> 
> and since K8_NB depends on X86_64, this answers that question :).

Yes.

>> The default y on EDAC_MM_EDAC and default m on EDAC_AMD64 should
>> be removed.
> 
> The reasoning behind those comes from Ingo: people who enable EDAC
> should get the modules automatically on instead of going through the
> different entries in the subtree. Which sounds kind of reasonable, no?
> 
> See
> 
> http://marc.info/?l=linux-kernel&m=124173363813847
> 
> for details.

Distros don't use defaults or defconfig anyway, and having them
enabled bloats kernels.  I'm sure that Linus has also expressed
opinions about enabling options in this way, but I can't find it
just now.

-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
