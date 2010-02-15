Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab0BOC2l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 21:28:41 -0500
Received: from gate.crashing.org ([63.228.1.57]:48160 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087Ab0BOC2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 21:28:39 -0500
Subject: Re: [PATCH -v7 0/35] tip related: not use  bootmem for x86
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <1265793639-15071-1-git-send-email-yinghai@kernel.org>
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Feb 2010 13:27:26 +1100
Message-ID: <1266200846.16346.111.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-10 at 01:20 -0800, Yinghai Lu wrote:
> 
> The reserve_early() method is list/range based and can handle vast
> amounts of not very fragmented memory - perfect for basically all the
> real bootmem purposes (which is to bootstrap the buddy).
> 
> reserve_early() allocated memory could be freed into the buddy later
> on
> as well. The main reason why bootmem is 'destroyed' during
> free-to-buddy
> is because it has excessive internal bitmaps we want to free. With a
> list/range based reserve_early() mechanism there's no such problem -
> they can linger indefinitely and there's near zero allocation
> management
> overhead. " 

Various archs use lib/lmb.c for representing physical memory and
doing early allocations. Might be something to extend ?

Cheers,
Ben.


