Return-Path: <linux-kernel-owner+w=401wt.eu-S933268AbZHEB61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933268AbZHEB61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 21:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933171AbZHEB6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 21:58:25 -0400
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:41653 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933129AbZHEB6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 21:58:24 -0400
X-Greylist: delayed 1542 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Aug 2009 21:58:24 EDT
Message-ID: <4A78E13C.30309@lougher.demon.co.uk>
Date: Wed, 05 Aug 2009 02:32:44 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>, sam@ravnborg.org,
       linux@arm.linux.org.uk, alain@knaff.lu, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
Subject: Re: [PATCH 1/6] lib/decompress_*: only include <linux/slab.h> if
 STATIC is not defined
References: <20090731093107.GA29704@merkur.ravnborg.org>	<1249311501-23102-1-git-send-email-albin.tonnerre@free-electrons.com> <20090804155500.db6c88fa.akpm@linux-foundation.org> <4A78D6BD.3030003@lougher.demon.co.uk> <4A78D8DF.8070303@zytor.com>
In-Reply-To: <4A78D8DF.8070303@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On 08/04/2009 05:47 PM, Phillip Lougher wrote:
>> Andrew Morton wrote:
>>> On Mon,  3 Aug 2009 16:58:16 +0200
>>> Albin Tonnerre <albin.tonnerre@free-electrons.com> wrote:
>>>
>>>> These includes were added by 079effb6933f34b9b1b67b08bd4fd7fb672d16ef to
>>>> fix the build when using kmemtrace. However this is not necessary when
>>>> used to create a compressed kernel, and actually creates issues (brings
>>>> a lot of things unavailable in the decompression environment), so don't
>>>> include it if STATIC is defined.
>>>>
>>> The description "actually creates issues (brings a lot of things
>>> unavailable in the decompression environment)" is inadequate.  Please
>>> describe te problem this patch fixes more completely so that others
>>> (ie: me) can decide whether this patch is needed in 2.6.32, 2.6.31.
>>> 2.6.30, ...
>>>
>>> This patch conflicts heavily with
>>>
>>> http://userweb.kernel.org/~akpm/mmotm/broken-out/bzip2-lzma-remove-nasty-uncompressed-size-hack-in-pre-boot-environment.patch
>>>
>>> What should we do about that?
>>
>> What do you normally do in this situation?  I'm happy to send a revised
>> bzip2-lzma-remove-nasty-uncompressed-size-hack-in-pre-boot-environment.patch
>>
>> that would apply cleanly on-top of Alvin's patch, but, this will obviously
>> create dependencies on his patch being applied.
>>
> 
> The general principle is that if A alone creates a more functional
> environment than B alone, then B should be applied on top of A, and vice
> versa.  This is especially so if A is a stable candidate.
> 
> It *sounds* like your patch is B here, but I am not sure from the
> description.
>

Gosh, who wants to get into the my patch is better than yours
argument.  I certainly don't...

My patch series cleans up the code and fixes a number of
rough edges (which I expect to hit when I try to make Squashfs
use the new decompression code).  Albin's looks to be adding a
new set of LZO functionality.  Regarding the conflicting
patches in question, my patch removes a hack, Albin's moves
#include <slab.h> into code covered by #ifndef STATIC, so it
doesn't pull in loads of unnecessary definitions when the
file is being built in the pre-boot environment.

I personally can't decide which is A or B.

Phillip

