Return-Path: <linux-kernel-owner+w=401wt.eu-S1763542AbYCEXBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763542AbYCEXBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:01:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765558AbYCEWyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:54:52 -0500
Received: from rex.snapgear.com ([203.143.235.140]:58333 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764955AbYCEWyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:54:50 -0500
Message-ID: <47CF24B7.7050104@snapgear.com>
Date: Thu, 06 Mar 2008 08:54:47 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [M68KNOMMU]: fix fec driver interrupt races
References: <200803040652.m246q1SH012800@goober> <47CE851E.4000401@garzik.org>
In-Reply-To: <47CE851E.4000401@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

Jeff Garzik wrote:
> Greg Ungerer wrote:
>> The FEC driver has a common interrupt handler for all interrupt event
>> types. It is raised on a number of distinct interrupt vectors.
>> This handler can't be re-entered while processing an interrupt, so
>> make sure all requested vectors are flagged as IRQF_DISABLED.
>>
>> Signed-off-by: Greg Ungerer <gerg@uclinux.org>
> 
> NAK -- add spinlocks to your interrupt handling like you are supposed to

A better fix is to use the separate vectors, avoiding spinlocks
in most cases. But this is a simple immediate fix for 2.6.25.
The better solution is being worked on, but it needs some
reasonable testing before it is ready for inclusion, and that
won't be till post 2.6.25.

(This is a regression, fixes in the m68knommu interrupt subsystem
exposed this).

Regards
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
Secure Computing Corporation                PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
