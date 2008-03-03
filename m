Return-Path: <linux-kernel-owner+w=401wt.eu-S1761621AbYCCKab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761621AbYCCKab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 05:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754896AbYCCKaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 05:30:20 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:52423 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923AbYCCKaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 05:30:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=l1nlqIMw4MTGx/vz5+WQn7IGdL7/T2fs6ZdVUVYVU6D9vzRvFwa7OR5joK+OViu7a3Ay8Z4ofTPVUPSMG4zbasBLo0txKcvILp7cp23tiIxP4qVKQ1VV+NVKnf7re9gg10X4GnR2HDH7ETyLeQSi9MzfXQhw8PVm2WOQfSWT6Pk=
Message-ID: <86802c440803030230j2819d519v7db0a741c740c1cc@mail.gmail.com>
Date: Mon, 3 Mar 2008 02:30:19 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] ACPI: Unneccessary to scan the PCI bus already scanned.
Cc: "Greg KH" <gregkh@suse.de>, "Muli Ben-Yehuda" <muli@il.ibm.com>,
       "Zhao Yakui" <yakui.zhao@intel.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080303101151.GH18281@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1204525186.4080.11.camel@yakui_zhao.sh.intel.com>
	 <20080303073214.GA5934@elte.hu>
	 <86802c440803030006m1879838awc238f07bc98ed43e@mail.gmail.com>
	 <86802c440803030030p4ff9cec5tdb25d1cdc131d377@mail.gmail.com>
	 <86802c440803030201i684f31c1m97fb3f1f1927d4f4@mail.gmail.com>
	 <20080303101151.GH18281@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2008 at 2:11 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  i also had to hand-merge the x86.git#testing patch below - could you
>  double-check that it's needed in this form?
>
>         Ingo
>
>  ----------->
>  Subject: x86/acpi: make dev_to_node return online node
>  From: Yinghai Lu <Yinghai.Lu@Sun.COM>
>  Date: Wed, 20 Feb 2008 12:41:52 -0800
>
>  some numa system (with multi HT chains) may return node without ram. aka it
>  is not online. Try to get an online node, otherwise return -1
>
>  Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
>  Signed-off-by: Ingo Molnar <mingo@elte.hu>
>  ---
>   arch/x86/pci/acpi.c |    3 +++
>   1 file changed, 3 insertions(+)
>
>  Index: linux-x86.q/arch/x86/pci/acpi.c
>  ===================================================================
>  --- linux-x86.q.orig/arch/x86/pci/acpi.c
>  +++ linux-x86.q/arch/x86/pci/acpi.c
>  @@ -213,6 +213,9 @@ struct pci_bus * __devinit pci_acpi_scan
>                 set_mp_bus_to_node(busnum, node);
>         else
>                 node = get_mp_bus_to_node(busnum);
>  +
>  +       if (node != -1 && !node_online(node))
>  +               node = -1;
>   #endif

still needed...

YH
