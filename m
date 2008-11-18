Return-Path: <linux-kernel-owner+w=401wt.eu-S1753258AbYKROp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbYKROp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 09:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbYKROpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 09:45:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:57879 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbYKROpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 09:45:15 -0500
Date: Tue, 18 Nov 2008 06:45:56 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Eric Lacombe <goretux@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [x86] do_arch_prctl - bug?
Message-ID: <20081118064556.6b7dc245@infradead.org>
In-Reply-To: <200811181533.33108.goretux@gmail.com>
References: <200811181533.33108.goretux@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2008 15:33:32 +0100
Eric Lacombe <goretux@gmail.com> wrote:

> Hello,
> 
> I would like to know why the ARCH_SET_GS action of sys_arch_prctl,
> write the MSR MSR_KERNEL_GS_BASE and not the MSR MSR_GS_BASE when the
> variable "doit" equals 1? Is that a bug?
> 

I don't think it is.
The trick is that we use "swapgs" on entering/leaving the kernel, and
that will "swap" gs with the MSR, so when we return to userspace, GS
gets loaded from the MSR_KERNEL_GS_BASE ...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
