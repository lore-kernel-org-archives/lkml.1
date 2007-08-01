Return-Path: <linux-kernel-owner+w=401wt.eu-S1758022AbXHAIVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022AbXHAIVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 04:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbXHAIUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 04:20:54 -0400
Received: from main.gmane.org ([80.91.229.2]:33721 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490AbXHAIUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 04:20:52 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: Fwd: request_module() fails
Date: Wed, 1 Aug 2007 09:20:23 +0100
Organization: Linux Foundation
Message-ID: <20070801092023.10655b4c@oldman.hamilton.local>
References: <a307c1910708010011l57dbee87hb0d9a725ac259966@mail.gmail.com>
	<a307c1910708010059l6c2c9df0n4ad9d0197eaba0f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 149.157.192.252
In-Reply-To: <a307c1910708010059l6c2c9df0n4ad9d0197eaba0f@mail.gmail.com>
X-Newsreader: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2007 13:29:18 +0530
"Gireesh Kumar M" <gireesh.mnair@gmail.com> wrote:

> Hi,
> 
> I'm trying to load some modules upon occurance of a GPIO interrupt.
> The ISR checks some register and then schedules a tasklet to act
> further on the interrupt.
> Inside the tasklet, I call request_module to load a driver. But, here
> it's failing. Please see the error log pasted below.
> When I tried to load the same module using modprobe and it works fine. I
> have edited modules.dep with an entry for my module.

You can't sucessfully load a module from tasklet because tasklet's run
in softirq. You need to use a work queue (or other mechanism) that runs
in process context. Loading a module will require accessing disk, and that
can only be done from process context.

Your whole scheme is pretty daft, because it will be slow and you might
as well have the module already loaded.

