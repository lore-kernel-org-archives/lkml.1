Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbZDVIKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbZDVIKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 04:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbZDVIJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 04:09:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44422 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897AbZDVIJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 04:09:45 -0400
Date: Wed, 22 Apr 2009 10:09:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing/filters: disallow newline as delimeter
Message-ID: <20090422080928.GA8562@elte.hu>
References: <49ED8DD2.2070700@cn.fujitsu.com> <49ED8DFD.9070909@cn.fujitsu.com> <20090421095705.GA15448@elte.hu> <49ED9AC2.9000507@cn.fujitsu.com> <20090421100722.GA18486@elte.hu> <49ED9C91.4070201@cn.fujitsu.com> <20090421101619.GA19660@elte.hu> <1240377698.6711.61.camel@tropicana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240377698.6711.61.camel@tropicana>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tom Zanussi <tzanussi@gmail.com> wrote:

> On Tue, 2009-04-21 at 12:16 +0200, Ingo Molnar wrote:
> > * Li Zefan <lizf@cn.fujitsu.com> wrote:
> > 
> > > Ingo Molnar wrote:
> > > > * Li Zefan <lizf@cn.fujitsu.com> wrote:
> > > > 
> > > >> Ingo Molnar wrote:
> > > >>> * Li Zefan <lizf@cn.fujitsu.com> wrote:
> > > >>>
> > > >>>> I guess because user input is often ended with '\n' (like "echo 
> > > >>>> xxx"), thus '\n' is used as a delimeter besides ' ', but we can 
> > > >>>> just strip tailing spaces.
> > > >>> Hm, how about:
> > > >>>
> > > >>> ( echo 'x'
> > > >>>   echo '|| y' ) > filter
> > > >>>
> > > >>> type of scripts? Shouldnt the parser be permissive in general?
> > > >>>
> > > >> This patch doesn't forbid this usage: ;)
> > > >>
> > > >> ( echo 'parent_comm == a'
> > > >>   echo '|| parent_comm == b' ) > filter
> > > >>
> > > >> This patch does forbid this usage:
> > > >>
> > > >> ( echo 'parent_comm'
> > > >>   echo '=='
> > > >>   echo 'a' ) > filter
> > > > 
> > > > Same argument though, no?
> > > > 
> > > 
> > > Then I have no strong opinion on this. I'm fine to drop this patch.
> > 
> > I've applied the other two - no strong opinion either about this 
> > patch. Tom, what do you think? (there's also some new parser in the 
> > works i suspect)
> 
> I think it works ok as it is, so dropping this patch would be fine 
> with me.
> 
> I am working on a new parser; I'd hoped to have it finished by 
> now, but I seem to be continually distracted lately. :-( At this 
> point I have a parser that basically works; the main thing it 
> still needs and what I'm working on now is a way to allow it to be 
> easily extended to support special-case handling for special types 
> e.g. if a predicate field refers to something that's a dev_t, the 
> user should be able to specify 'device == /dev/sda' or 'device == 
> sda' or 'device == (8,1)' or 'device == 8:1', so it should be 
> relatively easy to add that kind of support to the parser when 
> there's a need for it.
> 
> Once that's done, I'll hook it all up and post it as soon as I 
> can, at the end of the week hopefully...

Nice! :-)

If your current lineup works you might want to post that straight 
away even without the type extensions, if you think there's value in 
testing/reviewing those bits independently. It generally works 
better to have gradual patches. (we can find bugs sooner, review is 
easier, etc.)

	Ingo
