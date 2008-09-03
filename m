Return-Path: <linux-kernel-owner+w=401wt.eu-S1755160AbYICA2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbYICA2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 20:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754172AbYICA2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 20:28:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60533
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754151AbYICA2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 20:28:07 -0400
Date: Tue, 02 Sep 2008 17:28:01 -0700 (PDT)
Message-Id: <20080902.172801.12895688.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: dusanc@gmail.com, romieu@fr.zoreil.com, hancockr@shaw.ca,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       bridge@lists.linux-foundation.org
Subject: Re: [RFC] bridge: STP timer management range checking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080831104309.780cc01f@extreme>
References: <a08621850808310151o143845h195a8658d02270d9@mail.gmail.com>
	<20080831100537.6929c51e@extreme>
	<20080831104309.780cc01f@extreme>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Sun, 31 Aug 2008 10:43:09 -0700

> The Spanning Tree Protocol timers need to be set within certain boundaries
> to keep the internal protocol engine working, and to be interoperable.
> This patch restricts changes to those timers to the values defined in IEEE 802.1D
> specification.
> 
> The only exception to the standards are:
>   * if STP is disabled allow forwarding delay to be turned off
>   * allow wider range of ageing timer since this isn't directly part of
>     STP, and setting it to zero allows for non-remembering bridge.
> 
> Warning: this may cause user backlash since apparently working but standards
>   conforming configurations will get configuration errors that they didn't
>   see before.

I don't think we can really add these kinds of restrictions wholesale
like this.

And the user is reporting that using brctl to turn off STP doesn't
appear to actually turn off STP and thus fix all of the crazy
ksoftirqd high cpu load problems.

So what we need to do is resolve the user configuration issue that is
causing this problem to begin with.
