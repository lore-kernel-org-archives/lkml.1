Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab0AOMAk (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 07:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757238Ab0AOMAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 07:00:40 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:38431 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206Ab0AOMAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 07:00:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wXYNu1oPzfYOcMTmCbxDJSP+uvATy/M4PjsS9/d0Y+msDg7aynOJkqJrW4y7Zeacav
         aaaQA+l0ZD4+9DnCgJCOtrI0OtQRpYXGT54A3Zht7Eo3h3lRvJXKfkzAN2G5HhuEj/V5
         /cja/IT67bprmaiXGeDC8dOPrNGH6Dr3PZY7o=
Date: Fri, 15 Jan 2010 15:00:31 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Ian Campbell <ijc@hellion.org.uk>, Brian Gerst <brgerst@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.33-rc2: Xen/Guest switching to user mode with no user page
	tables
Message-ID: <20100115120031.GA5412@lenovo>
References: <alpine.DEB.2.01.1001060240010.3483@bogon.housecafe.de> <20100106112133.GA5815@lenovo> <alpine.DEB.2.01.1001060434330.3483@bogon.housecafe.de> <4B4633D3.2070903@zytor.com> <alpine.DEB.2.01.1001071123220.3483@bogon.housecafe.de> <20100108215039.GD4967@lenovo> <73c1f2161001091750y67a852dfk7539021dcc82fa1f@mail.gmail.com> <20100110080940.GB5189@lenovo> <1263128343.2393.45.camel@cthulhu.hellion.org.uk> <alpine.DEB.2.01.1001150011480.3483@bogon.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1001150011480.3483@bogon.housecafe.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 15, 2010 at 12:36:42AM -0800, Christian Kujau wrote:
> On Sun, 10 Jan 2010 at 12:59, Ian Campbell wrote:
> > The correct fix is for the Xen backend to declare kernel RPL == 0 for 64
> > bit guests -- the hyervisor already takes care of all the necessary
> > squashing to ring 3 transparently (because making the guest worry about
> > it would break the very common assumption that you can distinguish user
> > from kernel CS by RPL).
> 
> Yes' it's a 64bit guest, I should have mentioned this from the beginning. 
> With the 2 patches from Ian and Cyrill applied, the DomU is now booting 
> fine again (currently running mainline -git).
> 
> Cyrill: with your patch alone (for arch/x86/kernel/process.c), the DomU
> is still not booting, Dom0 "xm dmesg" reporting the same error. As it's
> working with both patches applied, should I try to test with only Ian's
> patch (for arch/x86/xen/enlighten.c) applied?
> 
> In any case, feel free to add:
> 
>    Tested-by: Christian Kujau <lists@nerdbynature.de>
> 
> Thanks so much for your efforts to everyone involved!
> 
> Christian.
> -- 
> BOFH excuse #436:
> 
> Daemon escaped from pentagram
> 

Well, I think the Ian's patch is a key here and mine should be
droppped then. Thanks for testing!

	-- Cyrill
