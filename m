Return-Path: <linux-kernel-owner+w=401wt.eu-S1753100AbZIWOPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbZIWOPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 10:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbZIWOPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 10:15:17 -0400
Received: from poutre.nerim.net ([62.4.16.124]:51041 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbZIWOPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 10:15:16 -0400
Date: Wed, 23 Sep 2009 16:15:18 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: Wolfram Sang <w.sang@pengutronix.de>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Crash on reading the whole PCI config of PIIX4 SMBus
Message-ID: <20090923161518.5cb29107@hyperion.delvare>
In-Reply-To: <4ABA2CA1.8070806@nachtwindheim.de>
References: <4AB8F142.9090609@nachtwindheim.de>
	<20090922231839.GA20656@pengutronix.de>
	<4ABA1B9C.9070302@nachtwindheim.de>
	<20090923153531.1642b77d@hyperion.delvare>
	<4ABA2CA1.8070806@nachtwindheim.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Sep 2009 16:11:45 +0200, Henrik Kretzschmar wrote:
> Jean Delvare schrieb:
> > You might still want to check if maybe ACPI is interfering with the
> > i2c-piix4 driver. This isn't the kind of result I'd expect, but who
> > knows.
> >   
> This machine doesnt even have ACPI. :) Just APM.
> 
> But reading the config space may be dangerous, refering the manpage of lspci:
> "
>       -xxx   Show  hexadecimal  dump of the whole PCI configuration space. It
>               is available only to root as several PCI devices crash when  you
>               try to read some parts of the config space (this behavior proba-
>               bly doesnt violate the PCI standard, but  its  at  least  very
>               stupid).  However,  such  devices are rare, so you neednt worry
>               much.
> "
> 
> I seem to have stumbled over one of those stupidnesses.
> That is the reason why non-root users are only allowed to
> read the first 64 byte of the config space.

That's right, but it doesn't explain why i2c-piix4 crashes in the first
place, not why merely loading it causes further lspci -xxx to crash
when they did not beforehand. I admit I am totally clueless.

>  
> So its imho generally a good idea to run lspci -xxx on every machine you can
> and save some time searching in the wrong places.


-- 
Jean Delvare
