Return-Path: <linux-kernel-owner+w=401wt.eu-S1758751AbZDUVhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751AbZDUVhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 17:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbZDUVhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 17:37:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:40341 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708AbZDUVhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 17:37:35 -0400
Cc: subrata@linux.vnet.ibm.com, linux-usb@vger.kernel.org,
       "Linuxppc-dev" <Linuxppc-dev@ozlabs.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next" <linux-next@vger.kernel.org>,
       sachinp <sachinp@linux.vnet.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>
Message-Id: <5A202317-5104-4784-845B-B8C46E0A3C48@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: David Brownell <david-b@pacbell.net>
In-Reply-To: <200904211203.36969.david-b@pacbell.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [BUILD FAILURE 11/12] Next April 21 : PPC64 randconfig [drivers/usb/host/ohci-hcd.o]
Date: Tue, 21 Apr 2009 16:37:10 -0500
References: <1240340081.9110.144.camel@subratamodak.linux.ibm.com> <200904211203.36969.david-b@pacbell.net>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 21, 2009, at 2:03 PM, David Brownell wrote:

> On Tuesday 21 April 2009, Subrata Modak wrote:
>> Observing this for the first time:
>>
>> CC      drivers/usb/host/ohci-hcd.o
>> In file included from drivers/usb/host/ohci-hcd.c:1060:
>> drivers/usb/host/ohci-ppc-of.c:242:2: error: #error "No endianess
>
> Hmm, scripts/get_maintainer.pl doesn't report
> the PPC folk who maintain that file and its
> kbuild infrastructure.
>
> Can we have some PPC folk look at (and fix) this?

The problem is in the drivers/usb/host/Kconfig:

config USB_OHCI_HCD_PPC_OF_BE
         bool "Support big endian HC"
         depends on USB_OHCI_HCD_PPC_OF
         default y
         select USB_OHCI_BIG_ENDIAN_DESC
         select USB_OHCI_BIG_ENDIAN_MMIO

config USB_OHCI_HCD_PPC_OF_LE
         bool "Support little endian HC"
         depends on USB_OHCI_HCD_PPC_OF
         default n
         select USB_OHCI_LITTLE_ENDIAN

Since its feasible to say 'n' to both we get the compile error.  How  
do we enforce having at least one set?

- k
