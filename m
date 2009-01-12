Return-Path: <linux-kernel-owner+w=401wt.eu-S1756896AbZALTem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896AbZALTem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 14:34:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639AbZALTed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 14:34:33 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:37401 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbZALTec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 14:34:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GwzYj76cE1RYy21R/tjz/ehaNWxHuLpDxh0RB8BP7tX3Ai/ScXHZsbqsh6pzaIovTC
         8Uh9m86HBpAIioPJ8Z6wBqR0EQ/lQnPUB5uSAxvIJfeytD/rKbzIlFFA5kGjlyaOIa3q
         hGK3czA2iqH360lHfTElQ0iSJGG19l0psWrbw=
Date: Mon, 12 Jan 2009 20:34:26 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: checkpatch warning of struct indentation
Message-ID: <20090112193425.GA5267@nowhere>
References: <alpine.DEB.1.10.0901121253350.22796@gandalf.stny.rr.com> <c62985530901121009h372c805dj14c748c8f266235d@mail.gmail.com> <alpine.DEB.1.10.0901121323000.22796@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901121323000.22796@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 01:35:43PM -0500, Steven Rostedt wrote:
> 
> On Mon, 12 Jan 2009, Fr?d?ric Weisbecker wrote:
> 
> > 2009/1/12 Steven Rostedt <rostedt@goodmis.org>:
> > >
> > > Hi,
> > >
> > > I'm now seeing the following warnings from checkpatch:
> > >
> > > #325: FILE: kernel/trace/trace_stat.c:21:
> > > +       void                    *stat;
> > >
> > > ERROR: "foo     *bar" should be "foo *bar"
> > > #334: FILE: kernel/trace/trace_stat.c:27:
> > > +       struct tracer_stat      *ts;
> > >
> > > ERROR: "foo             *bar" should be "foo    *bar"
> > > #337: FILE: kernel/trace/trace_stat.c:30:
> > > +       struct dentry           *file;
> > 
> > 
> > Oh my patch :-)
> > Yeah I had the same errors when I checked it. I ignored them because
> > I because I remembered checkpatch.pl didn't warn about such things before.
> > And it seems to warn about such statements since very recently...
> 
> Heh, I should have CC'd you on this complaint ;-)
> 
> Yeah, this is a new warning and since we do a lot of these types of
> indentation, and they are marked as "ERROR", I would like to see these go 
> away. Perhaps they need to test for parenthesis, so:
> 
>  int func(foo		*bar)
> 
> gets caught.
> 
> 
> [off topic, funny English grammar]
> 
> I noticed that you said:
> 
>    And it seems to warn about such statements since very recently
> 
> This sounds strange. I know in German (and I know you are not German, but 
> it's what I have most experience with) the word "seit" gets translated 
> into "since" for such statements as above. A lot of Germans that I know 
> make this funny sounding phrase. I would have written it like:
> 
>    And, recently, it seems to warn about such statements.
> 
> Don't take this as a criticism. I'm the last person to criticize anyone's 
> grammar. For being an English speaking native, my grammar sucks ;-)
> And your statement may indeed be correct grammar. It just sounds a little
> funny to me.
> 
> In a lot of cases, (for Germans) "seit" can correctly be translated into
> "since" but there are times that it just sounds funny.
> 
> A common phrase from Germans are:
> 
>   I've been doing this since three years.
> 
> Just an observation, carry on ;-)
> 
> -- Steve
> 


Hehe. Yes, I always hesitate when I have to talk about elapsed time,
especially when it is an uncertain time...
And French/German are often confused with "since" and "for" while in
french we have only "depuis" and in german: "seit"...

Thanks, I'm always glad to be corrected in my english, hoping
it will be fixed by the time... :-)
 
> > 
> > 
> > > This is for:
> > >
> > > struct tracer_stat_session {
> > >        struct list_head        session_list;
> > >        struct tracer_stat      *ts;
> > >        struct list_head        stat_list;
> > >        struct mutex            stat_mutex;
> > >        struct dentry           *file;
> > > };
> > >
> > > Which looks a hell of a lot better than:
> > >
> > > struct tracer_stat_session {
> > >        struct list_head session_list;
> > >        struct tracer_stat *ts;
> > >        struct list_head stat_list;
> > >        struct mutex stat_mutex;
> > >        struct dentry *file;
> > > };
> > >
> > > We probably do not want to warn on such things.
> > >
> > > -- Steve
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
> > >
> > 
> > 

