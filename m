Return-Path: <linux-kernel-owner+w=401wt.eu-S1761934AbYEGPoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761934AbYEGPoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 11:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757900AbYEGPoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 11:44:08 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:6931 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755597AbYEGPoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 11:44:03 -0400
Message-ID: <fa686aa40805070844m2af3d62aw58b54b94deb02e64@mail.gmail.com>
Date: Wed, 7 May 2008 09:44:01 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Timur Tabi" <timur@freescale.com>
Subject: Re: ALSA vs. non coherent DMA
Cc: "Takashi Iwai" <tiwai@suse.de>, benh@kernel.crashing.org,
       alsa-devel@alsa-project.org,
       "linuxppc-dev list" <linuxppc-dev@ozlabs.org>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <4821BB0E.80000@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1210032508.21644.129.camel@pasglop> <s5hmyn3d7d5.wl%tiwai@suse.de>
	 <4821BB0E.80000@freescale.com>
X-Google-Sender-Auth: 44fbfffb1bddf1fe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2008 at 8:22 AM, Timur Tabi <timur@freescale.com> wrote:
> Takashi Iwai wrote:
>
>  > This is a mmap of the data record to be shared in realtime with apps.
>  > The app updates its data pointer (appl_ptr) on the mmapped buffer
>  > while the driver updates the data (e.g. DMA position, called hwptr) on
>  > the fly on the mmapped record.  Due to its real-time nature, it has to
>  > be coherent -- at least, it was a problem on ARM.
>
>  This doesn't sound like a coherency problem to me, and least not one you'd find
>  on PowerPC.  Both the driver and the application run on the host CPU, so there
>  shouldn't be any coherency problem.  My understanding is that a "non coherent"
>  platform is one where the host CPU isn't aware when a *hardware device* writes
>  directly to memory, e.g. via DMA.

IIRC, some ARMs have a different situation because the dcache is
virtually instead of physically tagged.  Therefore, the kernel mapping
may not see data that has not been flushed out of the user space
mappings.  (Someone please correct me if I'm wrong).

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
