Return-Path: <linux-kernel-owner+w=401wt.eu-S1422799AbXD3WjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422799AbXD3WjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 18:39:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422813AbXD3WjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 18:39:10 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:60905 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422799AbXD3WjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 18:39:09 -0400
Message-ID: <46366F8A.1030302@vmware.com>
Date: Mon, 30 Apr 2007 15:36:58 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 09/32] xen: xen configuration
References: <20070429172835.284784000@goop.org> <20070429172912.297678000@goop.org>
In-Reply-To: <20070429172912.297678000@goop.org>
Content-Type: multipart/mixed;
 boundary="------------060900000903010404040703"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060900000903010404040703
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Jeremy Fitzhardinge wrote:
> +config XEN
> +	bool "Enable support for Xen hypervisor"
> +	depends on PARAVIRT && !PREEMPT && !SMP
> +	default y
> +	help
> +	  This is the Linux Xen port.  Enabling this will allow the
> +	  kernel to boot in a paravirtualized environment under the
> +	  Xen hypervisor.
>
>   

Since the default assumption of paravirt is to support running on 
multiple hypervisors and backends are now defaulting to being on, make 
the same true of VMI.

Zach

--------------060900000903010404040703
Content-Type: text/x-patch;
 name="make-vmi-default-to-on.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="make-vmi-default-to-on.patch"

Since the default assumption of paravirt is to support all possible guest
backends, making VMI default to on when CONFIG_PARAVIRT is enabled.

Signed-off-by: Zachary Amsden <zach@vmware.com>

diff -r 20882b709da4 arch/i386/Kconfig
--- a/arch/i386/Kconfig	Thu Apr 26 19:58:12 2007 -0700
+++ b/arch/i386/Kconfig	Mon Apr 30 15:32:34 2007 -0700
@@ -227,6 +227,7 @@ config VMI
 config VMI
 	bool "VMI Paravirt-ops support"
 	depends on PARAVIRT
+	default y
 	help
 	  VMI provides a paravirtualized interface to the VMware ESX server
 	  (it could be used by other hypervisors in theory too, but is not

--------------060900000903010404040703--
