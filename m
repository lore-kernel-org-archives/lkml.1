Return-Path: <linux-kernel-owner+w=401wt.eu-S1754726AbZHYLmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbZHYLmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 07:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbZHYLmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 07:42:53 -0400
Received: from sg2ehsobe003.messaging.microsoft.com ([207.46.51.77]:59924 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752547AbZHYLmw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 07:42:52 -0400
X-SpamScore: -33
X-BigFish: VPS-33(z21eWz1432R98dN936eM4015La4a4ka594izz1202hzzz32i203h6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KOXKJ1-01-1QV-02
X-M-MSG: 
Date: Tue, 25 Aug 2009 13:42:33 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: James Dingwall <james.dingwall@amdocs.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: BUG: 2.6.30.1 pv_ops kernel boot failure - bisected
Message-ID: <20090825114233.GL20811@alberich.amd.com>
References: <683099EDC3E36D40942EBF636EB88BF00701E35F@batmail1.corp.amdocs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <683099EDC3E36D40942EBF636EB88BF00701E35F@batmail1.corp.amdocs.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 25 Aug 2009 11:42:33.0513 (UTC) FILETIME=[2297E190:01CA2579]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 12:04:54PM +0100, James Dingwall wrote:
> 
> Hi,
> 
> I have encountered what appears to be a bug when using the 2.6.30 stable
> series as a pv_ops kernel under Xen 3.4.1.  The problem appears to have
> been introduced with the following commit (provided I bisected it
> correctly)
> 
> commit bb9b409349f533a919b6b6d95698fbe6ff4aa209
> Author: Andreas Herrmann <andreas.herrmann3@amd.com>
> Date:   Mon Jun 8 15:55:09 2009 +0200
> 
>     x86: Detect use of extended APIC ID for AMD CPUs
> 
> When I try and boot the domU (xm create -c) I do not get any output.
> With this commit reverted I can boot 2.6.30.5 pv_ops without issue,
> output follows below.  The system is a dual Opteron 242.  If more
> details about the hardware or configuration are required to debug this
> please let me know.  I'm willing to test any patches.


So it seems that commit

 commit 2cb078603abb612e3bcd428fb8122c3d39e08832
 Author: Jeremy Fitzhardinge <jeremy@goop.org>
 Date:   Wed Jul 22 09:59:35 2009 -0700

    x86, amd: Don't probe for extended APIC ID if APICs are disabled
    
    If we've logically disabled apics, don't probe the PCI space for the
    AMD extended APIC ID.
    
    [ Impact: prevent boot crash under Xen. ]
    
    Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
    Reported-by: Bastian Blank <bastian@waldi.eu.org>
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

needs to be added to 2.6.30.y for proper boot under Xen.
James, can you test this please?


Thanks,

Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


