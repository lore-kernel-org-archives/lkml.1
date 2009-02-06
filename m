Return-Path: <linux-kernel-owner+w=401wt.eu-S1757354AbZBFTM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354AbZBFTM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 14:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291AbZBFTMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 14:12:47 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:40463 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752199AbZBFTMq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 14:12:46 -0500
Message-Id: <1233947565.26348.1298959161@webmail.messagingengine.com>
X-Sasl-Enc: wF87utuiPxhcaQKJsnDjuYM/7LgRA4QxNjA9qsDmTCZt 1233947565
From: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
To: "David Brownell" <david-b@pacbell.net>, tom.leiming@gmail.com
Cc: greg@kroah.com, kay.sievers@vrfy.org, LW@karo-electronics.de,
       linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1233934812-20628-1-git-send-email-tom.leiming@gmail.com>
 <200902060959.22413.david-b@pacbell.net>
Subject: Re: [PATCH] platform driver:fix incorrect use of 'platform_bus_type'
 with 'struct device_driver'
In-Reply-To: <200902060959.22413.david-b@pacbell.net>
Date: Fri, 06 Feb 2009 17:12:45 -0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Feb 2009 09:59:22 -0800, "David Brownell" <david-b@pacbell.net> said:
> On Friday 06 February 2009, tom.leiming@gmail.com wrote:
> > From: Ming Lei <tom.leiming@gmail.com>
> > 
> > This patch fixes the bug reported in
> >         http://bugzilla.kernel.org/show_bug.cgi?id=11681.
> > 
> > "Lots of device drivers register a 'struct device_driver' with
> > the '.bus' member set to '&platform_bus_type'. This is wrong,
> > since the platform_bus functions expect the 'struct device_driver'
> > to be wrapped up in a 'struct platform_driver' which provides
> > some additional callbacks (like suspend_late, resume_early).
> > The effect may be that platform_suspend_late() uses bogus data
> > outside the device_driver struct as a pointer pointer to the
> > device driver's suspend_late() function or other hard to
> > reproduce failures."(Lothar Wassmann)
> > 
> > Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> 
> I just glanced at this ... but those parts looked like
> good fixes to this family of bugs.  Thanks.

Indeed!  Thanks for the patch.

Can we mark the drivers not fixed by this patch as BROKEN or at the very 
least block them from compiling if suspend support is enabled?  They hose
suspend and resume depending on random luck...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

