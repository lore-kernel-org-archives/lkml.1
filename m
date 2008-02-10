Return-Path: <linux-kernel-owner+w=401wt.eu-S1756490AbYBJWce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbYBJWce (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 17:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbYBJWcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 17:32:16 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:48092 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351AbYBJWcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 17:32:15 -0500
Message-ID: <47AF7B6D.1000901@web.de>
Date: Sun, 10 Feb 2008 23:32:13 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [patch] kgdb light, v6
References: <20080210071331.GC3851@elte.hu> <20080210210900.GA27162@elte.hu> <47AF707C.6050305@web.de> <200802102314.19500.bzolnier@gmail.com>
In-Reply-To: <200802102314.19500.bzolnier@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Provags-ID: V01U2FsdGVkX1/VvPWYcHTnH0oVdmF1wkLv0giju6cynI+ffjHE
	+n3jeZzJ4p/2ltA/YnT2N5tgYy4haRx865dFTPScr1W0I5cRnl
	3/rl44lEY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> On Sunday 10 February 2008, Jan Kiszka wrote:
>> Ingo Molnar wrote:
>>> * Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
>>>>> +static int init_kgdboc(void)
>>>> __init
>>> done.
>> Uuh, careful. We need this for runtime reconfiguration.
> 
> it is used only for 'module_init(init_kgdboc);' in v6

Yeah, the usage chain is not obvious (given I'm looking at the right
version ATM - git just spits at me), the issue moved to
param_set_kgdboc_var which has to call into configure_kgdboc - now __init.

Ingo, please keep the original annotations, they where correct and
should have been optimal (under the given constraints or runtime
reconfiguration).

Jan
