Return-Path: <linux-kernel-owner+w=401wt.eu-S1758241AbZBMKF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241AbZBMKF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 05:05:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750889AbZBMKFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 05:05:47 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:55012 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbZBMKFq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 05:05:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OMpE8cNzIaQ8R5taRh7hTLXh+4I4XeBCfdrm4CyfLXqqqloZDHAlwUoFCzcDDPtEXv
         GRnFPsMksriaiQ1XFofBnopwXc5pqCdyamaQR3NHJ9RMqHtjDXxPXbd4DB6GVut+srpu
         gE3pT0UXETxjYxaHhIAn/Hd9oAlnMABpyq2Y4=
MIME-Version: 1.0
In-Reply-To: <49954F9A.5020801@st.com>
References: <1234461073-23281-1-git-send-email-peppe.cavallaro@st.com>
	 <20090212185640.GA6111@linux-sh.org> <499544AD.3030804@st.com>
	 <84144f020902130122y471dd92em4a72de43a0cfc681@mail.gmail.com>
	 <49954F9A.5020801@st.com>
Date: Fri, 13 Feb 2009 12:05:43 +0200
X-Google-Sender-Auth: 821be69c5dffc75e
Message-ID: <84144f020902130205x4dc5886l70fe6a695ef050a4@mail.gmail.com>
Subject: Re: [PATCH] slab: fix slab flags for archs use alignment larger 
	64-bit
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-mm@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Giuseppe,

On Fri, Feb 13, 2009 at 12:46 PM, Giuseppe CAVALLARO
<peppe.cavallaro@st.com> wrote:
> 1) LOG with my patch:
> root@linux:~# cat /proc/meminfo | grep Slab
> Slab:             2612 kB
>
> 2) LOG without my patch:
> root@linux:~# cat /proc/meminfo | grep Slab
> Slab:             2504 kB

That's not too bad. I assume it's L1_CACHE_BYTES set to 32 bytes? One
big problem with your patch is that on some MIPS configurations
ARCH_KMALLOC_MINALIGN is as big as 128. So if you're going to do this,
you can't use ARCH_KMALLOC_MINALIGN directly but add a some
SLAB_MAX_DEBUG_ALIGN which can be overridden by architecture code.

One obvious question, though, is whether all this is worth the added
complexity. I mean, we've managed "just fine" without it for years.
Paul, thoughts?

                                        Pekka
