Return-Path: <linux-kernel-owner+w=401wt.eu-S1759184AbYFYQWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759184AbYFYQWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 12:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbYFYQWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 12:22:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:46202 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbYFYQWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 12:22:25 -0400
Date: Wed, 25 Jun 2008 09:22:24 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Agner Fog <agner@agner.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ABI change for device drivers using future AVX instruction set
Message-ID: <20080625092224.736c2541@infradead.org>
In-Reply-To: <48626514.2040905@agner.org>
References: <48626514.2040905@agner.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2008 17:32:36 +0200
Agner Fog <agner@agner.org> wrote:

> 
> One problem that has not been resolved yet, AFAIK, is how to handle
> the possible use of YMM registers in device drivers. Should these
> registers be saved before calling a device driver from an interrupt
> or should it be the responsibility of the device driver?

the answer is: you don't use AVX in drivers just as you don't use SSE
in drivers.

Let me repeat this loud and clear:

It is not allowed to use floating point, SSE of AVX in device drivers.

(there are few places that very carefully do this anyway, the raid5
code being the most obvious one, but we should not add more)


> 2. There is a performance cost to using XSAVE / XRESTOR.

a patch introducing xsave/xrestor is being discussed already here...
it's not really more expensive.

> 
> 3. When compiling a device driver, the compiler may insert implicit 
> calls to library functions such as memcpy and memset. These functions 
> typically have a CPU dispatcher that chooses the largest register
> size available. The device driver may therefore use YMM registers
> without the knowledge of the programmer and without compiling with
> the AVX switch on.

this is not correct; the library functions are provided by the kernel
and do not use AVX etc.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
