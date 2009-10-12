Return-Path: <linux-kernel-owner+w=401wt.eu-S932803AbZJLUub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803AbZJLUub (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 16:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758048AbZJLUua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 16:50:30 -0400
Received: from mailb.microsoft.com ([131.107.115.215]:58124 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758012AbZJLUua convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 16:50:30 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <gregkh@suse.de>, Hank Janssen <hjanssen@microsoft.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Tom Hanrahan" <hanrahat@microsoft.com>,
       Hashir Abdi <habdi@microsoft.com>
Subject: RE: [patch] Staging: hv: Fix vmbus load hang caused by wrong data
 packing
Thread-Topic: [patch] Staging: hv: Fix vmbus load hang caused by wrong data
 packing
Thread-Index: AcpJ/6FE0xhfIRwfRT+rZ9QOhF0ebwBi+82AAA3jUSD//7JUgIAAXx2g///RCwCAAHMwwA==
Date: Mon, 12 Oct 2009 20:44:06 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF7212DF127D@TK5EX14MBXC130.redmond.corp.microsoft.com>
References: <1FB5E1D5CA062146B38059374562DF7212DEE3EC@TK5EX14MBXC130.redmond.corp.microsoft.com>
 <20091012153013.GA2062@suse.de>
 <1FB5E1D5CA062146B38059374562DF7212DF10DD@TK5EX14MBXC130.redmond.corp.microsoft.com>
 <20091012172953.GA10557@suse.de>
 <8AFC7968D54FB448A30D8F38F259C5620E7B1C22@TK5EX14MBXC114.redmond.corp.microsoft.com>
 <20091012202214.GA9631@suse.de>
In-Reply-To: <20091012202214.GA9631@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can you figure out why?  What is the output of gcc for both ways?
There are no build errors in either ways, I think it may be a bug in gcc handing __attribute__((packed)).

> Can you show what is fixed by this change?
Before the fix:
The command "insmod hv_vmbus.ko" hangs. 
Root cause: The message data sent from Linux guest to HyperV host were not correctly packed and not recognized by HyperV host. So, the host doesn't acknowledge that the vmbus channel is set up. Then, the guest keeps on waiting for the event and hangs the insmod command.

After the fix:
The command "insmod hv_vmbus.ko" completes successfully with vmbus module loaded.

> Also note that #pragma packed is not supported by older versions of gcc,
> so I don't think that it would work at all on some compiler versions
> that are still legal to use for the kernel.  But I'm not quite sure when
> it was added, so I might be wrong.
This pragma was used in older distro, such as SLES10 (kernel 2.6.16) without any problem.

>From your newer email:
> I also note that you are packing more structures here with this patch than the code before the patch had.  Could that be the 
> issue here?  The additional structures are ones that should be packed instead?
No, the extra packed structures are not required for this bug fix. Just to make sure any future struct related to message is packed, so I put the pack() around the entire file.

Thanks,

- Haiyang
