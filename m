Return-Path: <linux-kernel-owner+w=401wt.eu-S1752899AbYE2IBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbYE2IBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 04:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbYE2IBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 04:01:14 -0400
Received: from gw.goop.org ([64.81.55.164]:50518 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbYE2IBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 04:01:13 -0400
Message-ID: <483E62A5.7060901@goop.org>
Date: Thu, 29 May 2008 09:00:37 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 10 of 12] xen: implement save/restore
References: <patchbomb.1211550067@localhost> <9e8d06e5ae8024829836.1211550077@localhost> <20080529073150.GA19744@elte.hu>
In-Reply-To: <20080529073150.GA19744@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> This patch implements Xen save/restore and migration.
>>     
>
> -tip testing found the following build breakage:
>
>   drivers/built-in.o: In function `xen_suspend':
>   manage.c:(.text+0x4390f): undefined reference to `xen_console_resume'
>
> with this config:
>
>   http://redhat.com/~mingo/misc/config-Thu_May_29_09_23_16_CEST_2008.bad
>
> i have bisected it down to:
>
> |  commit 0e91398f2a5d4eb6b07df8115917d0d1cf3e9b58
> |  Author: Jeremy Fitzhardinge <jeremy@goop.org>
> |  Date:   Mon May 26 23:31:27 2008 +0100
> |
> |      xen: implement save/restore
>
> the problem is that drivers/xen/manage.c is built unconditionally if 
> CONFIG_XEN is enabled and makes use of xen_suspend(), but 
> drivers/char/hvc_xen.c, where the xen_suspend() method is implemented, 
> is only build if CONFIG_HVC_XEN=y as well.
>
> i have solved this by providing a NOP implementation for xen_suspend() 
> in the !CONFIG_HVC_XEN case.
>   

Thanks Ingo, looks good.

Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

    J
