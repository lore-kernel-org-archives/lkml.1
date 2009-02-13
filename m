Return-Path: <linux-kernel-owner+w=401wt.eu-S1756737AbZBMKQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737AbZBMKQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 05:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbZBMKP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 05:15:58 -0500
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:58721 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750985AbZBMKP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 05:15:57 -0500
Message-ID: <4995565D.5010105@st.com>
Date: Fri, 13 Feb 2009 12:15:41 +0100
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-mm@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] slab: fix slab flags for archs use alignment larger 
 64-bit
References: <1234461073-23281-1-git-send-email-peppe.cavallaro@st.com>	 <20090212185640.GA6111@linux-sh.org> <499544AD.3030804@st.com>	 <84144f020902130122y471dd92em4a72de43a0cfc681@mail.gmail.com>	 <49954F9A.5020801@st.com> <84144f020902130205x4dc5886l70fe6a695ef050a4@mail.gmail.com>
In-Reply-To: <84144f020902130205x4dc5886l70fe6a695ef050a4@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Hi Giuseppe,
>
> On Fri, Feb 13, 2009 at 12:46 PM, Giuseppe CAVALLARO
> <peppe.cavallaro@st.com> wrote:
>   
>> 1) LOG with my patch:
>> root@linux:~# cat /proc/meminfo | grep Slab
>> Slab:             2612 kB
>>
>> 2) LOG without my patch:
>> root@linux:~# cat /proc/meminfo | grep Slab
>> Slab:             2504 kB
>>     
>
> That's not too bad. I assume it's L1_CACHE_BYTES set to 32 bytes? 
you are perfectly right.
> One big problem with your patch is that on some MIPS configurations
> ARCH_KMALLOC_MINALIGN is as big as 128.
Agree again and problem understood... thanks!
> So if you're going to do this, you can't use ARCH_KMALLOC_MINALIGN directly but add a some
> SLAB_MAX_DEBUG_ALIGN which can be overridden by architecture code.
>   
If you like, I can prepare a patch in any case.
Then we can decide if it actually adds complexity and discard it.
Otherwise we could maintain it.
> One obvious question, though, is whether all this is worth the added
> complexity. I mean, we've managed "just fine" without it for years.
> Paul, thoughts?
>
>                                         Pekka
>
>   

