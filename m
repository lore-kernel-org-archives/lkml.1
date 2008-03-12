Return-Path: <linux-kernel-owner+w=401wt.eu-S1755859AbYCLWd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbYCLWd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 18:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbYCLWdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 18:33:18 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:47766 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbYCLWdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 18:33:17 -0400
Date: Wed, 12 Mar 2008 16:33:00 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [BUG] 2.6.25-rc5-mm1 kernel panic with "Exception: 501 " on powerpc
Message-ID: <20080312223300.GE613@parisc-linux.org>
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org> <47D7D2C9.4090001@linux.vnet.ibm.com> <20080312104645.34e58319.akpm@linux-foundation.org> <20080312175102.GC613@parisc-linux.org> <1205360769.7436.8.camel@concordia.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205360769.7436.8.camel@concordia.ozlabs.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 09:26:09AM +1100, Michael Ellerman wrote:
> down() looks OK, but there's still a spin_lock_irq() in __down_common(),
> although I don't know if it makes sense for us to be in __down() at that
> stage.

The spin_lock_irq in __down_common is correct.  We're going to schedule(),
so we spin_unlock_irq() to save us passing the flags into the helper
function.  If we had interrupts disabled on entry, there's an Aieee
for that.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
