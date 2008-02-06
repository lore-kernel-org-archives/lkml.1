Return-Path: <linux-kernel-owner+w=401wt.eu-S1763503AbYBFNQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763503AbYBFNQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 08:16:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762775AbYBFNP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 08:15:57 -0500
Received: from h155.mvista.com ([63.81.120.155]:24883 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762774AbYBFNP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 08:15:56 -0500
Message-ID: <47A9B340.2020603@ru.mvista.com>
Date: Wed, 06 Feb 2008 16:16:48 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Jason Wessel <jason.wessel@windriver.com>,
       kgdb-bugreport@lists.sourceforge.net, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Kgdb-bugreport] [PATCH 4/5] KGDB-8250: refactor configuration
References: <479FBAE8.3070809@web.de> <479FC57D.5030104@web.de> <47A325BC.6030305@ru.mvista.com> <47A38AD9.1060305@web.de>
In-Reply-To: <47A38AD9.1060305@web.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Jan Kiszka wrote:

>>>Sorry, previous version was missing some __init[data] attributes which
>>>were dropped in an intermediate stage. Here comes an updated patch:

>>><---snip--->

>>>This major refactoring of the quite complex kgdb8250 configuration does
>>>the following:

>>> - ensures that static configurations according to SERIAL_PORT_DFNS are
>>>   always loaded first
>>> - tries to pull more accurate configuration via serial8250_get_port_def
>>>   if simple-config is used
>>> - detects empty/invalid simple-configs
>>> - enforces KGDB_PORT_NUM <= SERIAL_8250_NR_UARTS at kconfig level
>>> - removes kgdb8250_add_port and its hook in serial_core (calling
>>>   serial8250_get_port_def in demand should provide us the same
>>>   information)

>>   You left powerpc-lite.patch broken with this change as it has
>>multiple calls to kgdb8250_add_port()...

> I see. But I wonder if there ever was a real need for these hooks (in
> 2.4 times?): If I look at bamboo_early_serial_map() e.g., I find it
> calling into early_serial_setup() which fills serial8250_ports[] - and
> that content is now retrieved via serial8250_get_port_def() when we
> parse the runtime or build-time provided parameters (port number &
> baudrate).

    Of course. But now the kgdb8250_add_port() calls need to be removed.

>>>Signed-off-by: Jan Kiszka <jan.kiszka@web.de>

WBR, Sergei
