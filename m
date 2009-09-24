Return-Path: <linux-kernel-owner+w=401wt.eu-S1754062AbZIXO6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbZIXO6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbZIXO6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:58:31 -0400
Received: from fifo99.com ([67.223.236.141]:46746 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070AbZIXO63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:58:29 -0400
Subject: Re: checkpatch as a tool (was Re: [RFC][PATCH] SCHED_EDF
 scheduling class)
From: Daniel Walker <dwalker@fifo99.com>
To: Andy Isaacson <adi@hexapodia.org>
Cc: Joe Perches <joe@perches.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20090923192414.GB20505@hexapodia.org>
References: <1253615424.20345.76.camel@Palantir>
	 <1253625878.6575.34.camel@desktop> <1253628061.20345.173.camel@Palantir>
	 <1253637721.18939.3.camel@laptop> <20090922191117.GB24542@elte.hu>
	 <1253667103.25689.35.camel@desktop>
	 <1253667708.30020.134.camel@Joe-Laptop.home>
	 <1253668299.25689.44.camel@desktop>  <20090923192414.GB20505@hexapodia.org>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 07:58:17 -0700
Message-Id: <1253804297.20648.170.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-23 at 12:24 -0700, Andy Isaacson wrote:
> On Tue, Sep 22, 2009 at 06:11:39PM -0700, Daniel Walker wrote:
> > On Tue, 2009-09-22 at 18:01 -0700, Joe Perches wrote:
> > > I think it'd be more helpful if instead of merely sending
> > > a "hah! checkpatch failure!" email you send the submitter
> > > a gentler nudge and a fixed patch.
> > 
> > I don't say "hah!" like I caught you or something .. I could try to
> 
> It does come across that way sometimes.
> 
> > soften the emails further so that's not the feeling .. As far as sending
> > fixed patches to people it's not really feasible due to the number of
> > patches I would have to send out..
> 
> I'd rather see 10% coverage with useful patches than 100% coverage of
> "there is some problem in this patch but I can't be bothered to say
> what".

Your kind of putting words in my mouth here.. I can be bothered to say
what the errors are, but most people have the tool already. The errors
are also fairly trivial. I'd rather people ran the tool themselves.

> > I could send out delta patches, however, I don't want people to rely
> > on me to fix these issues.. Ideally people would correct them prior to
> > sending the patches out..
> 
> Sure, and checkpatch is useful for that -- and more helper scripts to
> automate the process would be helpful.  For example, extending "git
> send-email" to have an optional "warn about checkpatch failures" would
> be a useful addition, especially if it's not too annoying.  (I find the
> current checkpatch output somewhat annoying, so just including that
> wouldn't be great IMO.)

Yeah, git integration would be nice if it doesn't already exist. I've
never seen that feature tho. git does have a warn on trailing whitespace
tho ..

> I would strongly recommend that you redistribute the effort you're
> putting in, and only send messages where you have non-trivial input to
> the development process.  For example, saying "This patch has checkpatch
> errors.  Please fix the indentation and the EXPORT_SYMBOL errors, and
> move function declarations to foo.h" would be much much more useful than
> "it looks like you have a few style issues".

I could do that.. However, my main annoyance is the style issues. Many
of the patches that I have commented on I've reviewed to find other
issues that could be solved, but often times other than the style issues
the patches don't look all that bad..

> Let's go through a few of your recent checkpatch messages:
> 
> Message-Id: <1252936556.28368.215.camel@desktop>
> > Could you run this through checkpatch also, it looks like you have a few
> > style issues..
> 
> Patch <1252870707-4824-5-git-send-email-felipe.contreras@gmail.com> is a
> strict improvement on the existing code, and changing the comma spacing
> on just these two lines to silence checkpatch would make the file
> inconsistent.  Changing all 12 functionlike #defines in this file would
> be outside the purview of this patch.  You could have done the robotlike
> patch and fixed the issue in this file in the time it would have taken
> to do this analysis, and then you would have seen that the file has far
> worse issues than the trivial ones checkpatch flagged in Felipe's patch.
> 
> Verdict: useless.

At the time, I didn't think people should use the style consistent with
the file. For instance, if you touch a line you should be responsible
for the clean up on that line.. However, I've since stopped asking
people to do that since it could be overwhelming, and there's many times
when people do automatic regex changes which have nothing to do with any
sort of clean up on the lines they have changed ..

> Message-Id: <1252465099.14793.49.camel@desktop>
> > All the lines like the above are all producing checkpatch errors.. It
> > looks like the open brace needs to be up with the equals ..
> 
> Joe is correct in his response, in this case the "error" from checkpatch
> is ignorable.  Your responses in <1252467842.14793.66.camel@desktop> and
> <1252466482.14793.60.camel@desktop> are dismissive of exactly the
> concerns people are raising here, and you badly misstate your case when
> you say
> > I would if this was code in the kernel already, but it's not.
> without apologizing when your mistake was pointed out.
> 
> Verdict: useless, and abrasive in your response to correction.

I was dismissive here, however I still do think those lines deserved the
clean up.. The lines where being altered enough to expose a checkpatch
bug due to the attribute (I later submitted a fix for checkpatch) ..
Also realize that the patch touched several architectures, and it was
attached to a larger patch set which I think would have been the perfect
deliver for that clean up.

> Message-Id: <1253553472.9654.236.camel@desktop>
> One right (and reasonable to say in text although a patch would have
> been equally reasonable, and hardly any more work to generate), one
> wrong.  I strongly wouldn't have bothered to send this message.
> 
> Verdict: mediocre.

I hesitated to send it .. It's often difficult to justify sometimes, but
it's also annoying that people don't catch these trivial things. 

> Message-Id: <1253504435.9654.221.camel@desktop>
> AFAICS you didn't even read the checkpatch output, just saw a lot of
> output and reflexively sent email.  Obviously the 0xA0 is due to some
> sort of editor/mailer issue not a style issue.
> 
> Verdict: useless.

I did read the errors, not all of them however.. Indentation issues can
cause some different types of checkpatch output, which to me didn't
initially point to a mailer problem .. This patch was totally worthless
how it was, so it need attention one way or another.

> Message-Id: <1253326790.6699.38.camel@desktop>
> Reasonable, although you'd do better to lead with the reasonable comment
> and then follow with a mention of chckpatch rather than the other way
> around.
> 
> Verdict: useful.
> 
> Message-Id: <1253293100.7060.46.camel@desktop>
> Whitespace errors in a delta (as opposed to a new submission, especially
> from a new contributor) are rarely worth whingeing about, and in this
> case it's merely duplicating the error on the line above the diff.
> 
> Verdict: mediocre.

Are we talking about the same email from Paul? I had already sent him
some other checkpatch output in another thread, and he thanked for
catching it. So in this case I assumed he wouldn't mine. So I don't feel
too bad about having sent it.

> Message-Id: <1253291944.7060.42.camel@desktop>
> Saying "we use checkpatch.pl" to someone who's been contributing since
> before Git existed is condescending in the extreme -- it'd be bad enough
> to say it to a first-time contributor, but this is just beyond the pale.
> The checkpatch output is fairly useful and clearly Lennart did find the
> reminder useful, but you could have been less abrasive by putting in a
> little more work.
> 
> Verdict: useful.

I usually go by the number of errors I find when I start saying "We" ..
I don't know Lennart at all, and there was no disrespect intended .. I
still think going by the number of errors I find is appropriate, however
I could stop using "We" in terms of putting people on the outside.

> Message-Id: <1253092251.11643.569.camel@desktop>
> davem already gave useful commentary 2 hours before your mail, so I
> wouldn't have bothered to send your mail.  If you do send this, it would
> be more useful to say "You seem to use spaces for indentation
> everywhere, could you fix that and run checkpatch before re-submitting".
> 
> Verdict: technically useful but socially abrasive.

I don't see anything abrasive in that email .. Infact I think your
re-write above is more abrasive than what I wrote .. I did however,
overlook Dave's earlier comments which isn't exactly unlikely to happen
given daily LKML traffic .. I'll try to be mindful of that in the
future.

> 
> In summary, of 8 messages reviewed that's 3 completely useless messages,
> 2 of middling use, and 3 useful ones.  Of that, two or three times you
> were strongly abrasive IMO.

I think maybe your overstating things a bit .. For instance, "strongly
abrasive" for someone that was not intending to be abrasive at all seems
like a stretch ..

The one repeating Dave's comments could have been avoided, and the first
one your brought up to Felipe maybe shouldn't have been sent at all, but
all did do some good since Felipe was happy to send additional cleanups.

> That's about the proportion I've anecdotally observed in your checkpatch
> mails (a bit more positive than I would have guessed actually).  If
> you'd sent only three of those eight messages, I think you'd be getting
> much less negative feedback, and you'd have had 166% more time to spend
> on each message.

Having sent fewer emails certainly would draw less feedback positive or
negative.. I don't think the negative percentage would have changed tho,
since I feel that's the nature of the list.

> FWIW, I think you have a valuable contribution but it's being drowned
> out by your errors and non-useful messages.  Please be more careful to
> not send erroneous messages, contribute patches to address (even just
> some of!) the errors you flag, graciously acknowledge your errors when
> you're called on them (and learn from the corrections!), and perhaps
> people will lay off on you.

I appreciate the comments, and it was helpful .. BTW, I've contributed
tons of pure checkpatch clean ups in the past .. So it's not like I'm
just asking for people to clean up stuff without having done these types
of clean ups myself.

Daniel

