Return-Path: <linux-kernel-owner+w=401wt.eu-S1752737AbYL3PQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbYL3PQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 10:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbYL3PQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 10:16:20 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:18090 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbYL3PQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 10:16:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=EwN50eQXy/3dpmZiuzzrO0WVCLrv2UBX2N6TmkFbZ0IJRmFTLEMZrXWWZFIkvH3Eep
         pI2nczjDe3IUDVvi0G0NKC2SO2Usv9Vja57IbDLQ7uhsWaGtg2ZcPPBOTkFxmjqOd2Nv
         E2nFmjPeTsW3yucfuIqOIMD3bZ9cMTMWbRvZY=
Message-ID: <2f11576a0812300716k32572abel2d38fff6153b7a0e@mail.gmail.com>
Date: Wed, 31 Dec 2008 00:16:18 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Tetsuo Handa" <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [2.6.28] NULL pointer dereference at get_stats()
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org
In-Reply-To: <200812302338.GDF34307.JOOMSFVQHFLFOt@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200812302153.ECH86976.MFLOQFJHtSOOFV@I-love.SAKURA.ne.jp>
	 <2f11576a0812300528t6ed12fccg8698d33dc778b9c3@mail.gmail.com>
	 <200812302338.GDF34307.JOOMSFVQHFLFOt@I-love.SAKURA.ne.jp>
X-Google-Sender-Auth: 6f929428f078ee84
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

>> it doesn't have any network card initialization log, but kernel
>> crashed in network driver.
>> in addition, loaded module list indicate your network card is pcnet32,
>> but pcnet32 doesn't have
>> get_stats() function. (instead, it has pcnet32_get_stats() )
>
> I think pcnet32 is unrelated.
> It seems to me that the problem is loopback device.

my ia32 box can't reproduce your problem although loopback doesn't
depend on any hardware.
I suspect vmware issue.


>
> I added "init=/bin/bash" and tried below commands.
> ----------------------------------------
> # lsmod
> Module                  Size  Used by
> mptspi                 19208  1
> mptscsih               33152  1 mptspi
> mptbase                74084  2 mptspi,mptscsih
> scsi_transport_spi     23296  1 mptspi
> sd_mod                 27416  2
> scsi_mod              138260  4 mptspi,mptscsih,scsi_transport_spi,sd_mod
> ext3                  109576  1
> jbd                    43924  1 ext3
> uhci_hcd               22800  0
> ohci_hcd               23696  0
> ehci_hcd               33036  0
