Return-Path: <linux-kernel-owner+w=401wt.eu-S1755066AbZDUWFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbZDUWFk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 18:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757996AbZDUWF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 18:05:28 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:63322 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655AbZDUWF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 18:05:26 -0400
Message-ID: <49EE4341.50701@oracle.com>
Date: Tue, 21 Apr 2009 15:05:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: David Brownell <david-b@pacbell.net>, subrata@linux.vnet.ibm.com,
       linux-usb@vger.kernel.org, Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next <linux-next@vger.kernel.org>,
       sachinp <sachinp@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: [BUILD FAILURE 11/12] Next April 21 : PPC64 randconfig [drivers/usb/host/ohci-hcd.o]
References: <1240340081.9110.144.camel@subratamodak.linux.ibm.com> <200904211203.36969.david-b@pacbell.net> <5A202317-5104-4784-845B-B8C46E0A3C48@kernel.crashing.org>
In-Reply-To: <5A202317-5104-4784-845B-B8C46E0A3C48@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010202.49EE430B.01A6:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala wrote:
> 
> On Apr 21, 2009, at 2:03 PM, David Brownell wrote:
> 
>> On Tuesday 21 April 2009, Subrata Modak wrote:
>>> Observing this for the first time:
>>>
>>> CC      drivers/usb/host/ohci-hcd.o
>>> In file included from drivers/usb/host/ohci-hcd.c:1060:
>>> drivers/usb/host/ohci-ppc-of.c:242:2: error: #error "No endianess
>>
>> Hmm, scripts/get_maintainer.pl doesn't report
>> the PPC folk who maintain that file and its
>> kbuild infrastructure.
>>
>> Can we have some PPC folk look at (and fix) this?
> 
> The problem is in the drivers/usb/host/Kconfig:
> 
> config USB_OHCI_HCD_PPC_OF_BE
>         bool "Support big endian HC"
>         depends on USB_OHCI_HCD_PPC_OF
>         default y
>         select USB_OHCI_BIG_ENDIAN_DESC
>         select USB_OHCI_BIG_ENDIAN_MMIO
> 
> config USB_OHCI_HCD_PPC_OF_LE
>         bool "Support little endian HC"
>         depends on USB_OHCI_HCD_PPC_OF
>         default n
>         select USB_OHCI_LITTLE_ENDIAN
> 
> Since its feasible to say 'n' to both we get the compile error.  How do
> we enforce having at least one set?

Looks like using "choice" without "optional" would do it.
See Documentation/kbuild/kconfig-language.txt and various examples
in Kconfig* files.

-- 
~Randy
