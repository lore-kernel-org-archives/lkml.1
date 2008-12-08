Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbYLHWjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbYLHWjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 17:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbYLHWjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 17:39:05 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:53389 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbYLHWjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 17:39:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=OltXl0fn8POkP8XmC3Y2yKztV3CwxY7CSr5Nrve1JM6ds+4oNiLkSzSkroBrgbRdaf
         zgb3/wLjyfXMmFW1gmeuTOe4nRIXfeAWjd4KP8fnroVigh+Ht7uERvNow77g+d5Ws8t/
         Z83lVCQcJKSGdj/Zk6/Ihin5fOYO+RE2QRQyU=
Message-ID: <e9c3a7c20812081439m8161812nca092e0ed3114e57@mail.gmail.com>
Date: Mon, 8 Dec 2008 15:39:01 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 03/13] dmaengine: up-level reference counting to the module level
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       maciej.sosnowski@intel.com, hskinnemoen@atmel.com,
       nicolas.ferre@atmel.com
In-Reply-To: <Pine.LNX.4.64.0812041959530.8851@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081114213300.32354.1154.stgit@dwillia2-linux.ch.intel.com>
	 <20081114213432.32354.2427.stgit@dwillia2-linux.ch.intel.com>
	 <Pine.LNX.4.64.0812041746400.5079@axis700.grange>
	 <e9c3a7c20812041051l44bd8086o97c12d77a116f62@mail.gmail.com>
	 <Pine.LNX.4.64.0812041959530.8851@axis700.grange>
X-Google-Sender-Auth: a6afef55ea8bfc2a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2008 at 12:28 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Ok, but why not postpone calling .device_alloc_chan_resources() until a
> channel is _found_?

dma_find_channel() is called in fast paths (atomic contexts, I/O
writeout), so we need to allocate ahead of time.
