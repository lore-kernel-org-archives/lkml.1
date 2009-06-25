Return-Path: <linux-kernel-owner+w=401wt.eu-S1756799AbZFYAdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799AbZFYAdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 20:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbZFYAdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 20:33:32 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:43820 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753400AbZFYAdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 20:33:31 -0400
Message-ID: <4A42C5DC.1040103@snapgear.com>
Date: Thu, 25 Jun 2009 10:33:32 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: uClinux development list <uclinux-dev@uclinux.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [uClinux-dev] [PATCH] m68k: restore lost coldfire CLOCK_TICK_RATE
References: <20090620201147.GA14095@frolo.macqel>	<4A3EF81F.1060300@snapgear.com> <20090624211144.GA13167@frolo.macqel>
In-Reply-To: <20090624211144.GA13167@frolo.macqel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philippe,

Philippe De Muyter wrote:
> Hi Greg,
> 
> On Mon, Jun 22, 2009 at 01:18:55PM +1000, Greg Ungerer wrote:
>> HI Philippe,
>>
>> Philippe De Muyter wrote:
>>> Hello list,
>>> The good definition of CLOCK_TICK_RATE for coldfires has been lost in the
>>> merge of m68k and m68knommu include files.  Restore it.  Culprit :
>>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ebafc17468d58bd903c886175ca84a4edc69ae1d;hp=34055b806a6334624e7e8af6eefc3aee42372a85
>>> Signed-off-by: Philippe De Muyter <phdm@macqel.be>
>> Is it needed?
>> What is broken with the existing value?
> 
> I am no ntp expert, but IIRC kernel/time/ntp.c needs to know the remainder
> of CLOCK_TICK_RATE / HZ to obtain a good stability of the time.  That's
> probably only needed when you have ntpd running.

I thought it did that based on gettimeofday()?  And that ends up
going through the underlying timer code, which for both of
the ColdFire timer types doesn't use CLOCK_TICK_RATE. They directly
use the MCF_CLK definition.

Regards
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
