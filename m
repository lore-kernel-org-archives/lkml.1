Return-Path: <linux-kernel-owner+w=401wt.eu-S1752721AbXJUDPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbXJUDPz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 23:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbXJUDPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 23:15:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56887 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbXJUDPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 23:15:36 -0400
Date: Sun, 21 Oct 2007 01:54:18 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: torvalds@osdl.org, akpm@osdl.org, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/2] irq_flags_t: intro and core annotations
Message-ID: <20071021005418.GU8181@ftp.linux.org.uk>
References: <20071020235546.GB1825@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071020235546.GB1825@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2007 at 03:55:46AM +0400, Alexey Dobriyan wrote:
> * irq_flags_t is marked with __bitwise__ which means sparse(1) will warn
>   developer when he accidently uses wrong type or totally wrong variable.
> * irq_flags_t allows conversion to struct instead of typedef without flag day.
>   This will give compile-time breakage of buggy users later.
> * irq_flags_t allows arch maintainers to eventually switch to something
>   smaller than "unsigned long" if they want to.

> P.S.: Anyone checking for differences in sparse logs -- don't panic,
> 	just remove __bitwise__ .

Umm...  Could you make that conditional on something, so that it could
be done with e.g. -D__CHECK_IRQFLAGS__?  We could make that unconditional
closer to the end of conversion.
