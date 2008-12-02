Return-Path: <linux-kernel-owner+w=401wt.eu-S1755680AbYLBRQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbYLBRQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 12:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYLBRQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 12:16:10 -0500
Received: from mail-gx0-f18.google.com ([209.85.217.18]:38476 "EHLO
	mail-gx0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbYLBRQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 12:16:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=OZjvyL9gmhkIW4H1cL4tQkiB5ZySlYV8n+JRO8dK1DTYfpABWZ5krFkhkPKD3VnHzm
         6smDhjMOaaTw4urqI00HAGzANCrIwxnuTcKybhjRjpuJYQn8bpnNop0g45MkVR51MdBH
         JxqchFEGfMq8qZaA4XtBpwstGqAYXsDweeXok=
Message-ID: <e9c3a7c20812020916ud0b426cvd0764f23a97973ad@mail.gmail.com>
Date: Tue, 2 Dec 2008 10:16:05 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 07/13] dmaengine: introduce dma_request_channel and private channels
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       maciej.sosnowski@intel.com, hskinnemoen@atmel.com,
       nicolas.ferre@atmel.com
In-Reply-To: <Pine.LNX.4.64.0812021642120.5663@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081114213300.32354.1154.stgit@dwillia2-linux.ch.intel.com>
	 <20081114213453.32354.53002.stgit@dwillia2-linux.ch.intel.com>
	 <Pine.LNX.4.64.0812021642120.5663@axis700.grange>
X-Google-Sender-Auth: c4404daafde12e8a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2008 at 8:52 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Hi Dan,
>
> I think, there is a problem with your dma_request_channel() /
> private_candidate() implementation: your current version only tries one
> channel from a dma device list, which matched capabilities. If this
> channel is not accepted by the client, you do not try other channels from
> this device and just go to the next one...
>

Which dma driver are you using?  The dmaengine code assumes that all
channels on a device are equal.  It sounds like there are differences
between peer-channels on the device in this case.  If the driver
registers a device per channel that should give the flexibility you
want.

> Another problem I encountered with my framebuffer is the initialisation
> order. You initialise dmaengine per subsys_initcall(), whereas the only
> way to guarantee the order:
>
> dmaengine
> dma-device driver
> framebuffer
>

hmm... can the framebuffer be moved to late_initcall?

Regards,
Dan
