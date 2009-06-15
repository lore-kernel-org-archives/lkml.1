Return-Path: <linux-kernel-owner+w=401wt.eu-S1758302AbZFOPIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302AbZFOPIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754854AbZFOPIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:08:23 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:37177 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752467AbZFOPIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:08:22 -0400
Date: Mon, 15 Jun 2009 11:05:42 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       lizf@cn.fujitsu.com, mingo@elte.hu, npiggin@suse.de, yinghai@kernel.org,
       benh@kernel.crashing.org
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
In-Reply-To: <1245077891.23207.48.camel@penberg-laptop>
Message-ID: <alpine.DEB.1.10.0906151101580.23995@gentwo.org>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>  <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>  <alpine.DEB.1.10.0906121317140.23840@gentwo.org>  <Pine.LNX.4.64.0906141011280.8507@melkki.cs.Helsinki.FI> 
 <alpine.DEB.1.10.0906151051240.19931@gentwo.org> <1245077891.23207.48.camel@penberg-laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009, Pekka Enberg wrote:

> > Dont do it there. Only modify the slow path.
> >
> > Look at __might_sleep(). It already has an exception for system_state !=
> > RUNNING. If it still triggers then add to the condition there.
>
> But does this matter? When the debugging options are turned off, there
> are no users for "real_gfp" and thus GCC optimizes everything away. For
> debugging configs, the extra cacheline load doesn't matter, does it?

It cleaner to have the fastpath as small as possible. Having unused
variables in there is a bit confusing.

Also the path is performance critical. That may not matter for the debug
case in some sitiations. But there are people that keep the debugging
options on. Better to limit the impact as much as possible.

And the "extra cacheline load does not matter" reasoning can only be
applied so many times. An extra cacheline load increases the cache foot
print of the fast path after all.





