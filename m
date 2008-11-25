Return-Path: <linux-kernel-owner+w=401wt.eu-S1753752AbYKYLpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbYKYLpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 06:45:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbYKYLo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 06:44:59 -0500
Received: from 89.6b.364a.static.theplanet.com ([74.54.107.137]:37344 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbYKYLo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 06:44:58 -0500
Message-ID: <492BE534.5060903@compulab.co.il>
Date: Tue, 25 Nov 2008 13:44:52 +0200
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.16 (X11/20080907)
MIME-Version: 1.0
To: Liam Girdwood <lrg@slimlogic.co.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: move set_machine_constraints after regulator
 device initialization
References: <1227545055-28782-1-git-send-email-mike@compulab.co.il> <1227613143.585.47.camel@vega.slimlogic.co.uk>
In-Reply-To: <1227613143.585.47.camel@vega.slimlogic.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Liam Girdwood wrote:
> On Mon, 2008-11-24 at 18:44 +0200, Mike Rapoport wrote:
>> Calling set_machine_constraints before regulator device initialization
>> causes crash when constraints have apply_uV set.
>>
>> Signed-off-by: Mike Rapoport <mike@compulab.co.il>
>> ---
> 
> There have been recent changes to regulator registration in the
> regulator for-next branch. Does this crash still occur with for-next.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git #for-next

I haven't tested it yet, but looking at the code it seems the crash will occur
there as well.
regulator_register() calls set_machine_constraints() before setting rdev->dev
fields. The set_machine_constraints() in turn calls rdev->ops->set_voltage()
with NULL rdev->dev.

> Liam
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Sincerely yours,
Mike.

