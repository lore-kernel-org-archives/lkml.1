Return-Path: <linux-kernel-owner+w=401wt.eu-S1755203AbZCRVjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbZCRVjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 17:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbZCRVi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 17:38:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46258
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751644AbZCRVi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 17:38:58 -0400
Date: Wed, 18 Mar 2009 14:38:44 -0700 (PDT)
Message-Id: <20090318.143844.173112261.davem@davemloft.net>
To: vernux@us.ibm.com
Cc: andi@firstfloor.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: High contention on the sk_buff_head.lock
From: David Miller <davem@davemloft.net>
In-Reply-To: <49C16349.9030503@us.ibm.com>
References: <87prge1rhu.fsf@basil.nowhere.org>
	<20090318.140340.55290859.davem@davemloft.net>
	<49C16349.9030503@us.ibm.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vernon Mauery <vernux@us.ibm.com>
Date: Wed, 18 Mar 2009 14:10:33 -0700

> David Miller wrote:
> > From: Andi Kleen <andi@firstfloor.org>
> > Date: Wed, 18 Mar 2009 21:54:37 +0100
> > 
> >> But then again I'm not sure it's  worth it if the problem only
> >> happens in out of tree RT.
> > The list of problems that only show up with the RT kernel seems to be
> > constantly increasing, but honestly is very surprising to me.
> > I don't understand why we even need to be concerned about this stuff
> > upstream, to be honest.
> > Please reproduce this in the vanilla kernel, then get back to us.
> 
> Huh? The numbers that I posted *were* from the vanilla kernel. I ran
> the 2.6.29-rc8 kernel with lock_stat enabled.  The lock contention
> happens on the same lock in both vanilla and -rt, it just happens
> to be more pronounced in the -rt kernel because of the double context
> switches that the sleeping spinlock/rt-mutexes introduce.

And the double context switches are probably also why less
natural batching and locality are achieved in the RT kernel.

Isn't that true?
