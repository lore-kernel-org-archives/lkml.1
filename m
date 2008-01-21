Return-Path: <linux-kernel-owner+w=401wt.eu-S1759412AbYAUOb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412AbYAUOb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 09:31:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbYAUObT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 09:31:19 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:11989 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbYAUObS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 09:31:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=NT7S0YP5eyW38UmI440s5x+jvJeHUh/4wUT970QcoYcilnRdXoNrKraC3IqRz6hNmR/EsGzJaDw+IJoJ3ae+efnf4J8WyIs6BKiuf0qG14i8kT8BtBAwMxOVegcjOG26wH93HZNfGJEn5TSDxMKgESifGDWPcf8YpY7JfoOnowo=
Message-ID: <4794ACAF.70505@gmail.com>
Date: Mon, 21 Jan 2008 23:31:11 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Georgi Chulkov <g.chulkov@jacobs-university.de>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Mark Lord <liml@rtr.ca>
Subject: Re: ATA device reset, shoud I be concerned?
References: <200801140019.20668.g.chulkov@jacobs-university.de>	<20080115025435.1e21b703.akpm@linux-foundation.org>	<20080115113552.75731bf8@lxorguk.ukuu.org.uk>	<4794501E.90306@gmail.com>	<20080121130256.2443d7c1@lxorguk.ukuu.org.uk>	<47949AA4.9090601@gmail.com> <20080121141425.45aa9c61@lxorguk.ukuu.org.uk>
In-Reply-To: <20080121141425.45aa9c61@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> while IDE thinks that IRQ might be lost and complete the command if the
>> TF status register says so.
> 
> For PATA at least that makes a lot of sense. It would probably make the
> Promise driver a lot more stable too.

Can you elaborate a bit?  I don't really think completing a command
after 30sec timeout contributes a lot to driver stability.

>> It could be that the particular device doesn't raise IRQ on certain
>> error conditions but updates TF registers.  After timeout, IDE completes
>> the command with the indicated error while libata ignores the status and
>> resets the device.
> 
> And loses the important information like media errors
>  
>> libata never touches TF register after timeout because some controllers
>> lock up hard if TF register is read after certain error conditions
>> (event the status register).
> 
> Should that not then be a per host flag ?

Yeah, that would be the best.  The problem is that there are several
different kinds of timeouts and we don't know which controller locks up
after which timeout and investigating them is really difficult.

IMHO, losing media error information is much better than locking up a
machine hard.  We can start white listing known good controllers but I'm
skeptical how much benefit it will bring.

Thanks.

-- 
tejun
