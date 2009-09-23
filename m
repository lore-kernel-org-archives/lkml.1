Return-Path: <linux-kernel-owner+w=401wt.eu-S1753169AbZIWOMC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbZIWOMC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 10:12:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbZIWOMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 10:12:01 -0400
Received: from server78.greatnet.de ([83.133.96.102]:51188 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbZIWOL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 10:11:59 -0400
Message-ID: <4ABA2CA1.8070806@nachtwindheim.de>
Date: Wed, 23 Sep 2009 16:11:45 +0200
From: Henrik Kretzschmar <henne@nachtwindheim.de>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Wolfram Sang <w.sang@pengutronix.de>, jbarnes@virtousgeek.org,
       linux-pci@vger.kernel.org, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Crash on reading the whole PCI config of PIIX4 SMBus
References: <4AB8F142.9090609@nachtwindheim.de>	<20090922231839.GA20656@pengutronix.de>	<4ABA1B9C.9070302@nachtwindheim.de> <20090923153531.1642b77d@hyperion.delvare>
In-Reply-To: <20090923153531.1642b77d@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare schrieb:

> On Wed, 23 Sep 2009 14:59:08 +0200, Henrik Kretzschmar wrote:
>   
>> The commands _work_ with a coldstarted Linux and i2c-piix not loaded,
>> so the only thing I can do is blacklisting it and renounce sensors support,
>> having a good a argument for a new hardware aquisition. :)
>>     
>
> That's really odd, considering that the i2c-piix4 driver doesn't change
> the PCI device configuration, it only reads from it.
>
> If you trigger some transactions (for example by running "sensors -s"
> at boot time?) then you also write to the I/O ports. But this hardly
> explains how subsequently reading the PCI config space would crash.
>
> You might still want to check if maybe ACPI is interfering with the
> i2c-piix4 driver. This isn't the kind of result I'd expect, but who
> knows.
>   
This machine doesnt even have ACPI. :) Just APM.

But reading the config space may be dangerous, refering the manpage of lspci:
"
      -xxx   Show  hexadecimal  dump of the whole PCI configuration space. It
              is available only to root as several PCI devices crash when  you
              try to read some parts of the config space (this behavior proba-
              bly doesnt violate the PCI standard, but  its  at  least  very
              stupid).  However,  such  devices are rare, so you neednt worry
              much.
"

I seem to have stumbled over one of those stupidnesses.
That is the reason why non-root users are only allowed to
read the first 64 byte of the config space.
 
So its imho generally a good idea to run lspci -xxx on every machine you can
and save some time searching in the wrong places.

