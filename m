Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980AbYKJRR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbYKJRR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 12:17:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbYKJRRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 12:17:21 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:30158 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977AbYKJRRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 12:17:20 -0500
Date: Mon, 10 Nov 2008 09:16:02 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Bart Van Assche" <bart.vanassche@gmail.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Dave Young" <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] C99 initializers for DEFINE_RATELIMIT_STATE()
Message-Id: <20081110091602.d5709c12.randy.dunlap@oracle.com>
In-Reply-To: <e2e108260811100443j18a6353cj8d47ee3f1f8bec1@mail.gmail.com>
References: <200811042114.48495.bart.vanassche@gmail.com>
	<e2e108260811100443j18a6353cj8d47ee3f1f8bec1@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010203.49186C77.0120:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2008 13:43:24 +0100 Bart Van Assche wrote:

> Could someone please be so kind to ACK the patch below, NAK it or tell
> me whether I should send the patch below to someone else ?
> 
> Thanks,
> 
> Bart.
> 
> On Tue, Nov 4, 2008 at 9:14 PM, Bart Van Assche
> <bart.vanassche@gmail.com> wrote:
> > A few months ago (July 25, 2008) the printk ratelimiting code has been
> > rewritten. This patch added a.o. the new macro DEFINE_RATELIMIT_STATE(). The
> > patch below converts the initializers in that macro to C99 style.
> >
> > For more information about the printk ratelimiting rewrite, see also commit
> > 717115e1a5856b57af0f71e1df7149108294fc10
> > (http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=commit;h=717115e1a5856b57af0f71e1df7149108294fc10).
> >
> > Impact: cleanup, no functionality changed.
> >
> > Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
> >
> > diff --git a/include/linux/ratelimit.h b/include/linux/ratelimit.h
> > index 18a5b9b..61cc908 100644
> > --- a/include/linux/ratelimit.h
> > +++ b/include/linux/ratelimit.h
> > @@ -13,8 +13,9 @@ struct ratelimit_state {
> >        unsigned long begin;
> >  };
> >
> > -#define DEFINE_RATELIMIT_STATE(name, interval, burst)          \
> > -               struct ratelimit_state name = {interval, burst,}
> > +#define DEFINE_RATELIMIT_STATE(name, interval_value, burst_value)      \
> > +       struct ratelimit_state name =                                   \
> > +               { .interval = (interval_value), .burst = (burst_value) }
> >
> >  extern int __ratelimit(struct ratelimit_state *rs);

I thought that Andrew would pick it up.

Nit:  I would put the .interval = ... and .burst = ... on separate lines.

Anyway,
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks,
---
~Randy
