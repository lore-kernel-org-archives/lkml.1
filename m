Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbXJ0RQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbXJ0RQs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 13:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755725AbXJ0RQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 13:16:39 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:32905 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbXJ0RQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 13:16:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=YbyNK/1749PM1zKCWkKsmIot17kNGcZeGWgEGHbD7QgFM7wqPoGd5wlxqyChJW0Uiav7j65J1x17r09cBW2RG7rJFGR7jMgdiO1g34ZAaZY5lVFuPMq30ZO53d6Pd18e6Zh49CmwOmHLtmQktxxzspfP1HKiMgZRbu243W+BCIg=
Message-ID: <47237255.9020001@gmail.com>
Date: Sat, 27 Oct 2007 21:16:05 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, cbou@mail.ru,
       dwmw2@infradead.org
Subject: Re: [PATCH] 2.6.24-rc1: ensure "present" sysfs attribute even if
 battery is absent
References: <200710272054.31160.arvidjaar@mail.ru>
In-Reply-To: <200710272054.31160.arvidjaar@mail.ru>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov wrote:
> I am not exactly sure about this one ... what other power_supply class drivers 
> do? Should I fix HAL instead (but then, I do not know whether HAL is the only 
> application that is using this interface).
> 
> 
Hm, do you need separate set of properties for that? You could register either 
of existing two, and read function will not allow read of anything but "present".
IMHO, this is what other modules do (/drivers/power)
One remaining trick here, you need to call unregister/register for power_supply 
if you change attributes -- so please check if your patched driver survives 
insertion of the battery.

Regards,
Alex.
