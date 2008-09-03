Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896AbYICAEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbYICAEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 20:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753784AbYICAEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 20:04:11 -0400
Received: from cnc.isely.net ([64.81.146.143]:46153 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090AbYICAEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 20:04:10 -0400
Date: Tue, 2 Sep 2008 19:04:07 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Michael Krufky <mkrufky@linuxtv.org>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [v4l-dvb-maintainer] [PULL] http://linuxtv.org/hg/~mcisely/pvrusb2
In-Reply-To: <48BD4DCE.9020507@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0809020933001.11377@cnc.isely.net>
References: <Pine.LNX.4.64.0808312020060.16986@cnc.isely.net>
 <20080902061821.4df5cba4@mchehab.chehab.org> <Pine.LNX.4.64.0809020815060.16986@cnc.isely.net>
 <48BD3FCC.2030206@linuxtv.org> <48BD4DCE.9020507@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2008, Stefan Richter wrote:

> Michael Krufky wrote:
> > Mike Isely wrote:
> >> On Tue, 2 Sep 2008, Mauro Carvalho Chehab wrote:
> >>> Please: don't do tricks like this to cheat with checkpatch.pl. The error is
> >>> there to point to a Coding Style violation.
> >>>
> >>> +	if (ret < 0) {
> >>> +		/* Keep checkpatch.pl quiet */
> >>> +		return ret;
> >>> +	}
> [...]
> >> Forcing this style:
> >>
> >> 	if (a)
> >> 		b;
> >>
> >> As opposed to the much safer
> >>
> >> 	if (a) {
> >> 		b;
> >> 	}
> >>
> >> is a huge mistake.  Both generate the same code; the second form is 
> >> robust against someone later inserting a printk
> [...]
> 
> If you need this kind of safety measures against errors in future code
> changes, could it be that you have some general QA problems?

One of the points behind a good coding style is that it should encourage 
code that is robust against trivial mistakes.  Prefering

	if (a) {
		b;
	}

over

	if (a)
		b;

I consider to be an example of this kind of simple safety.  (And I have 
in the past seen people getting burned from the obvious error of 
sticking a debug printf in between.)  ACTUALLY, I'd much, much rather 
prefer

	if (a) b;

however checkpatch.pl gets angry about that as well (even though the 
kernel CodingStyle document would seem to actually allow this - it's 
still one statement and since "b" is outside the normal flow then it's 
"something to hide" and should be ok in any case).


> 
> (However, why waste time arguing over braces or not?)

Tell that to those who would use checkpatch.pl to gate incoming 
changesets.


> 
> > I understand that kernel codingstyle forbids single line bracketing,
> 
> CodingStyle currently says that braces are not to be used there, *but*
> it does not give any explanation for it (other than hinting that the
> braces are unnecessary).
> 
> It is important to remember that many rules in CodingStyle are _not_
> hard rules but just widely (though not universally) accepted
> conventions.  And more importantly, checkpatch is even less
> authoritative than CodingStyle.  It only gives hints and
> recommendations, even if it reports an "error".

The v4l-maintainer has repeatedly told me otherwise.  His policy is 
basically that it must be checkpatch-clean or it isn't accepted (or at 
least an argument ensues).  He's probably not the only one in the 
community doing this.  Maybe he's getting pushed from above.  I wouldn't 
know.  What I do know is what it does to any subjective reason here.

I agree with your point, and I have raised this exact point when 
checkpatch.pl first got inflicted on me.  The issues I had in fact were 
places where CodingStyle (AFAICT) says it's ok while checkpatch.pl 
complains.  You know what answer I got?  (It wasn't from the v4l-dvb 
maintainer, by the way.)  It was effectively this: "CodingStyle is not 
relevant.  checkpatch.pl is the final authority.  This is what everyone 
does now.  Go away and come back when you have a real point to make."

I happen to have no real problem with CodingStyle.  I think it is well 
thought out and has evolved well over time.  But checkpatch.pl behaves 
like a baseball bat, compared to the fine scalpel that is CodingStyle.  
The checkpatch script has no concept of subjective judgement as you 
point out here.  I have a very big problem with using an imperfect tool 
such as that in a "perfect" no exceptions role as gatekeeper for code 
submissions.  From where I'm sitting - behind such a gate - checkpatch 
has effectively subverted CodingStyle.


> 
> If a driver author/maintainer has been using
> 	if (a) {
> 		b;
> 	}
> consistently in his driver all the time, why not leave it this way?  It
> arguably does not hurt readability.

Amen.


> 
> > but
> > codingstyle does not forbid adding comments anywhere in the c source.
> 
> Reread the section on commenting.  One very important rule in the Linux
> kernel coding style is that we comment sparingly.  We comment with the
> goal to keep code readable.
> 
> This /* I'll trick checkpatch */ comment is only distracting the reader.
> It serves no purpose whatsoever, except to manipulate the output of some
> random code submission checking tool.

I agree.  I really disliked adding those, and I would rather they not be 
present.  But I have been reminded time and time again that the code had 
to pass checkpatch.pl before it would be pulled.  That led to silliness 
such as this.  I will gladly remove such junk if the maintainer would 
apply a little more subjective reason to his use of checkpatch.pl.

   [...]

> 
> > Not only is this another example of checkpatch.pl thwarting development
> [...]
> 
> With this I agree.

<RANT>

  <mercifully deleted>

</RANT>

  -Mike


-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
