Return-Path: <linux-kernel-owner+w=401wt.eu-S1756962AbYLOVnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962AbYLOVnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 16:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757191AbYLOVnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 16:43:13 -0500
Received: from ns2.gothnet.se ([82.193.160.251]:58879 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755855AbYLOVnL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 16:43:11 -0500
X-Greylist: delayed 1006 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Dec 2008 16:43:10 EST
Message-ID: <4946CB83.2000507@tungstengraphics.com>
Date: Mon, 15 Dec 2008 22:26:27 +0100
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@shipmail.org>,
       David Airlie <airlied@linux.ie>,
       dri-devel <dri-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: BUG: via_drmclient.h is referenced but does not exist
References: <20081213193506.GA22969@uranus.ravnborg.org>	<49452CEE.1090909@shipmail.org> <20081215210227.GA14396@uranus.ravnborg.org>
In-Reply-To: <20081215210227.GA14396@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
X-BitDefender-Scanner: Mail not scanned due to license constraints
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Sam Ravnborg wrote:
> On Sun, Dec 14, 2008 at 04:57:34PM +0100, Thomas Hellström wrote:
>   
>> Hi!
>>
>> The intention is for via_drm.h to be self-containing when included both 
>> for a kernel build and for a user-space build. In this particular case, 
>> via_drmclient.h lives in the user-space clients and includes stdint.h to 
>> get access to uint32_t and friends.
>>
>> Of course, the user-space clients could
>> #include "uint32.h"
>> #include "via_drm.h"
>>
>> but shouldn't really the tools be mimicing what the compiler does in 
>> this case?
>>     
>
> The kernel headers and thus the kernel ABI is separate and ideally
> they should not depend on any other header files to provide anything.
>
> This is why __u32, __u64 etc are preferred in the kernel ABI
> and not uint32_t as used by the drm headers.
>
> We do not adhere to this as a strict rule (yet).
> But if you do:
>
> grep -l uint32_t usr/include/linux
>
> then you will only see 7 hits. Out of 368 files.
> So we are not bad in this respect.
>
> For drm the fix seems simple - just replace all of uint32_t with __u32.
> likewise for the other 32 bit and the 64 bit variants.
>   
I'm not sure that's possible, as these header files are shared with *BSD 
(and possibly Solaris).
> For the specific case where drm includes a non-existing file I suggest
> that we get this fixed in some way soon.
>   
It's a bit non-trivial, since all via drm user-space clients need to be 
fixed, but definitiely doable.
/Thomas



