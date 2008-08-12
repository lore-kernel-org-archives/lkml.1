Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbYHLRTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbYHLRTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 13:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbYHLRS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 13:18:56 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:41200 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbYHLRSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 13:18:55 -0400
X-Greylist: delayed 384 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Aug 2008 13:18:54 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=s9EdrhULa1ayotI7aWBCN3n1a/eRw2+PdPbaVFSmzyrheIqMkEiuK9SATF2GDTxAZK
         F8pk3DTm0n5/q9P+t0QaK/FInfmi4H9Co9y/5/lKUD/bLPVeknbsyh/96wR9+5eBFmQl
         ycy5IqJ0hAqI8ospEKcP5FUsRuPtSBgy6ssAI=
Message-ID: <b9df5fa10808121012p4e4ddd15pda1704d4a9ab483a@mail.gmail.com>
Date: Tue, 12 Aug 2008 23:12:29 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: "Max Krasnyansky" <maxk@qualcomm.com>, "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH] cpuset: Rework sched domains and CPU hotplug handling (take 4)
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <48A1BCAB.2090502@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218490433-10576-1-git-send-email-maxk@qualcomm.com>
	 <48A0B16B.2080801@qualcomm.com>
	 <b9df5fa10808112021v7bb48c9ejefab284bea82c837@mail.gmail.com>
	 <48A1032F.4040606@qualcomm.com>
	 <b9df5fa10808120501i57dbd71k71b54cca0bfb2ff2@mail.gmail.com>
	 <b9df5fa10808120648x5bd541cdpd020cee836e89f20@mail.gmail.com>
	 <20080812112750.4257544e.pj@sgi.com> <48A1BCAB.2090502@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/12/08, Max Krasnyansky <maxk@qualcomm.com> wrote:
>
>
>  Paul Jackson wrote:
>  > Rakib wrote:
>  >> Ok, this is the second place. But, what about the first place ( I
>  >> mean in line 614).
>  >
>  > You present me with a clear choice.
>  >
>  >     I could find your past patch, applying it to whatever it applied to,
>  >     and look to see what was at line 614.
>  >
>  >     Or I could ask you to restate your point, with enough code
>  >     displayed so that I could understand your point just by reading
>  >     your email.
>  >
>  > I choose the second choice.  Thank-you.
>
>
> I think Rakib is talking about this code
 Yes, Max you are right . I'm talking about the following code.
>
>
>  >         /* Special case for the 99% of systems with one, full, sched domain */
>  >         if (is_sched_load_balance(&top_cpuset)) {
>
> >                 doms = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
>  >                 if (!doms)
>
> >                         goto done;
>
> >
>  >                 dattr = kmalloc(sizeof(struct sched_domain_attr), GFP_KERNEL);
>  >                 if (dattr) {
>  >                         *dattr = SD_ATTR_INIT;
>  >                         update_domain_attr_tree(dattr, &top_cpuset);
>  >                 }
 Don't you think , the memory allocation here needs to be checked ?
>  >                 *doms = top_cpuset.cpus_allowed;
>  >
>
> >                 ndoms = 1;
>  >                 goto done;
>  >         }
>
>  Which I think is perfectly fine and clear.
>
>  There are only two matches for
>         /attr.*=.*alloc
>  We covered both of them.
>
>
>  Max
>
>
>
>
