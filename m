Return-Path: <linux-kernel-owner+w=401wt.eu-S1760383AbYJJPXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760383AbYJJPXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 11:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757024AbYJJPXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 11:23:31 -0400
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:47352 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757425AbYJJPXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 11:23:30 -0400
Message-ID: <48EF7211.2000303@cs.columbia.edu>
Date: Fri, 10 Oct 2008 11:17:37 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Daniel Lezcano <dlezcano@fr.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       arnd@arndb.de, Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 1/2] Track in-kernel when we expect	checkpoint/restart
 to work
References: <20081009190405.13A253CB@kernel>	<1223626834.8787.8.camel@localhost.localdomain>	<48EF144D.1050906@fr.ibm.com> <20081010145934.GF11695@elte.hu>
In-Reply-To: <20081010145934.GF11695@elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:
> * Daniel Lezcano <dlezcano@fr.ibm.com> wrote:
> 
>>> By the way, why don't you introduce the reverse operation ?
>> I think implementing the reverse operation will be a nightmare, IMHO 
>> it is safe to say we deny checkpointing for the process life-cycle 
>> either if the created resource was destroyed before we initiate the 
>> checkpoint.
> 
> it's also a not too interesting case. The end goal is to just be able to 
> checkpoint everything that matters - in the long run there simply wont 
> be many places that are marked 'cannot checkpoint'.
> 
> So the ability to deny a checkpoint is a transitional feature - a 
> flexible CR todo list in essence - but also needed for 
> applications/users that want to rely on CR being a dependable facility.
> 
> It would be bad for most of the practical usecases of checkpointing to 
> allow the checkpointing of an app, just to see it break on restore due 
> to lost context.

Actually it need not wait for restore to fail - it can fail during the
checkpoint, as soon as the unsupported feature is encountered.

Adding that flag of what you suggest will help make it more vocal and
obvious that a feature isn't supported, even without the user actually
trying to take a checkpoint. I  like that I idea.

Oren.

> 
> 	Ingo
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
