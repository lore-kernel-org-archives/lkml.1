Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbYH1SnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbYH1SnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 14:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbYH1SnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 14:43:04 -0400
Received: from ik-out-1112.google.com ([66.249.90.183]:64529 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbYH1SnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 14:43:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=OuZtuVg9trnMldBVAL520eABnkJ8HIND7xsfAaZgLL7Z8S8k6DWjyZA6g4DFa/210c
         vGbSheb1OaOXA+dhtcvOdIIWmxfIvikmDTPPjmx5vKQBsI4acB8CiwD0H3rXsjDQWfyi
         b/JW3a/eu6aQilHJddlziIa49dKWetyTPgPsE=
Date: Thu, 28 Aug 2008 21:42:56 +0300
From: Pekka Paalanen <pq@iki.fi>
To: "=?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker" <fweisbec@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Tracing/ftrace: Adds a marker to allow user comments
Message-ID: <20080828214256.296e34ec@daedalus.pq.iki.fi>
In-Reply-To: <c62985530808280304x389cb958vff24b5d11f22d35c@mail.gmail.com>
References: <48B1D5CA.8000607@gmail.com>
	<c62985530808270259i491e32e2r40adf719e32e4086@mail.gmail.com>
	<20080827212130.4b8365a8@daedalus.pq.iki.fi>
	<c62985530808280304x389cb958vff24b5d11f22d35c@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2008 11:04:36 +0100
"Frédéric Weisbecker" <fweisbec@gmail.com> wrote:

> 2008/8/27 Pekka Paalanen <pq@iki.fi>:
> >
> > tracers. I would also like to be able to have e.g. mmiotrace_marker(),
> > which would have the same signature as ftrace_printk(), but is a no-op if
> > mmiotrace is not active. So, we could have an __ftrace_vprintk() to make
> > writing such wrappers easy. And the wrappers could be #ifdef'd away, if
> > the corresponding tracer is not built.
> 
> I like your idea of a ftrace_vprintk wrapper.
> But actually I'm questioning about the fact that the tracing api
> itself is not generic enough.

I think making it more modular would be nice, but I'm not really working
on the generic parts.

> And (always IMHO) I think that functions like __trace_mmiotrace_rw()
> shouldn't be located on trace.c but implemented on the appropriate
> tracer (in this example: trace_mmiotrace.c).

I feel the same.

> > I recall somewhere mentioning, that one shouldn't leave ftrace_printk's
> > lying around in "final" code, so I'm not sure how people feel about this
> > wrapping idea, especially when e.g. mmiotrace is hoped to be built-in by
> > default. OTOH, I don't think in-tree drivers and stuff want to use them,
> > so they would be mostly offered for out-of-tree modules
> > (reverse-engineering) and developers (debugging). That makes me wonder
> > if they would be accepted (as exported symbols).
> 
> Yes I think such a function should really be exported. For example
> using mmiotrace on a module and beeing able to signal the fact that we
> are entering the "foo" function seems to me very useful. It's
> important to know where we are in all these IO for debugging....

Yes, but the atmosphere is that if there are no users in-tree, the feature
gets kicked, out-of-tree users or no. That's the reason mmiotrace went
in-tree in the first place. So, to get that stuff exported, we might need
in-tree users, I believe.


Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
