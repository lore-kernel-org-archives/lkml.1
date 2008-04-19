Return-Path: <linux-kernel-owner+w=401wt.eu-S1761639AbYDSDJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761639AbYDSDJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 23:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671AbYDSDJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 23:09:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48599 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412AbYDSDJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 23:09:41 -0400
Date: Fri, 18 Apr 2008 23:09:38 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       sandmann@redhat.com, pq@iki.fi, srostedt@redhat.com
Subject: Re: [PATCH 1/5] ftrace: simple clean ups
In-Reply-To: <20080418131535.dbcd315d.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0804182309010.19025@gandalf.stny.rr.com>
References: <20080418200538.788522018@goodmis.org> <20080418200849.968033091@goodmis.org>
 <20080418131535.dbcd315d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 18 Apr 2008, Andrew Morton wrote:

> On Fri, 18 Apr 2008 16:05:39 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > -	r = snprintf(buf, 64, "%ld\n",
> > +	r = snprintf(buf, sizeof(buf), "%ld\n",
>
> If you use scnprintf here

Cool, I didn't know of that function.

>
> >  		     *ptr == (unsigned long)-1 ? -1 : nsecs_to_usecs(*ptr));
> > -	if (r > 64)
> > -		r = 64;
> > +	if (r > sizeof(buf))
> > +		r = sizeof(buf);
>
> This becomes a cant-happen (I think).

Yep it does. New patch on the way.

Thanks,

-- Steve

