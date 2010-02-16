Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068Ab0BPRWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 12:22:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:57668 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932161Ab0BPRWB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 12:22:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,485,1262592000"; 
   d="scan'208";a="492927316"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Samuel Ortiz <sameo@linux.intel.com>,
       Denis Turischev <denis@compulab.co.il>,
       LKML <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Date: Tue, 16 Feb 2010 09:19:58 -0800
Subject: RE: [PATCH 1/3] MFD: introduce lpc_sch for Intel SCH LPC bridge
Thread-Topic: [PATCH 1/3] MFD: introduce lpc_sch for Intel SCH LPC bridge
Thread-Index: AcqvHxO+f701p83OToyaBEscI6978AAAogvA
Message-ID: <43F901BD926A4E43B106BF17856F0755A2D58F23@orsmsx508.amr.corp.intel.com>
References: <4B73DAEE.5080400@compulab.co.il>
	<4B73DB4B.40501@compulab.co.il>	<20100216100809.GA2935@sortiz.org>
	<43F901BD926A4E43B106BF17856F0755A2D58DB5@orsmsx508.amr.corp.intel.com>
 <20100216164523.5a3e13a5@hyperion.delvare>
In-Reply-To: <20100216164523.5a3e13a5@hyperion.delvare>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>> >On Thu, Feb 11, 2010 at 12:26:19PM +0200, Denis Turischev wrote:
>> >> Intel Poulsbo (SCH) chipset LPC bridge controller contains several
>> >> functions. Creating and MFD driver for the LPC bridge controller allows
>> >> simultaneous use of SMBus and GPIO interfaces on the SCH.
>> >That looks like an nice patch to me. Before merging it, I'd like to get
>> >Jacob's view on it though. Jacob, does moving the SCH SMBus driver to a
>> >platform one look fine to you ?
>> >
>> [[JPAN]] i agree with merging gpio and smbus into lpc driver. the only
>question
>> i had was whether impact to the user space tools has been considered. iirc,
>> there are sensors detect tools probe pci bus for smbus controllers, not sure
>it
>> does that for platform bus.
>
>That shouldn't be a problem. The PCI device is still present, so
>sensors-detect will see it. Then it will load the required driver, and
>that driver will instantiate i2c adapters. The script then probes all
>i2c adapters regardless of who created them, so the exact driver
>implementation doesn't matter.
>
[[JPAN]] thanks for explaining it, all made sense to me. looking at
sensors-detect, it will still load isch driver for the same pci id.
but how would it know it depends on the new lpc driver to set up resources?
i can't see shared symbols.

	}, {
		vendid	=> 0x8086,
		devid	=> 0x8119,
		procid	=> "Intel SCH",
		driver	=> "i2c-isch",
	},

