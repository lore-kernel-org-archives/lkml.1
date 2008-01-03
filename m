Return-Path: <linux-kernel-owner+w=401wt.eu-S1757546AbYACLpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546AbYACLpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 06:45:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbYACLpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 06:45:25 -0500
Received: from mail0.scram.de ([78.47.204.202]:55071 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbYACLpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 06:45:24 -0500
X-Spam-Score: -4.02
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.4 AWL AWL: From: address is in the auto white-list
Message-ID: <477CCB0F.8020504@scram.de>
Date: Thu, 03 Jan 2008 12:46:23 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Jochen Friedrich <jochen@scram.de>, linuxppc-dev@ozlabs.org,
       Scott Wood <scottwood@freescale.com>, linux-kernel@vger.kernel.org,
       "linuxppc-embedded@ozlabs.org" <linuxppc-embedded@ozlabs.org>
Subject: Re: [PATCHv3] powerpc: DBox2 Board Support
References: <477522DB.4000100@scram.de> <20080102112030.GB23168@localhost.localdomain>
In-Reply-To: <20080102112030.GB23168@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

>> +/ {
>> +	model = "unknown,dbox2"; // boot wrapper fills in correct manufacturer
> 
> Probably better just to leave model out of the dts and let the
> bootwrapper add it.

Unfortunately, dtc requires a model:

$ dtc arch/powerpc/boot/dts/dbox2.dts
DTC: dts->dts  on file "arch/powerpc/boot/dts/dbox2.dts"
ERROR: Missing "model" property in /

>> +		flash@0,0 {
>> +			compatible = "cfi-flash";
>> +			reg = <0 0 800000>;
>> +			bank-width = <4>;
>> +			device-width = <1>;
>> +			#address-cells = <1>;
>> +			#size-cells = <1>;
>> +			partition@0 {
>> +				label = "BR bootloader";
>> +				reg = <0 20000>;
>> +				read-only;
>> +			};
>> +			partition@20000 {
>> +				label = "FLFS (U-Boot)";
>> +				reg = <20000 20000>;
>> +			};
>> +			partition@40000 {
>> +				label = "rootfs";
>> +				reg = <40000 7c0000>;
>> +			};
>> +			ovpartition@20000 {
> 
> Uh.. I really don't know what the MTD driver will handle these
> overlapping partitions.  I suspect it will not be pretty...
> 
>> +				label = "Flash without bootloader";
>> +				reg = <20000 7e0000>;
>> +			};
>> +			ovpartition@0 {
>> +				label = "Complete Flash";
>> +				reg = <0 800000>;
>> +				read-only;
>> +			};
>> +		};
>> +	};

MTD handles this correctly. dbox2 uses "Flash without bootloader" for flashing image updates and "Complete Flash" for creating a backup of everything.
OpenWRT also uses overlapping partitions BTW (and also for flashing updates).

Thanks,
Jochen
