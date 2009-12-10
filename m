Return-Path: <linux-kernel-owner+w=401wt.eu-S1761290AbZLJR5C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761290AbZLJR5C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 12:57:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761084AbZLJR46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 12:56:58 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:4864 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760986AbZLJR46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 12:56:58 -0500
Message-ID: <4B213627.5000007@caviumnetworks.com>
Date: Thu, 10 Dec 2009 09:55:51 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Convert BUG() to use unreachable()
References: <1260266138-17684-1-git-send-email-u.kleine-koenig@pengutronix.de> <20091210175007.GC13210@n2100.arm.linux.org.uk>
In-Reply-To: <20091210175007.GC13210@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 10 Dec 2009 17:55:51.0753 (UTC) FILETIME=[032F5390:01CA79C2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:
> On Tue, Dec 08, 2009 at 10:55:38AM +0100, Uwe Kleine-König wrote:
>> Use the new unreachable() macro instead of for(;;);
> 
> Have you investigated what effect this has on generated code?

Yes.

Pre GCC-4.5 the generated code should be identical as 'unreachable()' 
just expands to 'for(;;);' in this case.

Post GCC-4.5 the generated code should be smaller.

I have not tested on ARM, but on x86_64, i686, and mips64 this is the 
case.  The code size reduction is due to not emitting an endless loop 
after the asm() that never returns.

David Daney
