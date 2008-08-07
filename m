Return-Path: <linux-kernel-owner+w=401wt.eu-S1753581AbYHGMyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbYHGMyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbYHGMyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:54:43 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:60145 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbYHGMyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:54:41 -0400
X-IronPort-AV: E=Sophos;i="4.31,319,1215388800"; 
   d="scan'208";a="1320074"
Message-ID: <489AD9C1.8020405@eu.citrix.com>
Date: Thu, 07 Aug 2008 12:17:21 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: kernel list <linux-kernel@vger.kernel.org>, krzysztof.h1@poczta.fm,
       adaplas@pol.net, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: 2.6.27-rc1: softcursor behaviour changed
References: <20080805212004.GA1592@elf.ucw.cz> <20080807085733.GA1560@elf.ucw.cz>
In-Reply-To: <20080807085733.GA1560@elf.ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Aug 2008 11:15:59.0815 (UTC) FILETIME=[F8769D70:01C8F87E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:

> Hi!
> 
>> In 2.6.26, this 
>>
>>     echo -e "\33[10;5000]\33[11;50]\33[?18;0;136c\33[?102m"
>>
>> produces some variation on cursor. on 2.6.27-rc1, I have no cursor at
>> all :-(.
> 
> The patch that changed it is below... and I must say I liked the old
> behaviour better. Unlike blinking, high-brightness background is
> actually useful. Can we get that one reverted?


The problem is not a matter of taste but a matter of correctness: the
build_attr function in drivers/char/vt.c stores the blink attribute as
the forth bit of the background color.
Then in fbcon we are interpreting the same forth bit of the background
color as intensity bit.
My patch fixes that.

