Return-Path: <linux-kernel-owner+w=401wt.eu-S1757912AbYFLTAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912AbYFLTAY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 15:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753739AbYFLTAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 15:00:06 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:33280 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753687AbYFLTAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 15:00:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:References:In-Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=kD5oCoRcQ01nE0Brz2zvT4aNkmSgbv387cfoE+bPzzyCJ7lkrx2f1L2rq399V2AR2r/EvZs58yyqCnT9WYRqO/AyJVipXQf2MhQTP5VgTOtNrIqONQ1kEKW9Ngx5Il5dgsFv3SxkFAc6hPN6HaYPQuGzb43tqwoseAYKyHJSYIY=  ;
X-YMail-OSG: _fxELncVM1mJyVmFAvOPgAVp5orpd5Tz.eQZ.Of93ncsA58UUza7mT144HlJlTaEghIi9ngEaeIpLh8tXbEqIBbj222DPeGyQeDrGSKOFWviam3.vk80uEMQ8H4QDxWzdh0G.3CuYxfFbJjCo78GL1r5
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [WARNING] local_bh_enable with irqs disabled:
Date: Thu, 12 Jun 2008 12:00:03 -0700
User-Agent: KMail/1.9.9
References: <Pine.LNX.4.64.0806031529520.21106@axis700.grange> <Pine.LNX.4.64.0806060751240.14536@axis700.grange> <20080605234136.189895a5.akpm@linux-foundation.org>
In-Reply-To: <20080605234136.189895a5.akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806121200.03424.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 June 2008, you wrote:
> On Fri, 6 Jun 2008 08:11:23 +0200 (CEST) Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> 
> > > Which kernel version are you running?
> > 
> > Sorry, this was a 2.6.26-rc3 based kernel with the gpio-sysfs patch from 
> > David, e.g., http://marc.info/?l=linux-kernel&m=121107105300923&w=2,
> > which introduces a call to device_unregister via gpiochip_unexport(chip); 
> > in gpiochip_remove. 
> 
> OK, thanks.
> 
> That's quite buggy and would have generated so many runtime warnings in
> a "developer" setup (rofl) that I look at Documentation/SubmitChecklist
> and just weep.
> 
> I'll drop it.

That seems excessive.  I observe a locking bug with a trivial fix;
happened because *one* code path (rmmod -- not often used with GPIOs
once they work) couldn't be tested on most of my test rigs.  It would
produce *ONE* runtime warning on that code path.

Other than missing one test case, the only other significant issue
from SubmitChecklist is that the Documentation/ABI update needs to
hold up until this merges to mainline, since one part of it includes
the date where that interface became available.

So ... what else were you thinking was trouble?

- Dave

