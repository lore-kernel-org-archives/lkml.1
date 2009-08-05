Return-Path: <linux-kernel-owner+w=401wt.eu-S934710AbZHEQ6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934710AbZHEQ6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 12:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934693AbZHEQ6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 12:58:40 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:40029 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934442AbZHEQ6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 12:58:39 -0400
Date: Wed, 5 Aug 2009 18:58:37 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, szabolcs.gyurko@tlt.hu, mreimer@vpop.net,
       cbou@mail.ru
Subject: Re: [PATCH 1/2] ds2760: switch to new dev_pm_ops
Message-ID: <20090805165837.GK13236@buzzloop.caiaq.de>
References: <1249476387-27325-1-git-send-email-daniel@caiaq.de> <200908051657.49810.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908051657.49810.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 04:57:47PM +0200, Frans Pop wrote:
> Daniel Mack wrote:
> > +static struct dev_pm_ops ds2760_battery_pm_ops = {
> > +       .suspend        = ds2760_battery_suspend,
> > +       .resume         = ds2760_battery_resume,
> > +};
> 
> Just to make sure...
> 
> Have you followed the earlier discussions on dev_pm_ops conversions and 
> are you aware that if done like this the driver no longer supports 
> hibernation?
> 
> If omitting hibernation is intentional, it should probably be justified in 
> the commit log.
> 
> See http://lkml.org/lkml/2009/7/25/118 for background.

Hmm, I tested that on a embedded hardware platform which doesn't supoprt
hibernation anyway. But you're right, to prevent regressions, .freeze
and .thaw should probably be given as well.

I'll fix that and resend.

Thanks,
Daniel
