Return-Path: <linux-kernel-owner+w=401wt.eu-S933205AbXLUCLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933205AbXLUCLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 21:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932595AbXLUCKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 21:10:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932394AbXLUCKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 21:10:07 -0500
Message-ID: <476B2070.7020004@redhat.com>
Date: Thu, 20 Dec 2007 21:09:52 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
References: <fa.HvUNJ45qy60H427u0v9fNt3Gc7E@ifi.uio.no> <fa.uuzqvr64HFsgxfiWwhEmE16Di6c@ifi.uio.no> <fa.zhxdNN/1rfQhfJLVmdGBjvKYrCM@ifi.uio.no> <fa.z1qlON6DA9ubBPFdrEcaFTMgYOY@ifi.uio.no> <fa.U/SCC1Gvd3nSOpkMu5vcsSPYyPE@ifi.uio.no> <fa.d8kGTkzOZH22bXRIRiakqgOPBM4@ifi.uio.no> <476B0C58.4030703@shaw.ca>
In-Reply-To: <476B0C58.4030703@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:

> The case of the device built into the K8 northbridge that's unreachable 
> by MMCONFIG kind of makes sense, since the northbridge is what's 
> translating the MMCONFIG memory access into config accesses. It seems 
> bizarre to me that a bridge chip could possibly have such a problem. The 
> MMCONFIG access should get translated into a configuration space access 
> in the northbridge and from that point on there's no difference between 
> an MMCONFIG and type1 access.
> 
Robert's point is well taken.

Only northbridge chips can give us this kind of trouble, and the only
chips mentioned in the present discussion as not being mmconf-compliant
are northbridges (8132, ht1000).

The patch is aware of this, so once a root bus has been programmed for
legacy pci config access, all descendent buses automatically inherit
this access mechanism and are therefore not probed by the patch.


