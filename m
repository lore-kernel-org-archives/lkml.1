Return-Path: <linux-kernel-owner+w=401wt.eu-S1756256AbYCMNCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256AbYCMNCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 09:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbYCMNCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 09:02:23 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:49725 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbYCMNCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 09:02:22 -0400
Message-ID: <47D925D2.9050003@linux.vnet.ibm.com>
Date: Thu, 13 Mar 2008 18:32:10 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Michael Ellerman <michael@ellerman.id.au>,
       Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, pbadari@gmail.com,
       benh@kernel.crashing.org
Subject: Re: [BUG] 2.6.25-rc5-mm1 kernel panic with "Exception: 501 " on powerpc
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org> <47D7D2C9.4090001@linux.vnet.ibm.com> <20080312104645.34e58319.akpm@linux-foundation.org> <20080312175102.GC613@parisc-linux.org> <1205360769.7436.8.camel@concordia.ozlabs.ibm.com> <20080312223300.GE613@parisc-linux.org>
In-Reply-To: <20080312223300.GE613@parisc-linux.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Thu, Mar 13, 2008 at 09:26:09AM +1100, Michael Ellerman wrote:
>> down() looks OK, but there's still a spin_lock_irq() in __down_common(),
>> although I don't know if it makes sense for us to be in __down() at that
>> stage.
> 
> The spin_lock_irq in __down_common is correct.  We're going to schedule(),
> so we spin_unlock_irq() to save us passing the flags into the helper
> function.  If we had interrupts disabled on entry, there's an Aieee
> for that.
> 

Hi All,

Sorry for all the noise made :-(, something wrong in the test setup from my end, 
the kernel was 2.6.25-rc3-mm1 not 2.6.25-rc5-mm1. This bug is not seen in the
2.6.25-rc5-mm1 kernel.

-- 
Thanks & Regards,
Kamalesh Babulal,
