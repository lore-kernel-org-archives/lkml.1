Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbYLKElS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbYLKElS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 23:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754414AbYLKElD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 23:41:03 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:57390 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753023AbYLKElB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 23:41:01 -0500
Subject: Re: VMI not initializing in certain configurations
From: Zachary Amsden <zach@vmware.com>
To: Daniel Drake <dsd@gentoo.org>
Cc: "gentoo@thebacks.co.uk" <gentoo@thebacks.co.uk>,
       "kernel@gentoo.org" <kernel@gentoo.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       "Dyks, Axel (XL)" <xl@xlsigned.net>
In-Reply-To: <494051A1.6090906@gentoo.org>
References: <494051A1.6090906@gentoo.org>
Content-Type: text/plain
Date: Wed, 10 Dec 2008 21:34:53 -0800
Message-Id: <1228973693.8766.49.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-10 at 15:32 -0800, Daniel Drake wrote:
> Hi Zach,
> 
> Thanks for your help on the VMI-related 2.6.27.x regression. I'm hoping
> to now pick your mind on a similar but unrelated issue:
> 
> Norman has found that with certain kernel configurations, 2.6.27 (plain,
> as released by Linus) does not initialize VMI properly, witnessed as
> missing initialization messages in the kernel logs. Other configurations
> work fine. These are the messages that go missing:
> 
>     VMI: Found VMware, Inc. Hypervisor OPROM, API version 3.0, ROM 
> version 1.0
>     vmi: registering clock event vmi-timer. mult=12582912 shift=22
>     Booting paravirtualized kernel on vmi
> 
> Do you have any immediate ideas as to what the responsible config 
> option(s) might be? It may well be a configuration error, but if that's 
> the case then perhaps we could produce a CONFIG_VMI documentation patch 
> for that.

Make sure you do a clean compile for each build - ideally use
KBUILD_OUTPUT=/some/dir and keep the kernel tree completely clean at all
times.

It doesn't look like a configuration error.  Both configurations share
this:

CONFIG_PARAVIRT_GUEST=y
# CONFIG_XEN is not set
CONFIG_XEN_SAVE_RESTORE=y
CONFIG_VMI=y
# CONFIG_KVM_CLOCK is not set
# CONFIG_KVM_GUEST is not set
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_CLOCK is not set
CONFIG_PARAVIRT_DEBUG=y

Which should be fine.  However, when upgrading kernels, you should always sanitize your .config - just run make menuconfig, save and exit, and it will fix any deselected options.
Could be this .config isn't valid under 2.6.27.

