Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862Ab0BYCnF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 21:43:05 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:64746 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758782Ab0BYCnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 21:43:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=R7dBcJcdWy7TS/ASbblJLk6Q1HyAfsqEzBW+BX6hmdBTmdGQJOdmy+qpg/8AmC++BH
         J0KBE9CzKKajI4Sv2UZ7RNTawGqxT4Ypg3HIJqPVlzFIXErdLMFn0Gu4SUhpRStrqdcZ
         F/n1b8vcGkEKV5IjFFs5U2CyiP/Y3D/X1xIiw=
Date: Thu, 25 Feb 2010 03:43:00 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com
Subject: Re: [PATCH 08/12] perf: export some syscall metadata
Message-ID: <20100225024259.GD7491@nowhere>
References: <1264580883-15324-1-git-send-email-tzanussi@gmail.com> <1264580883-15324-9-git-send-email-tzanussi@gmail.com> <20100223214445.GF5357@nowhere> <1266991243.6427.44.camel@tropicana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266991243.6427.44.camel@tropicana>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 12:00:43AM -0600, Tom Zanussi wrote:
> Re event injection - I don't know that much about it, but if it can be
> used for this, could it also be applied to the rest of the trace and
> header data too?  If so, that would enable 'live mode' tracing.  I
> already have a working prototype that does it by converting all those
> things into synthesized pseudo-events, but it would be nicer to use the
> event injection framework instead, if I understand it correctly...


I'm not sure what you mean about live mode tracing. But yeah this
about synthetizing pseudo-events. The purpose is to catchup with
"past events" or "dead events".

The first trial was for lock_init events. Lock init events send
the address of the lock plus its name, so that subsequent lock
events (lock acquire, lock_release) can just send the address
in the event and not the name which can then be retrieved
from past lock_init events.

One problem though: when we enable the lock_init event, we
only catch the new locks created. So we need the previously
registered locks. There may be severals ways to do that: using
a perf ioctl or so, it's still in discussion.

But then for syscalls we would have a kind of dead events
catching up by asking the kernel to send us the nr:name
pairs.

