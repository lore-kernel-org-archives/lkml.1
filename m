Return-Path: <linux-kernel-owner+w=401wt.eu-S1759848AbZE2Nco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759848AbZE2Nco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 09:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758291AbZE2Nch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 09:32:37 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:17624 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757677AbZE2Ncg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 09:32:36 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 2/2] UBIFS: start using hrtimers
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, linux-fsdevel@vger.kernel.org,
       Steven Rostedt <srostedt@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <20090529150944.8912.95076.sendpatchset@localhost.localdomain>
References: <20090529150929.8912.33879.sendpatchset@localhost.localdomain>
	 <20090529150944.8912.95076.sendpatchset@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 29 May 2009 15:32:37 +0200
Message-Id: <1243603957.23657.217.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-29 at 18:09 +0300, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Subject: [PATCH 2/2] UBIFS: start using hrtimers
> 
> UBIFS uses timers for write-buffer write-back. It is not
> crucial for us to write-back exactly on time. We are fine
> to write-back a little earlier or later. And this means
> we may optimize UBIFS timer so that it could be groped
> with a close timer event, so that the CPU would not be
> waken up just to do the write back. This is optimization
> to lessen power consumption, which is important in
> embedded devices UBIFS is used for.
> 
> hrtimers have a nice feature: they are effectively range
> timers, and we may defind the soft and hard limits for
> it. Standard timers do not have these feature. They may
> only be made deferrable, but this means there is effectively
> no hard limit. So, we will better use hrtimers.
> 
> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> ---

Seems sane enough from a hrtimer POV, but isn't this already
functionality that the VFS/pdflush provide?

