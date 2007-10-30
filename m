Return-Path: <linux-kernel-owner+w=401wt.eu-S1757127AbXJ3RqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127AbXJ3RqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 13:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbXJ3Rpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 13:45:54 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:40385 "EHLO
	outbound3-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752293AbXJ3Rpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 13:45:53 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
Date: Tue, 30 Oct 2007 18:44:52 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
cc: linux-kernel@vger.kernel.org, benjamin.serebrin@amd.com
Subject: Whats the purpose of get_cycles_sync()
Message-ID: <20071030174452.GA18619@amd.com>
MIME-Version: 1.0
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 30 Oct 2007 17:44:53.0042 (UTC)
 FILETIME=[93A90120:01C81B1C]
X-WSS-ID: 6B39B21D0QK588041-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I would like to answer what the special purpose of the get_cycles_sync()
function is in the x86 architecture. In special I ask myself why
this function has to be *sync*?

I mean, the sync should guarantee here that the CPU does not execute the
RDTSC instruction out-of-order, thats clear. But does that really
matter? If there is a cache/tlb miss before the function returns all
accuracy that should be won by the synchronous RDTSC is lost anyway.

The problem here is, that this function executes CPUID if RDTSC itself
is not a synchronizing instruction and CPUID is very often intercepted
by hypervisors (KVM intercepts it for example). This makes this function
very expensive if the kernel is executed as a guest.

But maybe I miss some important things here.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy


