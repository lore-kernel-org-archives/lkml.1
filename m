Return-Path: <linux-kernel-owner+w=401wt.eu-S934318AbZD3SAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934318AbZD3SAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 14:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754699AbZD3SAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 14:00:32 -0400
Received: from vpnflf.ccur.com ([12.192.68.2]:42327 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755088AbZD3SAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 14:00:31 -0400
Date: Thu, 30 Apr 2009 14:00:12 -0400
From: Joe Korty <joe.korty@ccur.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "venkatesh.pallipadi@intel.com" <venkatesh.pallipadi@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clear irq pending when bypassing it
Message-ID: <20090430180011.GB28139@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20090430161506.GA2636@typhoon.ccur.com> <m11vra13z0.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m11vra13z0.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 12:49:39PM -0400, Eric W. Biederman wrote:
> Joe Korty <jak@typhoon.ccur.com> writes:
> 
> > IRQ_MOVE_PENDING must be cleared whenever it is bypassed.
> >
> > Otherwise, we risk an old, pending affinity change
> > overtaking and erasing a more recent affinity change that
> > had been directly applied (eg, IRQ_MOVE_PCNTXT mode).
> 
> When can this happen?

Probably doesn't happen.  AFAIK, each IRQ is either fully MSI
or non-MSI.  The MSI IRQs will always use IRQ_MOVE_PCNTXT and
the non-MSI's will never use IRQ_MOVE_PCNTXT.  Thus no collision.

It could only happen if it was possible for a MSI and non-MSI
device to share an IRQ.

Joe
