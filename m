Return-Path: <linux-kernel-owner+w=401wt.eu-S1751871AbZHETsC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871AbZHETsC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 15:48:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbZHETsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 15:48:01 -0400
Received: from mail.gmx.net ([213.165.64.20]:57588 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751246AbZHETsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 15:48:00 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX19Nk84FjyZNI1GbVgBNYr2QFvqJx/FIP6AMjYpqMo
	/C9spB6vlOtYqC
Message-ID: <4A79E1EE.9070107@gmx.de>
Date: Wed, 05 Aug 2009 21:47:58 +0200
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: Sam Ravnborg <sam@ravnborg.org>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
       parisc-linux@lists.parisc-linux.org
Subject: Re: nfs: __setup_str_nfs_root_setup causes a section type conflict
References: <200907311446.33486.elendil@planet.nl>	 <200908032121.10635.elendil@planet.nl>	 <1249328851.18161.32.camel@heimdal.trondhjem.org>	 <200908032257.51739.elendil@planet.nl>	 <1249333643.18161.36.camel@heimdal.trondhjem.org>	 <20090803215237.GA956@merkur.ravnborg.org> <1249337493.18161.52.camel@heimdal.trondhjem.org>
In-Reply-To: <1249337493.18161.52.camel@heimdal.trondhjem.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2009 12:11 AM, Trond Myklebust wrote:
> On Mon, 2009-08-03 at 23:52 +0200, Sam Ravnborg wrote:
>> On Mon, Aug 03, 2009 at 05:07:23PM -0400, Trond Myklebust wrote:
>>> On Mon, 2009-08-03 at 22:57 +0200, Frans Pop wrote:
>>>> $ make init/do_mounts.o
>>>>    CHK     include/linux/version.h
>>>>    CHK     include/linux/utsrelease.h
>>>>    SYMLINK include/asm ->  include/asm-parisc
>>>>    CALL    scripts/checksyscalls.sh
>>>>    CC      init/do_mounts.o
>>>>
>>>> while:
>>>>
>>>> $ make fs/nfs/nfsroot.o
>>>>    CHK     include/linux/version.h
>>>>    CHK     include/linux/utsrelease.h
>>>>    SYMLINK include/asm ->  include/asm-parisc
>>>>    CALL    scripts/checksyscalls.sh
>>>>    CC      fs/nfs/nfsroot.o
>>>> fs/nfs/nfsroot.c:403: error: __setup_str_nfs_root_setup causes a section type
>>>> conflict
>>> To me that looks like some kind of compiler bug.
>> unspecified behaviour is a better name for it.
>>
>> We have two variables we have forced a section on.
>> One variable is marked RO by the compiler while the other is not.
>> This results in a section type conflict because all
>> symbols needs to have the same falgs.
>>
>> We usually triggers this with powerpc builds (64 bit IIRC),
>> and now with parisc too.
>>
>> The only way to fix it is to move one of the offending
>> variables to __initdata.
>> There is two variales to consider - the compiler only
>> mention one of them.

Yes.
It seems this was already once described on the parisc mailing list:
http://article.gmane.org/gmane.linux.ports.parisc/1816

Helge


>>
>> Trying to declare the variables const etc usually has
>> no good effect.
>
> So why would it be happening in the NFSroot case, but not in
> do_mounts.c? They're both using the standard __setup() macro with a
> constant string, and an __init function argument.
>
> Futhermore, when grepping for '__initconst', it seems that the
> combination with 'static const' is the norm rather than the exception.

