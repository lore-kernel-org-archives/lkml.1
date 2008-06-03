Return-Path: <linux-kernel-owner+w=401wt.eu-S1756510AbYFCRa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbYFCRa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbYFCRaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:30:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:55627 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbYFCRaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:30:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [RFC 1/3] hvc_console: rework setup to replace irq functions with callbacks (not word wrapped)
Date: Tue, 3 Jun 2008 19:30:09 +0200
User-Agent: KMail/1.9.9
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>
References: <200806031444.21945.borntraeger@de.ibm.com> <200806031449.14385.borntraeger@de.ibm.com>
In-Reply-To: <200806031449.14385.borntraeger@de.ibm.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806031930.09556.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/iQEPGlECgUWOmmYBtt0AexHE+nDjO7oKGljM
 c16/RsdpRVzJqqgWzkByaN6ohVIZMtLdYOxnm8oofsBvj6/Xqg
 t0QmieAItgMXXrUa51I1Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 June 2008, Christian Borntraeger wrote:

> @@ -42,22 +42,48 @@
>   */
>  #define HVC_ALLOC_TTY_ADAPTERS	8
>  
> +struct hvc_struct {
> +	spinlock_t lock;
> +	int index;
> +	struct tty_struct *tty;
> +	unsigned int count;
> +	int do_wakeup;
> +	char *outbuf;
> +	int outbuf_size;
> +	int n_outbuf;
> +	uint32_t vtermno;
> +	struct hv_ops *ops;
> +	int data;
> +	struct list_head next;
> +	struct kref kref; /* ref count & hvc_struct lifetime */
> +};
>  

I don't see a reason to make this data structure known to other files,
so why not leave it in hvc_console.c?


> +
> +#ifdef CONFIG_HVC_IRQ
> +/* default notifier for irq based notification */
> +extern int notifier_add_irq(struct hvc_struct *hp, int irq);
> +extern void notifier_del_irq(struct hvc_struct *hp, int irq);
> +#endif
>  #endif // HVC_CONSOLE_H

Please remove the #ifdef around the declarations.

h	Arnd <><
