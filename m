Return-Path: <linux-kernel-owner+w=401wt.eu-S1753122AbXC0DiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbXC0DiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 23:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932293AbXC0DiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 23:38:24 -0400
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:47408 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753095AbXC0DiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 23:38:23 -0400
Message-ID: <4608919C.4050007@blueyonder.co.uk>
Date: Tue, 27 Mar 2007 04:38:04 +0100
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, auxsvr@gmail.com
Subject: Re: 2.6.21-rc1 and 2.6.21-rc2 kwin dies silently
References: <45E59D64.3070202@blueyonder.co.uk> <200702281805.13822.auxsvr@gmail.com> <20070307214730.87859590.akpm@linux-foundation.org> <45EFBC73.2030005@blueyonder.co.uk> <46016EAF.6010801@blueyonder.co.uk> <20070321193420.GP752@stusta.de> <m17itabbbv.fsf@ebiederm.dsl.xmission.com> <4601DCB4.4060804@blueyonder.co.uk> <20070321184258.758a5a29.randy.dunlap@oracle.com> <20070322105908.GS752@stusta.de>
In-Reply-To: <20070322105908.GS752@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Wed, Mar 21, 2007 at 06:42:58PM -0700, Randy Dunlap wrote:
>   
>> On Thu, 22 Mar 2007 01:32:36 +0000 Sid Boyce wrote:
>>
>>     
>>> ...
>>>       
>> There's not a lot of docs out there.
>>
>> The man-page:  http://www.kernel.org/pub/software/scm/git/docs/git-bisect.html
>>
>> Linus's email doc:
>> http://www.kernel.org/pub/software/scm/git/docs/howto/isolate-bugs-with-bisect.txt
>>
>> I worked on something over last weekend, but it doesn't really add
>> much to the references above.
>> ...
>>     
>
>
> FWIW:
> My standard instructions for users who are asked to bisect are [1]:
>
>
> <--  snip  -->
>
> # install git and cogito on your computer
>
> # clone Linus' tree:
> cg-clone \ 
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>
> # start bisecting:
> cd linux-2.6
> git bisect start
> git bisect bad 86a71dbd3e81e8870d0f0e56b87875f57e58222b
> git bisect good ac98695d6c1508b724f246f38ce57fb4e3cec356
>
> # start round
> cp /path/to/.config .
> make oldconfig
> make
> # install kernel, check whether it's good or bad, then:
> git bisect [bad|good]
> # start next round
>
>
> After at about 8 reboots, you'll have found the guilty commit
> ("...  is first bad commit").
>
>
> More information on git bisecting:
>   man git-bisect
>
> <--  snip  -->
>
>
>   
>> ~Randy
>>     
>
> cu
> Adrian
>
> [1] the start and end commits and the number of reboots are variable,
>     but the rest of the text is generic
>
>   
This is what I've got so far on the first boot, I shall have to check 
the manpage for git-bisect again to see if there is anything else to be 
added, nothing enlightening seen so far - further reboots to be done.
barrabas:/usr/src/GIT/linux-2.6 # git bisect bad
Bisecting: 22 revisions left to test after this
[3fc605a2aa38899c12180ca311f1eeb61a6d867e] knfsd: allow the server to 
provide a gid list when using AUTH_UNIX authentication
rrabas:/usr/src/GIT/linux-2.6 # git bisect bad
Bisecting: 11 revisions left to test after this
[ed8b4d4d7a31923db32f4684535944d69eb43677] qconf: hide empty list items
barrabas:/usr/src/GIT/linux-2.6 #
rrabas:/usr/src/GIT/linux-2.6 # git bisect bad
Bisecting: 6 revisions left to test after this
[66e7c7230fed159e138fc1292ee662b8bbdb74d6] qconf: relocate Search Command
barrabas:/usr/src/GIT/linux-2.6 #

barrabas:/usr/src/GIT/linux-2.6 # git bisect bad
Bisecting: 3 revisions left to test after this
[895a39a084e5478121a74752a291165c4502378f] Make mkcompile_h use LANG=C 
and LC_ALL=C for $CC -v

barrabas:/usr/src/GIT/linux-2.6 # git bisect bad
Bisecting: 2 revisions left to test after this
[8c7e4498adfdb4aea5a0d056590ec18d099ba062] search a little harder for 
mkimage

barrabas:/usr/src/GIT/linux-2.6 # git bisect bad
Bisecting: 1 revisions left to test after this
[b7de8e7e3c7b79a72c20c7fd58bd65df3d146b13] ia64: fix noncoherent DMA API 
so devres builds

 # git bisect bad
b7de8e7e3c7b79a72c20c7fd58bd65df3d146b13 is first bad commit
commit b7de8e7e3c7b79a72c20c7fd58bd65df3d146b13
Author: Roland Dreier <rdreier@cisco.com>
Date:   Wed Feb 14 00:32:53 2007 -0800

    [PATCH] ia64: fix noncoherent DMA API so devres builds

    On ia64, drivers/base/dma-mapping.c doesn't build because it calls
    dma_alloc_noncoherent() and dma_free_noncoherent(), which appear to be
    terminally broken; the calls end up generating errors like

        drivers/base/dma-mapping.c: In function 'dmam_noncoherent_release':
        drivers/base/dma-mapping.c:32: error: 'struct 
ia64_machine_vector' has no member named 'platform_dma_free_coherent'

    because the multiple levels of macro expansion in 
<asm/dma-mapping.h> and
    <asm/machvec.h> end up turning a call to dma_free_noncoherent() into
    ia64_mv.platform_dma_free_coherent (instead of the intended
    ia64_mv.dma_free_coherent).

    This patch fixes this by converting dma_{alloc,free}_noncoherent() into
    inline functions that call the corresponding coherent functions, 
instead of
    trying to do this with macros.

    Signed-off-by: Roland Dreier <rolandd@cisco.com>
    Acked-by: Tony Luck <tony.luck@intel.com>
    Cc: Al Viro <viro@zeniv.linux.org.uk>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
:040000 040000 ac36019577dc1846a5655918cf9d6b2541c398cf 
ba536f54303cc9495b7839763ed1121d3a22154c M      include

barrabas:/usr/src/GIT/linux-2.6 # git bisect bad 
86a71dbd3e81e8870d0f0e56b87875f57e58222b
Bisecting: 44 revisions left to test after this
[208367eeec8d6f6fcee1a0672af2149aeee7b658] sysctl: cdrom: remove 
unnecessary insert_at_head flag

barrabas:/usr/src/GIT/linux-2.6 # git bisect good 
ac98695d6c1508b724f246f38ce57fb4e3cec356
Bisecting: 44 revisions left to test after this
[208367eeec8d6f6fcee1a0672af2149aeee7b658] sysctl: cdrom: remove 
unnecessary insert_at_head flag

Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks


