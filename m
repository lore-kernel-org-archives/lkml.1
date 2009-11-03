Return-Path: <linux-kernel-owner+w=401wt.eu-S1752051AbZKCL0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbZKCL0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 06:26:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbZKCL0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 06:26:31 -0500
Received: from ns.firmix.at ([62.141.48.66]:3455 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbZKCL0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 06:26:30 -0500
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Nov 2009 06:26:29 EST
Subject: Re: FatELF patches...
From: Bernd Petrovitsch <bernd@firmix.at>
To: Eric Windisch <eric@grokthis.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1257230619.5063.42.camel@eric-desktop.grokthis.net>
References: <1257230619.5063.42.camel@eric-desktop.grokthis.net>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Tue, 03 Nov 2009 12:21:05 +0100
Message-Id: <1257247265.23142.21.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.67 on ns.firmix.at
X-Firmix-Spam-Score: -2.285 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.285 required=5
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
X-Firmix-Received-Date: Tue, 03 Nov 2009 12:21:23 CET
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-03 at 01:43 -0500, Eric Windisch wrote:
> First, I apologize if this message gets top-posted or otherwise
> improperly threaded, as I'm not currently a subscriber to the list (I
Given proper references:-headers, the mail should have threaded
properly.
> can no longer handle the daily traffic).  I politely ask that I be CC'ed
> on any replies.
Which raises the question why you didn't cc: anyone in the first place.

> In response to Alan's request for a FatELF use-case, I'll submit two of
> my own.
> 
> I have customers which operate low-memory x86 virtual machine instances.
Low resource environments (be it embedded or not) are probably the last
who wants (or even can handle) such "bloat by design".
The question in that world is not "how can I make it run on more
architectures" but "how can I get rid of run-time code as soon as
possible".

> Until recently, these ran with as little as 64MB of RAM.  Many customers
> have chosen 32-bit distributions for these systems, but would like the
> flexibility of scaling beyond 4GB of memory.  These customers would like
> the choice of migrating to 64-bit without having to reinstall their
> distribution.
Just install a 64bit kernel (and leave the user-space intact). A 64bit
kernel can run 32bit binaries.

> Furthermore, I'm involved in several "cloud computing" initiatives,
> including interoperability efforts.  There has been discussion of
The better solution is probably to agree on pseudo-machine-code (like
e.g. JVM, parrot, or whatever) with good interpreters/JIT-compilers
which focus more on security and how to validate potentially hostile
programs than anything else.

> assuring portability of virtual machine images across varying
> infrastructure services.  I could see how FatELF could be part of a
> solution to this problem, enabling a single image to function against
> host services running a variety of architectures.
Let's hope that the n versions in a given FatElf image actually are
instances of the same source.

[....]
> I concede that there are a number of ways that solutions to these
> problems might be implemented, and FatELF binaries might not be the
> optimal solution.  Regardless, I do feel that use cases do exist, even
> if there are questions and concerns about the implementation.
The obvious drawbacks are:
- Even if disk space is cheap, the vast amount is a problem for
  mirroring that stuff.
- Fat-Binaries (ab)use more Internet bandwidth. Hell, Fedora/RedHat got
  delta-RPMS working (just?) for this reason.
- Fat-Binaries (ab)use much more memory and I/O bandwidth - loading code
  for n architectures and throw n-1 of it away doesn't sound very sound.
- Compiling+linking for n architectures needs n-1 cross-compilers
  installed and working.
- Compiling+linking for n architectures needs much more *time* than for
  1 (n times or so).
  Guess what people/developers did first on the old NeXT machines: They
  disable the default "build for all architectures" as it speeded things
  up.
  Even if the expected development setup is "build for local only", at
  least packagers and regression testers won't have the luxury of that.

The only remotely useful benefit in the long run I can imagine is: The
permanent cross-compiling will make AC_TRY_RUN() go away. Or at least
the alternatives are applicable without reading the generated
configure.sh (and config.log) to guess how to tell the script some
details.
But that isn't really worth it - as we are living without it for long.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


