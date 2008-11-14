Return-Path: <linux-kernel-owner+w=401wt.eu-S1753961AbYKNBpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbYKNBpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 20:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbYKNBpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 20:45:44 -0500
Received: from hpsmtp-eml19.KPNXCHANGE.COM ([213.75.38.84]:2013 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751345AbYKNBpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 20:45:43 -0500
From: Frans Pop <elendil@planet.nl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Bootup time regression from 2.6.27 to 2.6.28-rc3+
Date: Fri, 14 Nov 2008 02:45:38 +0100
User-Agent: KMail/1.9.9
Cc: Arjan van de Ven <arjan@infradead.org>,
       Lukas Hejtmanek <xhejtman@ics.muni.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, corsac@debian.org
References: <20081104173300.GF6134@ics.muni.cz> <20081109132438.5d81cd74@infradead.org> <alpine.LFD.2.00.0811092226050.12263@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0811092226050.12263@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811140245.40505.elendil@planet.nl>
X-OriginalArrivalTime: 14 Nov 2008 01:45:41.0238 (UTC) FILETIME=[B37F6160:01C945FA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas/Arjan,

On Sunday 09 November 2008, Thomas Gleixner wrote:
> I worked all week after returning from travelling to get down to the
> root cause of this. We had several issues:
>
> 1) peek_ahead confused the hell out of the nohz code when it expired
> timers when the timer interrupt was already pending
>
> 2) the changes I did to prevent the stale jiffies in the nohz case
> turned out to be incomplete and wrong versus the broadcast of timers
> in deeper C-States
>
> 3) the consolidation of the nohz idle checks called the nohz jiffies
> update code before calling __irq_enter() which caused useless wakeups
> of ksoftirqd
>
> 4) A long standing - but until now papered over and therefor unnoticed
> - problem of spurious wakeups from deep c-states:
>
>   If one core gets an interrupt the other core(s) wake up as
>   well. The stale jiffies fix and the peek_ahead changes made this
>   more visible and is a major part of the reported nohz (more wakeups,
>   more power consumption) regression.
>
>   This was there forever, but nobody noticed as it was not accounted
>   for.
>
> Find below the lineup of the timers-fixes-for-linus branch of the tip
> tree (the same as Arjan posted minus the irq fixes)

Could either of you maybe give a status update on this patch set and the 
remaining issues with it that were reported (especially the high C0 
reported by powertop)?

TIA,
FJP
