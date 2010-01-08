Return-Path: <linux-kernel-owner+w=401wt.eu-S1752494Ab0AHIz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab0AHIz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 03:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579Ab0AHIz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 03:55:26 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:62571 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab0AHIz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 03:55:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC local_t removal V2 2/3] Remove local_t type from tree.
Date: Fri, 8 Jan 2010 09:55:07 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-rc8-00053-g43eb7c4-dirty; KDE/4.3.2; x86_64; ; )
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Tejun Heo <tj@kernel.org>, Mike Frysinger <vapier.adi@gmail.com>,
       linux-kernel@vger.kernel.org
References: <20100107223524.760517016@quilx.com> <20100107223548.270401090@quilx.com>
In-Reply-To: <20100107223548.270401090@quilx.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201001080955.07231.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1++IHbMXQxWgxNIOXsQqgVOfaFf8TlJqVuiyk0
 GCN0pCP4kLnVsjPUZeTJ37CzviaMTV0pBEooxdDXlnF44iFDOk
 UbVuDOtOxWKvzh3219TWA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 January 2010 23:35:26 Christoph Lameter wrote:
> -#define local_add_return(i, l) atomic_long_add_return((i), (&(l)->a))
> +       local_irq_save(flags);
> +       switch (size) {
> +       case 1: r = (*((u8 *)ptr) += value);
> +               break;
> +       case 2: r = (*((u16 *)ptr) += value);
> +               break;
> +       case 4: r = (*((u32 *)ptr) += value);
> +               break;
> +       case 8: r = (*((u64 *)ptr) += value);
> +               break;
> +       }
> +       local_irq_restore(flags);
> +       return r;
> +}

This still misses 'volatile'.

	Arnd
