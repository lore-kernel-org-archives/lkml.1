Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbZCMI0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbZCMI0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 04:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbZCMI0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 04:26:31 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:33853 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbZCMI0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 04:26:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Y5dhIwVmWj3XdKtoDPnTHXluemomzeY38MgI4PGZrG9WYyoCnwjdh4L7BxDKV/yD8s
         /G5YNDVAyDtNvK0oGbOGfT2928Tz5jglMKZ4HqVJanr2DYBhaZm3BmNerwwWGPADHTDD
         SCObRQYdFD2eAF0QJD3YzeSEb2hhv8gmFTscI=
MIME-Version: 1.0
Date: Fri, 13 Mar 2009 16:26:27 +0800
Message-ID: <804dabb00903130126m79272087xd2fd452e2712abac@mail.gmail.com>
Subject: kernel_thread() usage found in staging
From: Peter Teoh <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From Documentation/feature_removal_schedule.txt, it is well-known that
kernel_thread() API usage is discouraged, but in staging we still
routinely see its use.   Perhaps the original driver owner have
overlooked this?

Thanks.

./rt2870/common/2870_rtmp_init.c:
	pid_number = kernel_thread(MlmeThread, pAd, CLONE_VM);
	pid_number = kernel_thread(RTUSBCmdThread, pAd, CLONE_VM);
	pid_number = kernel_thread(TimerQThread, pAd, CLONE_VM);

./usbip/usbip_common.c:
	retval = kernel_thread(usbip_thread, (void *)&ud->tcp_rx, 0);
	retval = kernel_thread(usbip_thread, (void *)&ud->tcp_tx, 0);

./usbip/usbip_event.c:
	kernel_thread(usbip_thread, (void *)eh, 0);

./epl/ShbIpc-LinuxKernel.c:
	    kernel_thread(ShbIpcThreadSignalNewData, pShbInstance_p,
	    kernel_thread(ShbIpcThreadSignalJobReady, pShbInstance_p,

./epl/EplSdoUdpu.c:
	    kernel_thread(EplSdoUdpThread, &SdoUdpInstance_g, CLONE_KERNEL);


-- 
Regards,
Peter Teoh
