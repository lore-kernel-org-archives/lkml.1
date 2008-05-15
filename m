Return-Path: <linux-kernel-owner+w=401wt.eu-S1762115AbYEOQIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762115AbYEOQIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 12:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759112AbYEOQHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 12:07:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:7812 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756048AbYEOQHy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 12:07:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,492,1204531200"; 
   d="scan'208";a="328660088"
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [PATCH] drivers/net: remove network drivers' last few uses of IRQF_SAMPLE_RANDOM
Date: Thu, 15 May 2008 09:07:52 -0700
Message-ID: <36D9DB17C6DE9E40B059440DB8D95F52052D71BB@orsmsx418.amr.corp.intel.com>
In-Reply-To: <20080515142154.0595e475@core>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/net: remove network drivers' last few uses of IRQF_SAMPLE_RANDOM
Thread-Index: Aci2kE8eypI8LcDaRwCiimhwfqe3MwAFGBsA
References: <Pine.LNX.4.62.0805150009060.18303@ikari.dreamhost.com> <20080515142154.0595e475@core>
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Chris Peterson" <cpeterso@cpeterso.com>, <jeff@garzik.org>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 15 May 2008 16:07:53.0239 (UTC) FILETIME=[D4940A70:01C8B6A5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Chris Peterson <cpeterso@cpeterso.com> wrote:
>> I know Jeff Garzik says he's not interested in an anti-entropy
>> pogrom for existing net drivers, but here is the patch if anyone
>> else is interested..? :)  
>> 
>> Only 12 net drivers are affected, the last of the
>> theoretically-exploitable network entropy. 
> 
> Looks fine to me. If Jeff doesn't want to touch them then send them
> direct to Andrew/Linus.
> 
> A more interesting alternative might be to mark things like network
> drivers with a new flag say IRQF_SAMPLE_DUBIOUS so that users can be
> given a switch to enable/disable their use depending upon the
> environment. 

we've been hearing rumblings of big customers wanting (maybe requiring)
wired network drivers from Intel to  advertise this flag.  Jeff have you
heard of such?

I think the argument is that a headless system (no keyboard/mouse, no
soundcard, probably no video) with a libata based driver and a network
driver without IRQF_SAMPLE_RANDOM has *no* sources of entropy.  In this
case the argument is very strong for at least *some* source of entropy
from interrupts so that randomness can get some external input.  Just
try rebuilding a kernel RPM over an ssh session and you'll see what I
mean.

In short, I agree with Alan's IRQF_SAMPLE_DUBIOUS, and know of Linux
customers who also want the same.
