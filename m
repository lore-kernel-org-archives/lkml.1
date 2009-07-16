Return-Path: <linux-kernel-owner+w=401wt.eu-S1756918AbZGPBXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918AbZGPBXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 21:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756885AbZGPBXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 21:23:23 -0400
Received: from wa4ehsobe004.messaging.microsoft.com ([216.32.181.14]:21005
	"EHLO WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756884AbZGPBXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 21:23:22 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1432R98dN936eMzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KMUP6H-03-GY3-01
Date: Thu, 16 Jul 2009 09:23:10 +0800
From: "Cai, Crane" <crane.cai@amd.com>
To: ykzhao <yakui.zhao@intel.com>
CC: Crane Cai <crane.cai@amd.com>, "lenb@kernel.org" <lenb@kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI: add driver for SMBus Control Method Interface
Message-ID: <20090716012310.GA5806@crane-desktop>
Mail-Followup-To: "Cai, Crane" <crane.cai@amd.com>,
	ykzhao <yakui.zhao@intel.com>, "lenb@kernel.org" <lenb@kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20090715060219.GA30514@crane-desktop> <1247651002.4113.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1247651002.4113.9.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 16 Jul 2009 01:23:10.0345 (UTC) FILETIME=[FB187790:01CA05B3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 05:43:22PM +0800, ykzhao wrote:
> On Wed, 2009-07-15 at 14:02 +0800, Crane Cai wrote:
>> This driver supports the SMBus Control Method Interface. It needs BIOS declare
>> ACPI control methods via SMBus Control Method Interface Spec.
> It seems that SM bus control is realized in BIOS. And OS can use the
> given control method interface to access it. 
> Will this controller be accessed directly directly BIOS?
Controller accessed by ACPI control method, the control method is called by OS.

> If it can be accessed by BIOS, how to resolve the conflict between BIOS
> and OS?
About conflicts see next question's answer.
> 
> In fact we see the conflict on some boxes. The SMbus controller will be
> accessed by BIOS. If the corresponding driver is loaded for the SMBUS
> controller, there exists the potential risk. In such case we will hide
> the SMbus controller or not load the device driver for it.
About conflicts, 
CMI driver access SMBus host controller via ACPI control methods. Its related 
resource will be declared in ACPI region. Its controll methods will be insured 
by BIOS.
Native PCI interface SMBus host controller driver such as i2c-piix4.c, its
resource is in PCI region. Its access methods is in its driver.
So, CMI driver & native PCI interface driver use different resouces and methods
to access SMBus host controller. 2 different devices controlled by 2 different
drivers and no conflicts exists.

> 
> Thanks.

-- 
Best Regards,
- Crane

