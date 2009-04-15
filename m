Return-Path: <linux-kernel-owner+w=401wt.eu-S1756598AbZDOTsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbZDOTsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 15:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756293AbZDOTsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 15:48:05 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:51551 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769AbZDOTsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 15:48:04 -0400
Date: Wed, 15 Apr 2009 12:48:02 -0700
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
To: jvrao <jvrao@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Mike Anderson <andmike@linux.vnet.ibm.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
       Linux Driver <Linux-Driver@qlogic.com>
Subject: Re: Interrupts are being dropped under heavy IO on -rt .
Message-ID: <20090415194802.GD1382@plap4-2.local>
References: <49DF71CF.7070509@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DF71CF.7070509@linux.vnet.ibm.com>
Organization: QLogic Corporation
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 15 Apr 2009 19:48:02.0753 (UTC) FILETIME=[16722B10:01C9BE03]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Apr 2009, jvrao wrote:

> Qlogic driver uses MSI-EDGE interrupts by default.
>  
> On -rt kernel under heavy IO load we observed that the driver missed 
> interrupts occasionally.
> 
> Missing interrupts caused spurious mailbox timeouts and path failovers.
> 
> Suspecting MSI interrupts, we disabled MSI and forcing the driver to use 
> APIC interrupts (Patch attached).
> 
> With this change, our IO tests ran for extended period of time without 
> any issues.
> 
> It would be interesting to see if the MSI infrastructure itself has 
> issues on realtime, or it is the combination of qla2xxx/MSI.
> 
> Right now we don't have any setup to test out MSI with other adapters. 
> Hence, wondering if anyone faced similar issues.

Could you perhaps provide some details on hardware used within your
testing -- HBA type, storage, etc?  Also, can you share any logs of
the failures with extended-error-logging enabled
(ql2xextended_error_logging)?

Regards,
Andrew Vasquez
