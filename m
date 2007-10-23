Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbXJWJ4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbXJWJ4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 05:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbXJWJ4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 05:56:06 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:34941 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbXJWJ4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 05:56:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=izL/e69F5DIyTkzH8mIarsuiFJ9VDZ6qqHMQxU/CLVgWkfmlCBk0os3u6rgQz6Vj3xY2aiVz/b6ptN8OufkxTrL7EBRTzO0IT8icbAva4eryS2V6HDxp8rd8AwhJ+jMmvPknUUBlTeXlbLaAmv9mQt4VaH97ah/yMnintjwZMGo=
Message-ID: <471DC52B.20802@gmail.com>
Date: Tue, 23 Oct 2007 18:55:55 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Steen Eugen Poulsen <sep@lix-world.net>
CC: Andrew Morton <akpm@linux-foundation.org>, lists@dusted.dk,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
References: <56020.194.255.108.253.1192004925.squirrel@root.dusted.dk> <20071012174153.69556b32.akpm@linux-foundation.org> <47105C53.7040603@lix-world.net>
In-Reply-To: <47105C53.7040603@lix-world.net>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Steen Eugen Poulsen wrote:
> Sep 28 04:32:40 locker ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0
> action 0x2 frozen
> Sep 28 04:32:40 locker ata1.00: cmd b0/d2:f1:00:4f:c2/00:00:00:00:00/00
> tag 0 cdb 0x0 data 123392 in
> Sep 28 04:32:40 locker res 50/00:f1:00:4f:c2/00:00:00:00:00/00 Emask
> 0x202 (HSM violation)
[--snip--]
> Another machine:
> 
> Sep 28 03:47:55 dragonslair ata1.00: exception Emask 0x0 SAct 0x0 SErr
> 0x0 action 0x2 frozen
> Sep 28 03:47:55 dragonslair ata1.00: cmd
> b0/db:f8:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 126976 in
> 
> Sep 28 03:47:55 dragonslair res 50/00:f8:00:4f:c2/00:00:00:00:00/00
> Emask 0x202 (HSM violation)
[--snip--]
> Sep 28 04:33:52 liferaft kernel: ata1.00: exception Emask 0x0 SAct 0x0
> SErr 0x0 action 0x2 frozen
> Sep 28 04:33:55 liferaft kernel: ata1.00: cmd
> b0/d2:f1:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 123392 in
> Sep 28 04:33:55 liferaft kernel:          res
> 50/00:f1:00:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM violation)
> Sep 28 04:33:55 liferaft kernel: ata1: soft resetting port
> Sep 28 04:33:55 liferaft kernel: ata1: SATA link up 3.0 Gbps (SStatus
> 123 SControl 300)
> Sep 28 04:33:55 liferaft kernel: ata1.00: configured for UDMA/133
> Sep 28 04:33:55 liferaft kernel: ata1: EH complete

All these are caused by smartd.  Updating should fix the problem.

> Note 2: The hardware didn't freeze for me and I believe the freeze is do
> to swap breaking due to the errors.

Above HSM violations should be harmless other than those messages.
libata resets the devices and should just go on.

> Note 3: dragonslair's harddisk actually crashed, kernel didn't die, it
> just remounted read only. Reboot and the disk was missing, more reboot
> and the machine started with all disks running again, been stable since
> the 28th Sep. (knock on wood)

libata EH can't really recover from actual hardware failures but some
drives come back on if you hot unplug and then replug it.

-- 
tejun
