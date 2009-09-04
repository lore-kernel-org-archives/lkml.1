Return-Path: <linux-kernel-owner+w=401wt.eu-S933776AbZIDQeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933776AbZIDQeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 12:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933766AbZIDQeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 12:34:05 -0400
Received: from ru.mvista.com ([213.79.90.228]:9279 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933765AbZIDQeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 12:34:04 -0400
Date: Fri, 4 Sep 2009 20:34:04 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: pHilipp Zabel <philipp.zabel@gmail.com>
Cc: Daniel Mack <daniel@caiaq.de>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       spyro@f2s.com, cbou@mail.ru, mreimer@vpop.net
Subject: Re: [PATCH 2/5] pda-power: switch to new dev_pm_ops
Message-ID: <20090904163404.GA26581@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1249496971-9019-1-git-send-email-daniel@caiaq.de>
 <1249496971-9019-2-git-send-email-daniel@caiaq.de>
 <200908052149.55567.elendil@planet.nl>
 <20090805222920.GF19257@buzzloop.caiaq.de>
 <74d0deb30908060452k1fc0e982jf14be2e895e9a805@mail.gmail.com>
 <20090806125631.GI19257@buzzloop.caiaq.de>
 <74d0deb30908070635s2fa76e5t954742239b8592a4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <74d0deb30908070635s2fa76e5t954742239b8592a4@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 03:35:19PM +0200, pHilipp Zabel wrote:
[...]
> > +static struct dev_pm_ops pda_power_pm_ops = {
> > +       .poweroff       = pda_power_poweroff,
> > +       .restore        = pda_power_restore,
> > +};
> 
> No no, now you're missing .suspend/.resume. As I understand it, the
> suspend and hibernation codepaths are now completely separate.
> 
> Also, I'm not sure using .restore here is quite correct.
> enable_irq_wake is called in .poweroff, after .freeze + creation of
> the memory image. So if this memory image is restored during the next
> boot, there is no trace of irq wakup ever being enabled and thus no
> need to call disable_irq_wake.
> 
> I think just .suspend/.poweroff and .resume need to be used for this driver.

Daniel, any update on this patch?

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
