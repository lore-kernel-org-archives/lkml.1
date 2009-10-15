Return-Path: <linux-kernel-owner+w=401wt.eu-S1761809AbZJOSzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761809AbZJOSzp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 14:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761330AbZJOSzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 14:55:44 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:49824 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760826AbZJOSzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 14:55:43 -0400
Message-ID: <4AD77007.2070706@freescale.com>
Date: Thu, 15 Oct 2009 13:55:03 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090504 SeaMonkey/2.0a3
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Scott Wood <scottwood@freescale.com>, linuxppc-dev@ozlabs.org,
       brueckner@linux.vnet.ibm.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hvc_console: returning 0 from put_chars is not an error
References: <1255557226-4403-1-git-send-email-timur@freescale.com> <200910151305.47100.borntraeger@de.ibm.com> <20091015160906.GA3730@loki.buserror.net> <200910152041.26646.borntraeger@de.ibm.com>
In-Reply-To: <200910152041.26646.borntraeger@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Oct 2009 18:55:04.0405 (UTC) FILETIME=[01990050:01CA4DC9]
X-Brightmail-Tracker: AAAAAQAAAWE=
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger wrote:
> Hmmm, if we are ok with having both options, we should let the hvc backend 
> decide if it wants to drain or to discard.
> 
> If we just busy loop, it actually does not matter how we let hvc_console react 
> on 0, as long as we adopt all backends to use that interface consistent.
> 
> On the other hand, backends might want to do special magic on congestion so I 
> personally tend to let the backend loop instead of hvc_console. But I am really  
> not sure.

The reason that we're asking for this change is that I have an hvc client driver that drops characters during heavy printk() output.  hvc calls my driver, but the output buffer is still full, so the driver just returns 0.

If I add a spin-loop in the driver, then we don't need to change hvc, but now the driver is blocking during user-space print operations (via hvc_write and hvc_push).  

-- 
Timur Tabi
Linux kernel developer at Freescale
