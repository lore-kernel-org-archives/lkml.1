Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbYLKAaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbYLKAaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 19:30:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYLKAah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 19:30:37 -0500
Received: from mail.gmx.net ([213.165.64.20]:46548 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752223AbYLKAah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 19:30:37 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19q4546RgVqr0RXM95JDi2M9flNgGsF6yL23ay+ju
	To0AKi9dI0CChA
Date: Thu, 11 Dec 2008 01:30:39 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Dan Williams <dan.j.williams@intel.com>
cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com, Sascha Hauer <s.hauer@pengutronix.de>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 1/4 v2] dmaengine: add a tx_free method to struct
 dma_async_tx_descriptor
In-Reply-To: <e9c3a7c20812101158h3de9c604i1c88bb7c412ccf02@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0812110011440.8273@axis700.grange>
References: <Pine.LNX.4.64.0812101122250.4578@axis700.grange> 
 <Pine.LNX.4.64.0812101129340.4578@axis700.grange>
 <e9c3a7c20812101158h3de9c604i1c88bb7c412ccf02@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On Wed, 10 Dec 2008, Dan Williams wrote:

> On Wed, Dec 10, 2008 at 3:36 AM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > From: Guennadi Liakhovetski <lg@denx.de>
> >
> > Some users reuse DMA transaction descriptors multiple times and need an
> > explicit call to release them. An example of such a user is Video4Linux, which
> > has to be able to release descriptors on ioctl(VIDIOC_DQBUF).
> >
> > Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
> 
> 
> Hi Guennadi,
> 
> Other dmaengine drivers have tasklets that scan the list of completed
> descriptors and free the "acked" ones.  This happens in the cleanup
> tasklet...
> /me looks
> ...hmm this driver does not have a cleanup routine?  Ideally support
> for ioctl(VIDIOC_DQBUF) could be achieved through this mechanism
> without needing to increase the size of dma_async_tx_descriptor (which
> has cache utilization impacts on other drivers).

You mean there are drivers, that have struct dma_async_tx_descriptor on 
stack? Can you give me an example? And you mean, that increasing the size 
of the struct by one pointer and letting users explicitly free those 
descriptors when they want is worse than introducing a tasklet that will 
have to periodically scan the list of descriptors while other hot paths 
will move elements to and from this list, look for acked elements, lock 
the list and free those elements? Periodically, because although we have 
an event when to free them - on ioctl - there is no API to trigger that 
tasklet. Or am I missing something? I can do this, it just sounds strange 
to me.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
