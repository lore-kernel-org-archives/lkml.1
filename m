Return-Path: <linux-kernel-owner+w=401wt.eu-S1756166AbYJIUJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbYJIUJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 16:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbYJIUJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 16:09:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42002 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842AbYJIUJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 16:09:42 -0400
Subject: Re: rc9 + orinoco WPA patchset: BUG: scheduling while atomic
	loading firmware with PCMCIA adapter
From: Dan Williams <dcbw@redhat.com>
To: Andrey Borzenkov <arvidjaar@newmail.ru>
Cc: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200810092321.55033.arvidjaar@newmail.ru>
References: <200810091722.56812.arvidjaar@newmail.ru>
	 <200810091959.54987.arvidjaar@newmail.ru>
	 <1223568410.18104.42.camel@dhcp-100-3-195.bos.redhat.com>
	 <200810092321.55033.arvidjaar@newmail.ru>
Content-Type: text/plain
Date: Thu, 09 Oct 2008 15:40:33 -0400
Message-Id: <1223581233.14959.16.camel@dhcp-100-3-195.bos.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-09 at 23:21 +0400, Andrey Borzenkov wrote:
> On Thursday 09 October 2008, Dan Williams wrote:
> > 
> > On Thu, 2008-10-09 at 19:59 +0400, Andrey Borzenkov wrote:
> > > On Thursday 09 October 2008, Matthew Wilcox wrote:
> > > > 
> > > > On Thu, Oct 09, 2008 at 05:22:55PM +0400, Andrey Borzenkov wrote:
> > > > > After loading orinoco and "inserting" adapter I get either BUG with
> > > > > endless loop (attached) or kernel panic on NULL pointer dereference
> > > > > (was not able capture). Adapter works fine with wlags49 driver.
> > > > 
> > > > It looks like you've fallen off the bottom of the kernel stack.  Do you
> > > > have 4k stacks enabled in your config?
> > > > 
> > > 
> > > You are right. Using 8K stacks load and runs fine. Hmm ... not nice
> > > from it :p
> > 
> > == driver bug; the driver should not require large stacks and this
> > should get fixed.
> > 
> 
> The attached patch fixes 4K stack for me. I have not tested spectrum case.

Looks pretty good, although if nobody can test the Symbol case (all I
have is Intersil firmware) maybe you should not use priv->pda_size but
#define SYMBOL_PDA_SIZE 256 and use that for the hermes_read_pda()
length just to ensure the patched code is functionally the same as
before the patch.

Dan


