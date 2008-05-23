Return-Path: <linux-kernel-owner+w=401wt.eu-S1756964AbYEWShe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964AbYEWShe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 14:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbYEWSh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 14:37:27 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:37938 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbYEWSh0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 14:37:26 -0400
Date: Fri, 23 May 2008 11:36:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>,
       <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Jan Altenberg <jan.altenberg@linutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 1/1] UIO: Add a write() function to enable/disable
 interrupts
Message-Id: <20080523113650.2467f2ee.randy.dunlap@oracle.com>
In-Reply-To: <20080523135557.27fe4855@bluebox.local>
References: <20080522192252.GB3226@local>
	<20080522192637.GC3226@local>
	<20080523055527.GA28963@digi.com>
	<20080523104454.4e2af6ec@bluebox.local>
	<20080523091009.GA22821@digi.com>
	<20080523120308.7bec1e1c@bluebox.local>
	<20080523105604.GA23800@digi.com>
	<20080523135557.27fe4855@bluebox.local>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008 13:55:57 +0200 Hans J. Koch wrote:

>  Documentation/DocBook/uio-howto.tmpl |   40 ++++++++++++++++++++++++++++++++++-
>  drivers/uio/uio.c                    |   26 ++++++++++++++++++++++
>  include/linux/uio_driver.h           |    2 +
>  3 files changed, 67 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.26-rc/Documentation/DocBook/uio-howto.tmpl
> ===================================================================
> --- linux-2.6.26-rc.orig/Documentation/DocBook/uio-howto.tmpl	2008-05-22 20:22:57.000000000 +0200
> +++ linux-2.6.26-rc/Documentation/DocBook/uio-howto.tmpl	2008-05-23 11:57:23.000000000 +0200
> @@ -30,6 +30,12 @@
>  
>  <revhistory>
>  	<revision>
> +	<revnumber>0.5</revnumber>
> +	<date>2008-05-22</date>
> +	<authorinitials>hjk</authorinitials>
> +	<revremark>Added description of write() function.</revremark>
> +	</revision>
> +	<revision>
>  	<revnumber>0.4</revnumber>
>  	<date>2007-11-26</date>
>  	<authorinitials>hjk</authorinitials>
> @@ -64,7 +70,7 @@
>  <?dbhtml filename="copyright.html"?>
>  <title>Copyright and License</title>
>  <para>
> -      Copyright (c) 2006 by Hans-Jürgen Koch.</para>
> +      Copyright (c) 2006-2008 by Hans-Jürgen Koch.</para>
>  <para>
>  This documentation is Free Software licensed under the terms of the
>  GPL version 2.
> @@ -189,6 +195,30 @@
>  	represents the total interrupt count. You can use this number
>  	to figure out if you missed some interrupts.
>  	</para>
> +	<para>
> +	For some hardware that has more than one interrupt source internally,
> +	but not seperate IRQ mask and status registers, there might be

	        separate

> +	situations where userspace cannot determine what the interrupt source
> +	was if the kernel handler disables them by writing to the chip's IRQ
> +	register. In such a case, the kernel has to disable the IRQ completely
> +	to leave the chip's register untouched. Now the userspace part can
> +	determine the cause of the interrupt, but it cannot re-enable
> +	interrupts. Another cornercase are chips where re-enabling interrupts

	                               is

> +	is a read-modify-write operation to a combined IRQ status/acknowledge
> +	register. This would be racy if a new interrupt occured

	                                                occurred

> +	simultaneously.
> +	</para>
> +	<para>
> +	To address these problems, UIO also implements a write() function. It
> +	is normally not used and can be ignored for hardware that has only a
> +	single interrupt source or has seperate IRQ mask and status registers.

	                               separate
["There's <a rat> in separate."]

> +	If you need it, however, a write to <filename>/dev/uioX</filename>
> +	will call the <function>irqcontrol()</function> function implemented
> +	by the driver. You have to write a 32-bit value that is usually either
> +	0 or 1 do disable or enable interrupts. If a driver does not implement

	       to

> +	<function>irqcontrol()</function>, <function>write()</function> will
> +	return with <varname>-ENOSYS</varname>.
> +	</para>

---
~Randy
