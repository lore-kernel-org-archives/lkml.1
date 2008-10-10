Return-Path: <linux-kernel-owner+w=401wt.eu-S1762000AbYJJQfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762000AbYJJQfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 12:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759212AbYJJQex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 12:34:53 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:60219 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758428AbYJJQew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 12:34:52 -0400
Subject: Re: [RFC][PATCH 1/2] Track in-kernel when we
	expect	checkpoint/restart to work
From: Greg Kurz <gkurz@fr.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Ingo Molnar <mingo@elte.hu>, Daniel Lezcano <dlezcano@fr.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <48EF7211.2000303@cs.columbia.edu>
References: <20081009190405.13A253CB@kernel>
	 <1223626834.8787.8.camel@localhost.localdomain>
	 <48EF144D.1050906@fr.ibm.com> <20081010145934.GF11695@elte.hu>
	 <48EF7211.2000303@cs.columbia.edu>
Content-Type: text/plain
Date: Fri, 10 Oct 2008 18:34:49 +0200
Message-Id: <1223656489.10017.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-10 at 11:17 -0400, Oren Laadan wrote:
> 
> Ingo Molnar wrote:
> > * Daniel Lezcano <dlezcano@fr.ibm.com> wrote:
> > 
> >>> By the way, why don't you introduce the reverse operation ?
> >> I think implementing the reverse operation will be a nightmare, IMHO 
> >> it is safe to say we deny checkpointing for the process life-cycle 
> >> either if the created resource was destroyed before we initiate the 
> >> checkpoint.
> > 
> > it's also a not too interesting case. The end goal is to just be able to 
> > checkpoint everything that matters - in the long run there simply wont 
> > be many places that are marked 'cannot checkpoint'.
> > 
> > So the ability to deny a checkpoint is a transitional feature - a 
> > flexible CR todo list in essence - but also needed for 
> > applications/users that want to rely on CR being a dependable facility.
> > 
> > It would be bad for most of the practical usecases of checkpointing to 
> > allow the checkpointing of an app, just to see it break on restore due 
> > to lost context.
> 
> Actually it need not wait for restore to fail - it can fail during the
> checkpoint, as soon as the unsupported feature is encountered.
> 

Of course, bad things must be spotted at checkpoint time ! :)

> Adding that flag of what you suggest will help make it more vocal and
> obvious that a feature isn't supported, even without the user actually
> trying to take a checkpoint. I  like that I idea.
> 

This flag is weak... testing it gives absolutly no hint whether the
checkpoint may succeed or not. As it is designed now, a user can only be
aware that checkpoint is *forever* denied. I agree that it's only useful
as a "flexible CR todo list".

In the long run, if there are still things that can prevent checkpoint
from being consistent, they will have to be checked at checkpoint time.

Greg.


