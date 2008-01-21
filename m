Return-Path: <linux-kernel-owner+w=401wt.eu-S1753044AbYAUSPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044AbYAUSPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 13:15:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbYAUSPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 13:15:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51421 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbYAUSPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 13:15:38 -0500
Message-ID: <4794E130.2090402@zytor.com>
Date: Mon, 21 Jan 2008 10:15:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Andi Kleen <ak@suse.de>, Yinghai Lu <Yinghai.Lu@sun.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86_64: check if Tom2 is enabled
References: <200801192045.17291.yinghai.lu@sun.com> <200801202257.47195.yinghai.lu@sun.com> <20080121172437.GA6722@cvg> <200801211903.27215.ak@suse.de> <20080121180913.GD6722@cvg>
In-Reply-To: <20080121180913.GD6722@cvg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> [Andi Kleen - Mon, Jan 21, 2008 at 07:03:27PM +0100]
> | 
> | > is it possible to change 'l' and 'h' to 'low' and 'high'?
> | > 'cause 'l' does look like '1' (one) number...
> | 
> | It would be fine for me for someone to implement safe_rdtscll() and get rid
> | of l and h everywhere. IMHO all the l and h accesses of MSRs are just harder
> | to read and error prone over the ll 64bit variants.
> | 
> | But I didn't want to add it just for this.
> | 
> 
> clear enough, thanks
> 

Actually, I think it depends on the specific MSR - some use the halves 
for different data, whereas others treat it as a large 64-bit object.

Ironically enough, the way the MSR interfaces were carried into the 
64-bit world makes the situation worse on 64 bits; edx:eax is the common 
way to represent a 64-bit value on 32 bits.

	-hpa
