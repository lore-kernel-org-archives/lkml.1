Return-Path: <linux-kernel-owner+w=401wt.eu-S932881AbZHEBC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881AbZHEBC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 21:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932354AbZHEBC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 21:02:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53021 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520AbZHEBC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 21:02:27 -0400
Message-ID: <4A78D8DF.8070303@zytor.com>
Date: Tue, 04 Aug 2009 17:57:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Phillip Lougher <phillip@lougher.demon.co.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>, sam@ravnborg.org,
       linux@arm.linux.org.uk, alain@knaff.lu, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
Subject: Re: [PATCH 1/6] lib/decompress_*: only include <linux/slab.h> if
 STATIC is not defined
References: <20090731093107.GA29704@merkur.ravnborg.org>	<1249311501-23102-1-git-send-email-albin.tonnerre@free-electrons.com> <20090804155500.db6c88fa.akpm@linux-foundation.org> <4A78D6BD.3030003@lougher.demon.co.uk>
In-Reply-To: <4A78D6BD.3030003@lougher.demon.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2009 05:47 PM, Phillip Lougher wrote:
> Andrew Morton wrote:
>> On Mon,  3 Aug 2009 16:58:16 +0200
>> Albin Tonnerre <albin.tonnerre@free-electrons.com> wrote:
>>
>>> These includes were added by 079effb6933f34b9b1b67b08bd4fd7fb672d16ef to
>>> fix the build when using kmemtrace. However this is not necessary when
>>> used to create a compressed kernel, and actually creates issues (brings
>>> a lot of things unavailable in the decompression environment), so don't
>>> include it if STATIC is defined.
>>>
>>
>> The description "actually creates issues (brings a lot of things
>> unavailable in the decompression environment)" is inadequate.  Please
>> describe te problem this patch fixes more completely so that others
>> (ie: me) can decide whether this patch is needed in 2.6.32, 2.6.31.
>> 2.6.30, ...
>>
>> This patch conflicts heavily with
>>
>> http://userweb.kernel.org/~akpm/mmotm/broken-out/bzip2-lzma-remove-nasty-uncompressed-size-hack-in-pre-boot-environment.patch
>>
>> What should we do about that?
> 
> 
> What do you normally do in this situation?  I'm happy to send a revised
> bzip2-lzma-remove-nasty-uncompressed-size-hack-in-pre-boot-environment.patch
> 
> that would apply cleanly on-top of Alvin's patch, but, this will obviously
> create dependencies on his patch being applied.
> 

The general principle is that if A alone creates a more functional
environment than B alone, then B should be applied on top of A, and vice
versa.  This is especially so if A is a stable candidate.

It *sounds* like your patch is B here, but I am not sure from the
description.

	-hpa
