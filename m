Return-Path: <linux-kernel-owner+w=401wt.eu-S1759325AbXH1MRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325AbXH1MRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 08:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbXH1MRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 08:17:06 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:57597 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbXH1MRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 08:17:04 -0400
Date: Tue, 28 Aug 2007 16:16:19 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Jan-Bernd Themann <ossthema@de.ibm.com>
Cc: James Chapman <jchapman@katalix.com>, David Miller <davem@davemloft.net>,
       shemminger@linux-foundation.org, akepner@sgi.com,
       netdev@vger.kernel.org, raisch@de.ibm.com, themann@de.ibm.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, meder@de.ibm.com,
       tklein@de.ibm.com, stefan.roscher@de.ibm.com
Subject: Re: RFC: issues concerning the next NAPI interface
Message-ID: <20070828121617.GA4160@2ka.mipt.ru>
References: <46D2F301.7050105@katalix.com> <20070827.145600.102570576.davem@davemloft.net> <46D3E971.4010909@katalix.com> <200708281348.21302.ossthema@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708281348.21302.ossthema@de.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2007 at 01:48:20PM +0200, Jan-Bernd Themann (ossthema@de.ibm.com) wrote:
> I'm not sure if I understand your approach correctly.
> This approach may reduce the number of interrupts, but it does so
> by blocking the CPU for up to 1 jiffy (that can be quite some time
> on some platforms). So no other application / tasklet / softIRQ type
> can do anything in between. The CPU utilization does not drop at all, 
> and I thought that is one reason why we try to reduce the number of interrupts.

Only NICs interrupts are suposed to be stopped, system will continue to
work as usual, since all others are alive.
Having hrtimer to reshcedule NIC procesing can work only if number of
timer's interrupts are much less than NICs and if rate of the timer's
starts/changes (presumbly in NICs interrupt) is small too, otherwise
having too many NIC interrupts will not gain anything (actually it is
what is supposed to be dropped noticebly).

-- 
	Evgeniy Polyakov
