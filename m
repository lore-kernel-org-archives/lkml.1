Return-Path: <linux-kernel-owner+w=401wt.eu-S1761200AbZBLUbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761200AbZBLUbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 15:31:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760890AbZBLUaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 15:30:10 -0500
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:30574 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760885AbZBLUaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 15:30:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=vXgkgPi1xML11oQcnw0ITKCiAKytKvdNKeX1HHiUnDqc7RTdCK+sudB6BIaQpQdxBF7rjK9OXFTB2jsqejKxF9wWHy3nUqR0IlD2bzt3CU4+RmGRL1S5mmIxZt8PWWZa/CsRg1CCWaTGzmmrZYH3iuFC4NSz/q+RAv50zMmBBgc=  ;
X-YMail-OSG: yscaf5EVM1mO5p_vDQw_54D7p6ED3iwrsrfYBPd2e0teIofBivCTMtsmzV3cZPhzhZJtrqySFEET_CoOBEqa9Bbf22mWqrvYP86qNi6ldRTXtAYk0_zO3Kd5.4YNUzr47SnNHSYj0FfHT4oajNqimkwAxUCQYHiKpTLIOcauWNA9nY3Ki1e19slyQ4uN
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: felipe.balbi@nokia.com
Subject: Re: [PATCH] usb: musb: - kill the compile warning
Date: Thu, 12 Feb 2009 12:30:06 -0800
User-Agent: KMail/1.9.10
Cc: Bryan Wu <cooloney@kernel.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Mike Frysinger <vapier.adi@gmail.com>
References: <1233915810-18616-1-git-send-email-cooloney@kernel.org> <200902112203.25428.david-b@pacbell.net> <20090212105517.GY12881@scadufax.research.nokia.com>
In-Reply-To: <20090212105517.GY12881@scadufax.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902121230.06353.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 February 2009, Felipe Balbi wrote:
> On Thu, Feb 12, 2009 at 07:03:25AM +0100, David Brownell wrote:
> > On Friday 06 February 2009, Bryan Wu wrote:
> > > -       return (MUSB_BUSCTL_OFFSET(i, 0) + mbase);
> > > +       return (void __iomem *)(MUSB_BUSCTL_OFFSET(i, 0) + mbase);
> > 
> > Why is MUSB_BUSCTL_OFFSET() returning something other than
> > an integer?  "mbase" is already "void __iomem *", so the only
> > way that should trigger a warning is if that OFFSET() macro
> > is doing something odd.
> 
> The warning only comes on Blackfin's version of this, this hunk is
> unnecessary

We want to get rid of Blackfin-specific warnings too ... but
what I was hinting is that this can't be the right fix.
