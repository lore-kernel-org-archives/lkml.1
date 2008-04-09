Return-Path: <linux-kernel-owner+w=401wt.eu-S1755012AbYDIMLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbYDIMLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 08:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbYDIMLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 08:11:35 -0400
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:57475 "EHLO
	bh-buildlin1.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbYDIMLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 08:11:34 -0400
Message-ID: <47FCB253.7080505@panasas.com>
Date: Wed, 09 Apr 2008 15:10:59 +0300
From: Benny Halevy <bhalevy@panasas.com>
Organization: Panasas, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Jan Engelhardt <jengelh@computergmbh.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] checkpatch: relax spacing and line length
References: <alpine.LNX.1.10.0804060653020.30794@fbirervta.pbzchgretzou.qr> <20080408171257.GF17915@shadowen.org>
In-Reply-To: <20080408171257.GF17915@shadowen.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr. 08, 2008, 20:12 +0300, Andy Whitcroft <apw@shadowen.org> wrote:
> On Sun, Apr 06, 2008 at 06:54:54AM +0200, Jan Engelhardt wrote:
>> ===
>> total: 0 errors, 0 warnings, 36 lines checked
>>
>> d27a9f5.diff has no obvious style problems and is ready for submission.
>> ===
>> commit d27a9f5760fa231ab888f96e27355a001c88b239
>> Author: Jan Engelhardt <jengelh@computergmbh.de>
>> Date:   Sun Apr 6 06:49:01 2008 +0200
>>
>>     checkpatch: relax spacing and line length
>>
>>     We all had the arguments about 80 columns, so here goes a relax.
>>     Checking for 95 (or perhaps something better?), but of course we
>>     print "80" in the output, because if you happened to get to 95, it's
>>     "really time" to break it.
> 
> Why is it better for the end of the line to sometimes go a bit off the
> right of the screen, but not too far?  Are you trying to stop checkpatch
> whinging about lines which simply cannot be split pleasently and so poke
> a little off, or are you keen to have a bit more space to write code in
> as a general rule?
> 
> If its the former then you are missing the point of checkpatch, it is
> mearly an advisor trying to point those things you have done which the
> maintainer is very likely going to notice and going to have to deal with
> either by rejecting your patch or fixing it themselves; it is a time
> saving aid to them and you.  If the statement really cannot be sanely
> wrapped somewhere then do not wrap it.  The maintainer should be able to
> see you are correct, if they dissagree they will re-wrap it where they
> think it can be sanely wrapped.  While I can imagine that you might have
> one or two difficult wraps in a large set of patches, I would not expect
> the number of false reports to be significant.  I personally have seen
> three or four a year in all the patches I have produced and reviewed.
> So it does not seem worth changing the underlying rule just to avoid these
> easily ignored reports, expecially considering the number of genuinely
> bad lines it would then pass.
> 
> If its the latter (you want more space generally), then we should just
> say "line length is now N" and be done with it, 95, 128, 200 whatever.
> Letting you have 95 characters before telling you should not have had 81
> is very non-intuitive and bound to confuse.
> 
>>     This also relaxes the tab doctrine, because spaces DO make sense --
>>     especially when you view the code with a tab setting of not-8.
> 
> This is about visually representing the tabs as smaller units, and still
> wanting the rest of the code to line up correctly.  Although I can see
> that the effect is somewhat desirable, it feels very much like doing
> just this will then go on to encourage the writer to want to violate the
> overall line length (as you have more space) and lead to the need to have
> more characters on a line in the first place.

As I said on a different thread, tabs should still be accounted for as
8 spaces for checking the total line length.  The motivation is to
keep lines shorter and limit nesting.

> 
> For myself I would not necessarily have a problem with this, as I should
> be unable to see it in my tabs=8 world.  But unless the code base is
> consistant in its use of these then it would seem that their inconsistant
> use would distroy the overall effect, and render them ineffective to you
> as the consumer.  Also they _will_ get broken by the general populace as
> they edit without regard in their tabs=8 world, and their replacements
> would be just as acceptable under the new rule as coded.  That would
> imply that simply allowing these would not be sufficient, but enforcing
> this style (which is much harder) would be required.
> 
> 
> As things stand Documentation/CodingStyle is pretty direct in its language
> about what is and what is not acceptable in both these areas; I do not
> need to run git blame to guess at its author.  It seems entirely reasonable
> for checkpatch to implement (as closely as it can) what is carved on that
> stone tablet.  The point of having a CodingStyle (and this has been said
> many times) is not to please everyone (or indeed anyone but Linus), but to
> try and engender consistancy in the code base to ease maintenance for those
> higher up the food chain, for those that read all this code.  We all have
> our pet styles, and I can assure you Linux kernel style is not my style,
> but I write code for the kernel in that style because those are the rules.
> 
> To justify changing checkpatch to loosen its checks I would hope to see
> an agreed to change to the CodingStyle detailing actually what is now
> acceptable.  Failing that strong expressions from maintainers that they
> are keen to have code in some alternative style, and presumably _all_
> code for their area in that style.  Then it might well make sense to
> have different style applied automatically by maintainers area perhaps.
> Of course those maintainers would need to be sure their style was going
> to be accepted up the chain too.
> 
> Comments on the change as it stands follow inline.
> 
>>     Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
>> ---
>>  scripts/checkpatch.pl |   22 ++++++++++++++++------
>>  1 files changed, 16 insertions(+), 6 deletions(-)
>>
>> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
>> index 58a9494..e5a96c1 100755
>> --- a/scripts/checkpatch.pl
>> +++ b/scripts/checkpatch.pl
>> @@ -1094,8 +1094,8 @@ sub process {
>>  			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
>>  			ERROR("trailing whitespace\n" . $herevet);
>>  		}
>> -#80 column limit
>> -		if ($line =~ /^\+/ && !($prevrawline=~/\/\*\*/) && $length > 
>> 80) {
>> +#80 column limit (yes, testing for 95 is correct, we do not want to annoy)
>> +		if ($line =~ /^\+/ && !($prevrawline=~/\/\*\*/) && $length 
>>> = 95) {
>>  			WARN("line over 80 characters\n" . $herecurr);
> 
> I cannot see how we can fail to confuse our users if we only tell them
> they have exceeded 80, when they hit 95.

I agree.

> 
>> @@ -1107,12 +1107,22 @@ sub process {
>>  # check we are in a valid source file *.[hc] if not then ignore this hunk
>>  		next if ($realfile !~ /\.[hc]$/);
>>
>> +		my $arg = qr/$Type(?: ?$Ident)?/;
>> +		if ($rawline =~ /^\+ +($arg, )*$arg(?:,|\);?)$/) {
>> +			# We are probably in a function parameter list.
>> +			# Spaces ok -- used for align.
> 
> This seem like it would allow a lot of lines to be aligned using just
> spaces.  Even where they are undesirable.
> 
>> +		} elsif ($rawline =~ /^\+\t+ *\S/) {
>> +			# We are probably in a function or an array/struct
>> +			# definition/initializer. Spaces ok -- used for align
>> +			# on multiline statements.
> 
> This looks very likely to false trigger on any number of unrelated
> things.  Almost all lines start with spaces then a non-space character?
> Would this not reduce the test to be "you can use any number of spaces
> as long as they follow tabs."  And without actually calculating the
> indent on the previous line we are not in a position to make any more of
> a reasoned check than "\t* *" is ok, else whinge.

Yeah, I think that this was Jan's intention.

> 
> Now, we do know the indent to some degree, and we have some feel for
> statements, and this align only indent seems only valid "within" a
> statement.  So we might well be able to be significantly more targetted.
> Indeed were we to want to do this I think that would be required.

It'd be great if we could verify that the number of tabs is equal or
greater than the nesting level (and then followed by zero or more spaces).

This brings into mind if we could/should warn about excessive nesting?
I think it might be a good idea, though I'm not sure what would be
the threshold... Off the top of my head I'd say "around 5".

> 
>> +		} else {
>>  # at the beginning of a line any tabs must come first and anything
>>  # more than 8 must use tabs.
>> -		if ($rawline =~ /^\+\s* \t\s*\S/ ||
>> -		    $rawline =~ /^\+\s*        \s*/) {
>> -			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
>> -			ERROR("use tabs not spaces\n" . $herevet);
>> +			if ($rawline =~ /^\+\s* \t\s*\S/ ||
>> +			    $rawline =~ /^\+\s*        \s*/) {
>> +				my $herevet = "$here\n" . cat_vet($rawline) 
>> . "\n";
>> +				ERROR("use tabs not spaces\n" . $herevet);
>> +			}
>>  		}
> 
> -apw
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

