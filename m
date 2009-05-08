Return-Path: <linux-kernel-owner+w=401wt.eu-S1754517AbZEHL2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbZEHL2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 07:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006AbZEHL2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 07:28:03 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:48884 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbZEHL2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 07:28:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UUVtqyuBDrBqE8NORxMK1wCuMEdbdGqUdNAPvi9cKlXZhMOOeZ0yeafXPR/vkb18+L
         1GIdixeKUS+ISEqINaalBB3aKfJoEK3rRNslgstx3erhvKzIPYYemfrw90cggYhpla//
         7LUhtXPusKX5NuQenbWAnP+oxo8UHOT5789CE=
Date: Fri, 8 May 2009 13:27:59 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing/events: clean up for ftrace_set_clr_event()
Message-ID: <20090508112758.GD6417@nowhere>
References: <4A03998E.3020503@cn.fujitsu.com> <20090508105013.GA6417@nowhere> <4A041478.5070401@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A041478.5070401@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 07:16:08PM +0800, Li Zefan wrote:
> Frederic Weisbecker wrote:
> > On Fri, May 08, 2009 at 10:31:42AM +0800, Li Zefan wrote:
> >> Add a helper function __ftrace_set_clr_event(), and replace some
> >> ftrace_set_clr_event() calls with this helper, thus we don't need any
> >> kstrdup() or kmalloc().
> >>
> >> As a side effect, this patch fixes an issue in self tests code, which is
> >> similar to the one fixed in commit d6bf81ef0f7474434c2a049e8bf3c9146a14dd96
> >> ("tracing: append ":*" to internal setting of system events")
> >>
> >> It's a small issue and won't cause any bug in fact, but we should do things
> >> right anyway.
> >>
> >> [ Impact: clean up ]
> > 
> > If this fixes an issue like you described, then it's more than a cleanup :)
> > 
> 
> That issue causes no bug, and that's why I call it a cleanup.
> 
> How about (mainly stealed from commit d6bf81ef0f7474434c2a049e8bf3c9146a14dd96):
> 
> [ Impact: prevent accidental enabling of events with same name as a system in self tests ]
> 
> But it excceeds 80 char..
> 
> I sometimes feel it hard to write Impact line (one of the reason is my limit
> English skill). I've explained the impact of this patch in detail, but I'm
> still required to add a one-line summary. :(


Well, I also find hard to write straightforward and good matching
impact lines.
And I'm certainly not well suited to give any advices about how
to write good impact lines.

But IMHO you can sum up your above impact line.

[ Impact: prevent spurious events enabling in tracing selftests ]

They usually don't need more details, those details can be placed in
the changelog. It's more about the general pratical impact, not a
detailed one.

Frederic.


> > 
> ...
> >> +		if (event && strcmp(event, call->name) != 0)
> >> +			continue;
> > 
> > 
> > Neat: You can simply use !strcmp(...)
> > 
> 
> Actually it's arguable which is better, and both styles are used in kernel code.
> 
> And that 'if (!ptr)' vs 'if (ptr == NULL)'..
> 

