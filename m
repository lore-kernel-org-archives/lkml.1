Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbYDHIU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbYDHIU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 04:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbYDHIUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 04:20:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751979AbYDHIUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 04:20:49 -0400
Date: Tue, 8 Apr 2008 01:20:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "eric miao" <eric.y.miao@gmail.com>
Cc: "linux-arm-kernel email list" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-fbdev-devel@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/4] pxafb: introduce lcd_{read,write}l() to wrap the
 __raw_{read,write}l()
Message-Id: <20080408012004.013a2572.akpm@linux-foundation.org>
In-Reply-To: <f17812d70804072103s4fa2b6d4t57abfcda9d8e0b11@mail.gmail.com>
References: <f17812d70804072103s4fa2b6d4t57abfcda9d8e0b11@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Apr 2008 12:03:16 +0800 "eric miao" <eric.y.miao@gmail.com> wrote:

> +#define lcd_readl(f, off)	__raw_readl((f)->mmio_base + (off))
> +#define lcd_writel(f, off, v)	__raw_writel((v), (f)->mmio_base + (off))

Please implement things like this in C.  Probably inlined.

Advantages:

- C looks nicer

- For some reason people are more likely to document their C than their macros

- macros can sometimes reference their argument multiple times, causing
  bugs when they are passed experssions with side-effects.

- C functions have typechecking

- C functions (whether inlined or not) count as a reference to their
  argument, and can help to avoid unused-variable warnings.


