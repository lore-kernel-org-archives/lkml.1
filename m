Return-Path: <linux-kernel-owner+w=401wt.eu-S1755158AbYG2FFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbYG2FFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 01:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbYG2FFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 01:05:35 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:25979 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbYG2FFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 01:05:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mVAbHDjtERHW2Rsln7y9AcDmr5u8z9Gnelf77/8xCQdMFnNMtDb2tOu2zbV3KK5+AU
         lSggpBlKMLWRuyqhKOvjDYcmUV8EWXi7L4e6FR1G3oa5cutZeOCZHbFWGRcL/kYD/6Q5
         TJlLtez874WC4JIgACw2Asn/kRX6BJNqhYDmY=
Message-ID: <9e4733910807282205g1f2b2e08y6ca61b38f098ffca@mail.gmail.com>
Date: Tue, 29 Jul 2008 01:05:33 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Theodore Tso" <tytso@mit.edu>, "Al Viro" <viro@zeniv.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: 463 kernel developers missing!
In-Reply-To: <20080729041337.GC9378@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <488E0BB6.7020006@simon.arlott.org.uk>
	 <488E1147.5040803@simon.arlott.org.uk>
	 <9e4733910807281200m25f7f16bwa6678694bb25a61@mail.gmail.com>
	 <20080729011526.GF28946@ZenIV.linux.org.uk>
	 <9e4733910807281825v42f9700al420ba48aebf3d790@mail.gmail.com>
	 <20080729013650.GG28946@ZenIV.linux.org.uk>
	 <9e4733910807281901i1a39ce93v902dd6bd240e1a34@mail.gmail.com>
	 <20080729025016.GT9378@mit.edu>
	 <9e4733910807282023h5479c755wde55e2324909b678@mail.gmail.com>
	 <20080729041337.GC9378@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/29/08, Theodore Tso <tytso@mit.edu> wrote:
> On Mon, Jul 28, 2008 at 11:23:31PM -0400, Jon Smirl wrote:
>  > The kernel already has a mailmap file, but it is not complete. So I
>  > should just take this work that makes the mailmap file a lot better
>  > and throw it away? The policy is that the log file should be messed up
>  > enough so that a computer can't process it and that a human can
>  > recover it only with several day's effort? That's a really hard line
>  > to define and we'll probably lose the identity of a bunch of
>  > contributors. I'll follow up with a patch that deletes the current
>  > .mailmap
>
>
> Personally, I have no objection to the mailmap file as it's on the
>  whole an improvement; if it's been automatically generated and it
>  falsely maps multiple people to a single person, that would be highly
>  unfortunate, but maybe it fixes more problems than it creates.

The mapping multiple people to a single person problem was always
there, the new mailmap file doesn't alter it. There simply isn't
enough information in the kernel source to tell if there are two or
one Mark Browns. The file would need to be extended to encode more
information.

Mark Brown <broonie@opensource.wolfsonmicro.com>
Mark Brown <broonie@sirena.org.uk>

If the Marks want to separate themselves they will need to alter the
mailmap. With the new mailmap this is easily done. With the old one
you would have need to identify all of the aliases first.

It's the higher level tools that are combining these into a single person.

>  I think the part most people are seriously objecting to is that the
>  supposition that Linus and some of his top lieutenants should be
>  enforcing some arbitrary rule that rejects commits if they come from
>  addresses outside of your .mailmap file (unless they first send a
>  patch to add their e-mail address to the .mailmap file), in some kind
>  of misguided attempt to enforce validation, which apparently the main
>  justification for which is so that you and others can runs some
>  statistical analysis, of which there seems to be some dispute whether
>  or not encouraging people to compete to get into the top 20
>  signed-off-by by splitting up commits into 100 different micro-patches
>  should be considered a desirable side effect of said statistical
>  analysis.

That whole thread was pointless, the scripts for doing validation
don't exist. The stat tools are helpful in finding errors in the
mailmap file. I never cared about the stat results, I already know who
the top developers are. Let's drop the whole validation concept too
since it is obviously upsetting people.

There are two types of entries in the file. Ones that alter the names
associated with an email and ones that don't. You could argue that the
ones that don't alter the names aren't needed. They're in there to
make maintenance on the file easier.

Putting all emails in the file lets you do maintenance by extracting
the complete list of emails from the log and then removing the ones
already in the file. Now you only have to manually check these new
emails. If the unchanged entries were removed from the file they'd get
mixed in with the new emails. Each time you updated mailmap you'd have
a couple thousand emails to check.

Putting the unchanged entries in the file also makes it very easy for
people who want to alter their name entry. Just edit the mailmap file.
Everything is there and sorted by name. Change the name for all of
your aliases to whatever you want. Just make sure the names are all
identical on the aliases.

>  As I said earlier, the moment you started advocating enforcing
>  validation, you may have started to confuse which is the tail and
>  which is the dog.  People should be supplying patches to improve the
>  kernel; not to provide accurate fodder for statistical analysis.

These addresses have more purposes than statistical analysis. They
also record the responsibility chain of who submitted the patch. It
seems prudent to me that we should make some effort to attempt to keep
that chain in a reasonably clean state.

I believe that people can get their name/email right in a patch 99% of
the time. The bulk of the 12% error rate appears to be coming from
maintainer tools mangling the patches and exposed internal mail server
names. The real message is that there are some tools that need to be
fixed.

-- 
Jon Smirl
jonsmirl@gmail.com
