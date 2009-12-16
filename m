Return-Path: <linux-kernel-owner+w=401wt.eu-S933965AbZLPN66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933965AbZLPN66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 08:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933182AbZLPN65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 08:58:57 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33651 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933931AbZLPN64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 08:58:56 -0500
Date: Wed, 16 Dec 2009 14:58:49 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Convert BUG() to use unreachable()
Message-ID: <20091216135849.GC3674@pengutronix.de>
References: <1260266138-17684-1-git-send-email-u.kleine-koenig@pengutronix.de> <20091210175007.GC13210@n2100.arm.linux.org.uk> <4B213627.5000007@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B213627.5000007@caviumnetworks.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo,

On Thu, Dec 10, 2009 at 09:55:51AM -0800, David Daney wrote:
> Russell King - ARM Linux wrote:
>> On Tue, Dec 08, 2009 at 10:55:38AM +0100, Uwe Kleine-König wrote:
>>> Use the new unreachable() macro instead of for(;;);
>>
>> Have you investigated what effect this has on generated code?
>
> Yes.
>
> Pre GCC-4.5 the generated code should be identical as 'unreachable()'  
> just expands to 'for(;;);' in this case.
>
> Post GCC-4.5 the generated code should be smaller.
I don't have a toolchain using gcc 4.5.

What should we do with this patch?  I think in theory the patch is OK.
And for pre gcc-4.5 it should not make any difference as we have in
include/linux/compiler-gcc4.h:

#if __GNUC_MINOR__ >= 5
...
#define unreachable() __builtin_unreachable()
#endif

and in include/linux/compiler.h:

#ifndef unreachable
# define unreachable() do { } while (1)
#endif

So the only impact if that

	do { } while (1)

is used instead of

	for(;;)

.  My toolchain (based on 4.3.2) produces the same object files with and
without the patch.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
