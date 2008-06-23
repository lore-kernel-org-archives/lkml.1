Return-Path: <linux-kernel-owner+w=401wt.eu-S1761058AbYFWRnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761058AbYFWRnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 13:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbYFWRnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 13:43:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:3117 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbYFWRnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 13:43:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IdTAMh2xnEHwMMjizlXtdMiUmHNfjpBnnVnSlm+M69JiSGPaHoxGjg/A0/nmoUPAJd
         TwNRXYbg97fiBuqmchNAjFh/ZFGfO1f/uaia/lwGEIc16lpAxgVLXP/BVOhbvZPOSBNz
         RFt+49JRRwMoqw0pbJsMQpCuULjheKTXbFWbw=
Message-ID: <19f34abd0806231043x6f254ed1ye896b55eafec577f@mail.gmail.com>
Date: Mon, 23 Jun 2008 19:43:16 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "Steven Rostedt" <srostedt@redhat.com>
Subject: Re: linux-next: Tree for June 23
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <19f34abd0806231026t1c797c28td50a141b9715bf94@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080623182549.b0552851.sfr@canb.auug.org.au>
	 <19f34abd0806230323o6373015fj93a85b929545a7a8@mail.gmail.com>
	 <19f34abd0806230326i592ba39eu837d290e21431d14@mail.gmail.com>
	 <19f34abd0806230402x502eca3cna927eb8742553570@mail.gmail.com>
	 <19f34abd0806230526j77fc20e7w3d92cbe67ad4c552@mail.gmail.com>
	 <19f34abd0806231026t1c797c28td50a141b9715bf94@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 7:26 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On Mon, Jun 23, 2008 at 2:26 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>> And additionally, the next two boots hung here (but the third one was okay):
>>
>> http://www.kernel.org/pub/linux/kernel/people/vegard/kernels/20080623-next/DSCF3015.JPG
>>
>> I don't know what these issues are related too. I can try
>> debug_initcall for the hang.
>
> The last initcall to run is populate_rootfs(), however the last
> message on the screen is "debug: unmapping init memory
> f7cb0000..f7ff0000":
>
> http://www.kernel.org/pub/linux/kernel/people/vegard/kernels/20080623-next/DSCF3016.JPG
>
> In fact, it seems to me that init memory is being unmapped before all
> initcalls have finished... that would seem disastrous.

Ah, scratch that. Digging a bit deeper, it becomes obvious that the
initramfs/initrd code is freeing its own memory using the same
function in the end (free_init_pages()) as free_initmem(), so they'll
in fact just print the same message. That doesn't change the fact of
the hang, however...

My config can be found at:

    http://www.kernel.org/pub/linux/kernel/people/vegard/kernels/20080623-next/config


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
