Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbYLJT6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbYLJT6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 14:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754752AbYLJT6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 14:58:12 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:53934 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbYLJT6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 14:58:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=SIDJs24bXI4I0Qf1vMvhZSWsRyNg2jFW7BBX87NYEOWHaO2pBXB8KnMJWuEOIVzXWB
         OygfBIrJD9XNdGTUOyBnzPlkGm5Ih29euQjb34XhYfemxw2Yp3BdFfHIlCf2x6FEwiRk
         B7Z4zZNOtU5ImVSz4FqWFKdvqCAgx43JNw8Wk=
Message-ID: <e9c3a7c20812101158h3de9c604i1c88bb7c412ccf02@mail.gmail.com>
Date: Wed, 10 Dec 2008 12:58:09 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 1/4 v2] dmaengine: add a tx_free method to struct dma_async_tx_descriptor
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com, "Sascha Hauer" <s.hauer@pengutronix.de>,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <Pine.LNX.4.64.0812101129340.4578@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0812101122250.4578@axis700.grange>
	 <Pine.LNX.4.64.0812101129340.4578@axis700.grange>
X-Google-Sender-Auth: 560adfdf162ca7e6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 3:36 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> From: Guennadi Liakhovetski <lg@denx.de>
>
> Some users reuse DMA transaction descriptors multiple times and need an
> explicit call to release them. An example of such a user is Video4Linux, which
> has to be able to release descriptors on ioctl(VIDIOC_DQBUF).
>
> Signed-off-by: Guennadi Liakhovetski <lg@denx.de>


Hi Guennadi,

Other dmaengine drivers have tasklets that scan the list of completed
descriptors and free the "acked" ones.  This happens in the cleanup
tasklet...
/me looks
...hmm this driver does not have a cleanup routine?  Ideally support
for ioctl(VIDIOC_DQBUF) could be achieved through this mechanism
without needing to increase the size of dma_async_tx_descriptor (which
has cache utilization impacts on other drivers).

--
Dan
