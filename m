Return-Path: <linux-kernel-owner+w=401wt.eu-S1761499AbXJMLjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761499AbXJMLjx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 07:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbXJMLjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 07:39:45 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:58678 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbXJMLjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 07:39:44 -0400
Date: Sat, 13 Oct 2007 13:39:43 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Randy Dunlap <randy.dunlap@oracle.com>, zippel@linux-m68k.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sam@ravnborg.org
Subject: Re: [PATCH] Allow kconfig to accept overrides
In-Reply-To: <47107ED2.6040509@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0710131338330.31913@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710122341530.16098@fbirervta.pbzchgretzou.qr>
 <20071012155708.d8abd06d.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0710130127420.31913@fbirervta.pbzchgretzou.qr>
 <47107ED2.6040509@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 13 2007 10:16, Stefan Richter wrote:
>>>> warning("override: %s turns state choice", sym->name);
>>>
>>>What does that warning message mean?  I can't decipher it.
>> 
>> It is when the value of a "choice" kconfig object is changed, for example
>> this .config excerpt:
>> 
>> CONFIG_PREEMPT_NONE=y
>> # CONFIG_PREEMPT_VOLUNTARY is not set
>> # CONFIG_PREEMPT is not set
>> # CONFIG_PREEMPT_BKL is not set
>> # CONFIG_PREEMPT_NONE is not set
>> CONFIG_REEMPT_VOLUNTARY=y
>
>Perhaps say
>
>	warning("override: switching to choice %s", sym->name);
>
>if sym->name is [CONFIG_]PREEMPT_VOLUNTARY.  Or what is it?

.config:176:warning: override: reassigning to symbol PREEMPT_VOLUNTARY
.config:176:warning: override: PREEMPT_VOLUNTARY turns state choice

Which seems correct, as PREEMPT_VOLUNTARY=y will overturn
the previous decision.

Perhaps it should be "%s overturns state choice" ?
