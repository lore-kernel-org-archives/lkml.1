Return-Path: <linux-kernel-owner+w=401wt.eu-S1752930AbXDKPIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbXDKPIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 11:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbXDKPIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 11:08:19 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:17738 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbXDKPIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 11:08:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=udZcLL/JXyiZ2RP834XKXwjrPVYAm4b0nE0xp1mp1/MxaLagwK0J7+PwCg0FQBwxsAihj71Sz8gBTkDcqfHxZ1u/dAb/2CoXlFfHSU288mfnig3glSuSHDr4rtNzeE6c5Ur0Dog8kLExrIeWnG2N2SU387W1ubp2d2talN2GynM=
Message-ID: <191fb4ca0704110808k2c2cf10ct6c2dcab5efeb0939@mail.gmail.com>
Date: Wed, 11 Apr 2007 08:08:17 -0700
From: "Juerg Haefliger" <juergh@gmail.com>
To: "Hans de Goede" <j.w.r.degoede@hhs.nl>
Subject: Re: [lm-sensors] Hardware monitoring subsystem maintainer position is open
Cc: "Rudolf Marek" <r.marek@assembler.cz>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "LM Sensors" <lm-sensors@lm-sensors.org>
In-Reply-To: <461CA932.4060108@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070410150227.1bac05b5@hyperion.delvare>
	 <461BB006.9020308@hhs.nl>
	 <4dfa50520704100846s7c031ab0i9da94a9e993cbbfc@mail.gmail.com>
	 <461C0E0E.5090008@assembler.cz> <461CA932.4060108@hhs.nl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

As pointed out by different people already, this is mainly a process
issue. If we can get enough people together who are willing to
contribute we can make this work. Obviously Jean did a great job (big
thanks!) but I can't blame him for throwing the towel. I was always
amazed at how much time and effort he put into this. This can't be
handled by a single person.

I believe we need to come up with a process (and I like what Hans
suggests) and then need to identify individuals for the different jobs
(reviewers, submitters, ...).

I also think we need to make more use of trac to assign tasks to
people and to provide progress information/reports so that driver
submitters know what's going on and in what stage of the pipeline
their driver currently is.

...juerg (volunteering as a reviewer)




On 4/11/07, Hans de Goede <j.w.r.degoede@hhs.nl> wrote:
> Rudolf Marek wrote:
> > Hello all,
> >
> >
> > Maybe we could try following:
> >
> > 1) person post the driver
> > 2) quick review could be done critical fixes only, driver goes to -mm
> > 3) review that goes deeper - check for interface conformity and all the
> > stuff which could break - fixes for non-critical stuff
> > 4) after this driver goes to Linus tree at the very beginning for the
> > merge cycle marked as EXPERIMENTAL
> > 5) if the person agrees to be in MAINTAINER final review may be done and
> > EXPERIMENTAL could be removed. (This is step which might involve all
> > steps to make the driver really perfect ;)
> >
> > Well this is just an idea. Neither it does solve the maintainer problem,
> > nor it is perfect solution.
> >
>
> I like the general direction, but I don't really see a clear difference between
> step 2 and 3, IMO the border between these steps is vague. Also this doesn't
> address who can do (which kinda) reviews.
>
> I've been thinking about a solution for the slow path for new driver inclusion
> myself here is what I propose:
>
> 1a) We need a set of review guidelines / a review checklist. Here is a start:
> * Must follow kernel coding style guidelines
> * sysfs interface must be in accordance with Documentation/hwmon/sysfs
> * proper locking to avoid 2 simultaneous attempts to communicate with the
>    device when for example multiple sysfs files get read at once.
> * check the code for any obvious programming errors, like:
>    -not freeing resources (in error paths and in general)
>    -overrunning an array
>    -not checking return values of calls to other parts of the kernel
>    -of by one errors / bad loops
>    -etc.
> 1b) We need to decide somehow who can do reviews. For now I say anyone who
>    already maintains atleast one hwmon driver. But thats just a wild shot better
>    ideas are welcome.
>
> 2) We need a review process for new drivers, suggestion:
>
> 1.  Person (the submitter) posts driver
> 2a. Someone (the reviewer) reviews it according to our checklist / guidelines
>      and posts a detailed report of his findings and what needs fixing
> 2b. The submitter posts a fixed version
> 2c. The reviewer re-reviews the fixed version and either approves the fixed
>      version, goto 3 or points out things that (still) need fixing, goto 2b.
> 3.  The driver gets send to the -mm tree (marked as EXPERIMENTAL)
> 4.  Another person (the second reviewer) reviews it, same process as with step
>      2, once approved goto 5
> 5.  Send to Linus tree at the very beginning for the merge cycle still marked
>      as EXPERIMENTAL
> 6.  After quite some time and positive usage reports without any negative
>      counter reports a patch gets send to Linux to remove EXPERIMENTAL status.
>
> 3) We need a review process for fixes to existing drivers, suggestion:
>
> 1. Person (the submitter) posts a patch to an existing driver
> 2. The driver maintainer is responsible for handling this patch and reviews
>     it. If necessary he either modifies the patch himself or asks the submitter
>     to make modifications.
> 3. Once the maintainer is happy with the patch, he sends it to Linus tree at
>     the beginning for the merge cycle.
>
>
> The rationale of doing the new driver thing this way is to avoid having a
> single person who bears end responsibilities for all reviews and thus becomes a
> potential bottleneck. The problem with distributing reviews though is that most
> of us aren't as experienced as Jean is. Thus I decided to just do the review
> twice, to compensate (a bit) for this.
>
> The rationale of doing modifications of existing drivers through the maintainer
> is that he knows the code best, and thus can best judge if fixes are really
> fixes or more bandaids / workarounds. And if these fixes have any unwanted side
> effects.
>
> To give proper credit: the above is heavily inspired by how Fedora handles new
> packages, Fedora has thousands of packages written and maintained by 100's of
> contributers. Using a model where any contributer, once he has taken the first
> horde of becoming a contributer and thus proving (some) competence can review
> other contributers new packages.
>
> Problems with the above, I'm not completely happy with my current proposal for
> deciding who can do reviews. Also I guess that Andrew and Linus would like to
> have a single person to take hwmon patches from, thus we still need someone
> todo the actual collecting of approved patches and sending them to Andrew
> and/or Linus.
>
> Last but not least I want to say that we should not focus too much on review,
> review can only get us sofar. In my (abituguru) experience most real life hwmon
> problems do not come from things easily catched by a review, but rather from
> problems with (certain versions of) the hardware responding different then
> expected. No amount of review will catch these cases, thus we also need to
> concentrate on testing.
>
> For both abituguru drivers I've posted to the forums of the abit websites and
> the lm-sensors list as soon as I got something usable and that way managed to
> build a small team of circa 8 testers for each version, a team which I send
> each update to before sending it for upstream inclusion. Especially for the
> abituguru (rev 1 and 2) driver this has helped my much since this is a strange
> beast. The abituguru3 driver is more straight forward but also there the
> testing by others has been invaluable.
>
>
> > Personally better would be go with Jean and some kind of scheme noted
> > above, which would solve our "takes too long problem" and preserve the
> > high quality of drivers. This would mean some co-maintainers to Jean,
> > rather than to live without Jean at all.
> >
>
> +1
>
> Regards,
>
> Hans
>
>
>
> _______________________________________________
> lm-sensors mailing list
> lm-sensors@lm-sensors.org
> http://lists.lm-sensors.org/mailman/listinfo/lm-sensors
>
