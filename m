Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbXHBIHC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbXHBIHC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 04:07:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbXHBIGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 04:06:45 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:1875 "EHLO
	outbound3-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751987AbXHBIGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 04:06:41 -0400
X-BigFish: VP
X-FB-SS: 0,
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
From: "Joachim Deguara" <joachim.deguara@amd.com>
Organization: AMD
To: "Michael Chan" <mchan@broadcom.com>
Subject: Re: [REGRESSION] tg3 dead after s2ram
Date: Thu, 2 Aug 2007 10:05:44 +0200
User-Agent: KMail/1.9.7
cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "lkml List" <linux-kernel@vger.kernel.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "netdev" <netdev@vger.kernel.org>, linux-acpi@vger.kernel.org
References: <20070731174522.b141178a.akpm@linux-foundation.org>
 <1185990466.5552.34.camel@dell> <1186002023.18322.7.camel@dell>
In-Reply-To: <1186002023.18322.7.camel@dell>
MIME-Version: 1.0
Message-ID: <200708021005.45773.joachim.deguara@amd.com>
X-OriginalArrivalTime: 02 Aug 2007 08:06:25.0079 (UTC)
 FILETIME=[05566470:01C7D4DC]
X-WSS-ID: 6AAF4F0E0X83269968-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 August 2007 23:00:23 Michael Chan wrote:
> On Wed, 2007-08-01 at 10:47 -0700, Michael Chan wrote:
> > You have 2 Broadcom devices in your system.  07:00.0 is a wireless
> > device, I think.  8:4.0 is the tg3 device.
> >
> > It's clear that the tg3 device is still in D3 state after resume and
> > that explains why all register accesses fail.  tg3_resume() should put
> > the device back in D0 state in a very straight forward way and I don't
> > see how that can fail.  It worked for me when I tested it last night.
> > Can you add some printk() to tg3_resume() to see what's happening?  Let
> > me know if you want me to send you some debug patches to do that.
>
> I misread the PCI registers below.  The power state was ok.
>
> The problem is that memory enable and bus master were not set in PCI
> register 4 after resume.  This also explains the register access
> failures.
>
> In tg3_resume(), we call pci_restore_state() which should re-enable
> those 2 bits in PCI register 4.  Can you add some printk() to see why
> those bits are not restored after pci_restore_state()?

Reading pci_restore_state() it looks already instrumented.  Sorry about the 
wrong pci device, looking at my BCM5788 it is pci device 08:04.0 and looking 
at the log from my first post there is nothing restored in the first 64 
bytes!  Otherwise it would have said "PM: Writing back..."

Is this what you are looking for or should I do other printk instrumentation?

-Joachim

 


