Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbZCGBF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbZCGBF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 20:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755678AbZCGBEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 20:04:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51842 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbZCGBEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 20:04:49 -0500
Message-ID: <49B1C81B.5010904@zytor.com>
Date: Fri, 06 Mar 2009 17:04:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Matthew Wilcox <matthew@wil.cx>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] x86/pci: try to detect host_bridge pci_cfg_space
References: <49B1C50E.5010209@kernel.org> <49B1C69F.70904@zytor.com>
In-Reply-To: <49B1C69F.70904@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Yinghai Lu wrote:
>> Impact: get correct pci_cfg_size for host_bridge
>>
>> more host bridges support 4k cfg, so check them directly
>> instead of quirks.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> I'm utterly confused by this.  This is basically saying we should try to 
> probe for an extended device space for every host bridge.  Logically 
> speaking, this is valid: if there is a valid path by which we can probe 
> for byte 256 then it should succeed.
> 
> HOWEVER, the same argument applies for *every single device*.  So if 
> this does indeed work, why should we limit it to host bridges?
> 

Looking at the code (as opposed to just the patch) made it a bit 
clearer.  The argument you're making here is that only host bridges are 
known to have extended address space without also having a PCI-X 
extension header, right?

	-hpa

