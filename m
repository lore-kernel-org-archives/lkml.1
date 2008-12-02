Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbYLBR1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbYLBR1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 12:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755996AbYLBR07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 12:26:59 -0500
Received: from mail.atmel.fr ([81.80.104.162]:64406 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004AbYLBR06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 12:26:58 -0500
Message-ID: <49356FD9.5000509@atmel.com>
Date: Tue, 02 Dec 2008 18:26:49 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Dan Williams <dan.j.williams@intel.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       maciej.sosnowski@intel.com, hskinnemoen@atmel.com
Subject: Re: [PATCH 07/13] dmaengine: introduce dma_request_channel and private
 channels
References: <20081114213300.32354.1154.stgit@dwillia2-linux.ch.intel.com> <20081114213453.32354.53002.stgit@dwillia2-linux.ch.intel.com> <Pine.LNX.4.64.0812021642120.5663@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0812021642120.5663@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guennadi Liakhovetski :
> Another problem I encountered with my framebuffer is the initialisation 
> order. You initialise dmaengine per subsys_initcall(), whereas the only 
> way to guarantee the order:
> 
> dmaengine
> dma-device driver
> framebuffer
> 
> when they are all linked into the kernel was to switch dmaengine to 
> arch_initcall, put the dma driver under subsys_initcall, and the 
> framebuffer under a normal module_init / device_initcall.

I did not dig much in this but I feel also that dmaengine is initialized 
a bit late : it seems to be initialized after atmel-mci is started.
It works but it seems to me that dmaengine has to be initialized very 
early...

...my 2 cents.

Regards,
-- 
Nicolas Ferre

