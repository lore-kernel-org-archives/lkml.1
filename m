Return-Path: <linux-kernel-owner+w=401wt.eu-S1759370AbZJKMRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370AbZJKMRO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 08:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbZJKMRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 08:17:12 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:47536 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbZJKMRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 08:17:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=heTXBmyd08ERAUiL8APGTPdXDv6cVonThyj4ZbJmr/+gwXXfFGBBZTHrhhlk8i2PbN
         KZjZXKXRCCYvL5kanU7/TkseUsr7i+Y8jq47grH5UYGDg/G8gWLk068cWDCs8XqJyJ9m
         loE7rs0u9cZhLZWw0HZONMfZwIZNJTAC3rMOc=
Date: Sun, 11 Oct 2009 14:16:32 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tom Zanussi <tzanussi@gmail.com>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org, lizf@cn.fujitsu.com
Subject: Re: [RFC][PATCH 5/9] perf trace: Add Perl scripting support
Message-ID: <20091011121630.GC4901@nowhere>
References: <1254809398-8078-1-git-send-email-tzanussi@gmail.com> <1254809398-8078-6-git-send-email-tzanussi@gmail.com> <20091006130059.GD15320@elte.hu> <1254888565.28917.135.camel@tropicana> <20091007141332.GA21320@infradead.org> <1254974493.6841.17.camel@tropicana> <20091011085846.GF14995@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091011085846.GF14995@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 11, 2009 at 10:58:46AM +0200, Ingo Molnar wrote:
> 
> * Tom Zanussi <tzanussi@gmail.com> wrote:
> 
> > On Wed, 2009-10-07 at 10:13 -0400, Christoph Hellwig wrote:
> > > On Tue, Oct 06, 2009 at 11:09:25PM -0500, Tom Zanussi wrote:
> > > > > I think we also want to have a 'perf -s *' kind of thing to get a list 
> > > > > of all available language modules.
> > > > > 
> > > > 
> > > > I knew somebody would point that out (and suggest a better way ;-)  That
> > > > all makes sense - I'll make these changes in the next version.
> > > 
> > > I'm a bit worried about linking two million scripting language into the
> > > main perf binary.  Can't we just have seaprate perlperf / pythonperf,
> > > rubyperf, awkperf binaries that only contain the scripting support?
> > 
> > Yeah, that's a good point. [...]
> 
> No, we want to keep a single core binary, it has many advantages. Git 
> has gone through a very painful conversion from many spread out git-* 
> commands back into a central binary. So we avoided that mistake in perf 
> from the get go. We are not going to add separate perf-* commands.
> 
> ad-hoc extensions using separate perf-* scripts are fine of course and i 
> use that myself. But once a facility is part of core perf it wants to 
> move into the binary. Especially something as central as scripting 
> support.
> 
> Thanks,
> 
> 	Ingo


But I think we may want to have some integrated scripts that can
play the role of subcommands when it comes to process
particular trace events. Because this is just about reading binary
traces and put them in a shape that makes sense wrt to the targeted events.

So I think in this particular area we should better choose scripting
languages. If we limit us to the C in this field, we restrict us
in a slow development.

Re-implemeting the workqueue profiler in Python/Perl/Whatever would
take several hours. In C it's several days, with potential security
holes inside...

