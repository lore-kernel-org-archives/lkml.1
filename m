Return-Path: <linux-kernel-owner+w=401wt.eu-S1752361AbZIZLnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbZIZLnu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 07:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbZIZLnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 07:43:49 -0400
Received: from bamako.nerim.net ([62.4.17.28]:56611 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbZIZLns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 07:43:48 -0400
Date: Sat, 26 Sep 2009 13:43:49 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Nix <nix@esperi.org.uk>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       lm-sensors@lm-sensors.org, linux-i2c@vger.kernel.org
Subject: Re: 2.6.31 regression: brand-new ACPI conflicts prevent I2C bus and
 temperature sensors being visible
Message-ID: <20090926134349.01580d9e@hyperion.delvare>
In-Reply-To: <87ws3maqf2.fsf@spindle.srvr.nix>
References: <87ws3maqf2.fsf@spindle.srvr.nix>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello man with no name,

On Sat, 26 Sep 2009 12:36:33 +0100, Nix wrote:
> [Sorry for the huge Cc:, but this problem may cross subsystems: at least
>  I have no idea which subsystem the problem is in.]
> 
> My desktop system is a newish Nehalem with PCIe (of course), the usual
> coretemp sensor, and a Winbond W83667HG on the I2C bus. In 2.6.30.5,
> this all worked, but in 2.6.31.1 the latter sensor isn't found. The boot
> log says, in part (full log appended):
> 
> [    0.929754] i2c /dev entries driver
> [    0.929821] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    0.929887] ACPI: I/O resource 0000:00:1f.3 [0x400-0x41f] conflicts with ACPI region SMRG [0x400-0x40f]
> [    0.929955] ACPI: Device needs an ACPI driver
> [    0.930003] i801_smbus: probe of 0000:00:1f.3 failed with error -16
> [    0.930077] coretemp coretemp.0: Using relative temperature scale!
> [    0.930156] coretemp coretemp.1: Using relative temperature scale!
> [    0.930228] coretemp coretemp.2: Using relative temperature scale!
> [    0.930304] coretemp coretemp.3: Using relative temperature scale!
> [    0.930375] coretemp coretemp.4: Using relative temperature scale!
> [    0.930448] coretemp coretemp.5: Using relative temperature scale!
> [    0.930521] coretemp coretemp.6: Using relative temperature scale!
> [    0.930596] coretemp coretemp.7: Using relative temperature scale!
> [    0.930682] w83627ehf: Found W83667HG chip at 0x290
> [    0.930736] ACPI: I/O resource w83627ehf [0x295-0x296] conflicts with ACPI region HWRE [0x290-0x299]
> [    0.930804] ACPI: Device needs an ACPI driver
> 
> 2.6.30.x said (I didn't have coretemp built in back then):
> 
> [   40.297764] i2c /dev entries driver
> [   40.297830] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [   40.297952] w83627ehf: Found W83667HG chip at 0x290
> 
> Note: coretemp is not at fault, I just built it in because I wanted
> *some* sort of temperature monitoring. Here's the same part of my first
> 2.6.31.x boot log, without coretemp:
> 
> [    0.931782] i2c /dev entries driver
> [    0.931848] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    0.931914] ACPI: I/O resource 0000:00:1f.3 [0x400-0x41f] conflicts with ACPI region SMRG [0x400-0x40f]
> [    0.931982] ACPI: Device needs an ACPI driver
> [    0.932031] i801_smbus: probe of 0000:00:1f.3 failed with error -16
> [    0.932109] w83627ehf: Found W83667HG chip at 0x290
> [    0.932163] ACPI: I/O resource w83627ehf [0x295-0x296] conflicts with ACPI region HWRE [0x290-0x299]
> [    0.932231] ACPI: Device needs an ACPI driver
> 
> The only kernel patch installed is TuxOnIce, and that too was installed
> and working in 2.6.30 and has hardly changed since then. (I very much
> doubt it gets involved in bus probes anyway, but I could verify that
> the regression still happens without it if need be.)
> 
> I can bisect for this if you wish.

You didn't do your homework. This issue has been reported several dozen
times already, both on LKML and on bugzilla. And it is fully documented
here:

http://www.lm-sensors.org/wiki/FAQ/Chapter3#Mysensorshavestoppedworkinginkernel2.6.31

-- 
Jean Delvare
