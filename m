Return-Path: <linux-kernel-owner+w=401wt.eu-S1764174AbXHQNDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764174AbXHQNDX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 09:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758688AbXHQNDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 09:03:16 -0400
Received: from il.qumranet.com ([82.166.9.18]:50386 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758380AbXHQNDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 09:03:15 -0400
Message-ID: <46C59C92.40902@qumranet.com>
Date: Fri, 17 Aug 2007 16:03:14 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Laurent Vivier <Laurent.Vivier@bull.net>
CC: kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [kvm-devel] [PATCH/RFC 4/4,	second shot]KVM uses "account_guest_time()"
References: <46C4719A.2060308@bull.net> <46C4720F.7030304@bull.net>		<46C4725A.4070607@bull.net> <46C4740F.2050701@bull.net>		<1187303955.6449.7.camel@localhost.localdomain>	<46C54FB8.7050504@bull.net>	<1187339450.6449.115.camel@localhost.localdomain>	<46C56774.2030009@bull.net> <46C58BD5.3090207@bull.net> <46C58C8C.3080803@bull.net>
In-Reply-To: <46C58C8C.3080803@bull.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Fri, 17 Aug 2007 16:03:14 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Vivier wrote:
> KVM updates vtime in task_struct to allow account_guest_time() to modify user,
> system and guest time in cpustat accordingly.
>   

> --- kvm.orig/drivers/kvm/Kconfig	2007-08-17 10:24:46.000000000 +0200
> +++ kvm/drivers/kvm/Kconfig	2007-08-17 10:25:25.000000000 +0200
> @@ -41,4 +41,10 @@
>  	  Provides support for KVM on AMD processors equipped with the AMD-V
>  	  (SVM) extensions.
>  
> +config GUEST_ACCOUNTING
> +	bool "Virtual Machine accounting support"
> +	depends on KVM
> +	---help---
> +	  Allows to account CPU time used by the Virtual Machines.
> +


Other way round.  In the patch that adds account_guest_time(), have a
CONFIG_GUEST_ACCOUNTING (defaulting to n, with no description, help, or
dependencies.  Then, CONFIG_KVM can select GUEST_ACCOUNTING.

The advantages of this are:
- the puppyvisor can also select this if it so wishes
- we don't have core code reference some obscure module

CONFIG_PREEMPT_NOTIFIERS does the same thing.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

