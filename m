Return-Path: <linux-kernel-owner+w=401wt.eu-S1759521AbZCMVc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521AbZCMVc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 17:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756758AbZCMVcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 17:32:16 -0400
Received: from kroah.org ([198.145.64.141]:49406 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755463AbZCMVcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 17:32:15 -0400
Date: Fri, 13 Mar 2009 14:24:28 -0700
From: Greg KH <greg@kroah.com>
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernel_thread() usage found in staging
Message-ID: <20090313212428.GA27344@kroah.com>
References: <804dabb00903130126m79272087xd2fd452e2712abac@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <804dabb00903130126m79272087xd2fd452e2712abac@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 04:26:27PM +0800, Peter Teoh wrote:
> >From Documentation/feature_removal_schedule.txt, it is well-known that
> kernel_thread() API usage is discouraged, but in staging we still
> routinely see its use.   Perhaps the original driver owner have
> overlooked this?

Yes, they probably didn't realize this and some of this code predates
the kthread code.

> ./rt2870/common/2870_rtmp_init.c:
> 	pid_number = kernel_thread(MlmeThread, pAd, CLONE_VM);
> 	pid_number = kernel_thread(RTUSBCmdThread, pAd, CLONE_VM);
> 	pid_number = kernel_thread(TimerQThread, pAd, CLONE_VM);
> 
> ./usbip/usbip_common.c:
> 	retval = kernel_thread(usbip_thread, (void *)&ud->tcp_rx, 0);
> 	retval = kernel_thread(usbip_thread, (void *)&ud->tcp_tx, 0);
> 
> ./usbip/usbip_event.c:
> 	kernel_thread(usbip_thread, (void *)eh, 0);
> 
> ./epl/ShbIpc-LinuxKernel.c:
> 	    kernel_thread(ShbIpcThreadSignalNewData, pShbInstance_p,
> 	    kernel_thread(ShbIpcThreadSignalJobReady, pShbInstance_p,
> 
> ./epl/EplSdoUdpu.c:
> 	    kernel_thread(EplSdoUdpThread, &SdoUdpInstance_g, CLONE_KERNEL);

Patches are gladly accepted to clean this up.

thanks,

greg k-h
