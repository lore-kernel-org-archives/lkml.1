Return-Path: <linux-kernel-owner+w=401wt.eu-S1760860AbZD1CIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760860AbZD1CIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 22:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756325AbZD1CIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 22:08:42 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:35826 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506AbZD1CIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 22:08:42 -0400
Message-ID: <49F66523.3020103@ovro.caltech.edu>
Date: Mon, 27 Apr 2009 19:08:35 -0700
From: David Hawkins <dwh@ovro.caltech.edu>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Liu Dave-R63238 <DaveLiu@freescale.com>
CC: Tabi Timur-B04825 <timur@freescale.com>, linuxppc-dev@ozlabs.org,
       Dan Williams <dan.j.williams@intel.com>,
       Zhang Wei <wei.zhang@freescale.com>, linux-kernel@vger.kernel.org,
       Ira Snyder <iws@ovro.caltech.edu>
Subject: Re: [PATCH] fsldma: use PCI Read Multiple command
References: <20090424183517.GB23140@ovro.caltech.edu>	<D7CCA83BB0796C49BC0BB53B6AB1208928CA1D@zch01exm21.fsl.freescale.net>	<ed82fe3e0904270731g2d2519a7mc12e4152c716c0a9@mail.gmail.com>	<49F608B7.9080409@ovro.caltech.edu> <D7CCA83BB0796C49BC0BB53B6AB1208928CABC@zch01exm21.fsl.freescale.net>
In-Reply-To: <D7CCA83BB0796C49BC0BB53B6AB1208928CABC@zch01exm21.fsl.freescale.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Mon, 27 Apr 2009 19:08:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> For the DMA PCI read/line/multi-line is outbound transaction.
> So according to your experiment, the 8349 PCI controller(as master)
> attemp to streaming/combining the outbound transaction(treated as
> prefetchable space).

Yep, with the MPC8349EA configured as a PCI Target,
and operating as a Bus Master, DMA transfers between
two MPC8349EA targets to prefetchable memory on the
slave will burst at pretty much full-speed over the
PCI bus. The same goes for DMA to the host memory.
However, reading from the host is slower, as the bursts
get chopped up more than they do between two target
boards. At some point I'll get a bunch of screen
captures and put them in a document.

> IIRC, the early 8349EUM has the bit[2]-SE in the POCMRn
> register, and is removed now. Not sure if it does function.

Hey yeah, I looked in the 8349E manual, and it is defined.
I'm not sure why it would be defined there though. I can't
think of why the master would want to disable streaming
based on a bit setting; it should burst until the IOS
says its full. Anyway, the bit is gone now, so we'll
just ignore the fact it existed :)

Cheers,
Dave
