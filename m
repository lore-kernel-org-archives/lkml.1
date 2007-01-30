Return-Path: <linux-kernel-owner+w=401wt.eu-S1751620AbXA3TLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbXA3TLI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 14:11:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751626AbXA3TLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 14:11:08 -0500
Received: from smtp.osdl.org ([65.172.181.24]:43275 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbXA3TLF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 14:11:05 -0500
Date: Tue, 30 Jan 2007 11:10:58 -0800
From: Andrew Morton <akpm@osdl.org>
To: =?ISO-8859-1?B?RnLpZOlyaWM=?= Riss <frederic.riss@gmail.com>,
       Matt Domsch <Matt_Domsch@dell.com>
Cc: linux-kernel@vger.kernel.org, artiom.myaskouvskey@intel.com,
       bjorn.helgaas@hp.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] EFI x86: pass firmware call parameters on the stack
Message-Id: <20070130111058.db191e07.akpm@osdl.org>
In-Reply-To: <1170183678.21603.73.camel@funkylaptop>
References: <1170183678.21603.73.camel@funkylaptop>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jan 2007 20:01:18 +0100
Frédéric Riss <frederic.riss@gmail.com> wrote:

> 
> When calling into an EFI firmware, the parameters need to be passed on
> the stack. The recent change to use -mregparm=3 breaks x86 EFI support.
> This patch is needed to allow the new Intel-based Macs to suspend to ram
> when run in EFI mode (efi.get_time is called during the suspend phase).
> 
> Signed-off-by: Frederic Riss <frederic.riss@gmail.com>
> 
> ---
> 
> [As I couldn't find an official maintainer for the linux/efi.h file and
> the file header is quite old, I'm Cc:ing the last 2 commiters.]

Matt normally looks after EFI.

> This patch fixes the issue for x86, but the file is also used by IA64. I
> would have used asmlinkage to force arguments on the stack, but it has a
> special meaning on IA64, thus I used a raw regparm(0) GCC attribute.
> This attribute is documented only for x86, I hope it has no side effect
> on other archs.

hm, this sounds like a fairly serious problem.  Has this been runtime
tested on ia64 and x86_64>


