Return-Path: <linux-kernel-owner+w=401wt.eu-S1752779AbYBFPMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbYBFPMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 10:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751031AbYBFPM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 10:12:27 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:43913 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750921AbYBFPM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 10:12:26 -0500
Date: Wed, 6 Feb 2008 10:10:56 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: David Schwartz <davids@webmaster.com>
Cc: Pavel Roskin <proski@gnu.org>, rms@gnu.org, linux-kernel@vger.kernel.org,
       jonathan@jonmasters.org, rusty@rustcorp.com.au, pgiri@yahoo.com
Subject: Re: ndiswrapper and GPL-only symbols redux
Message-ID: <20080206151056.GL27119@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	David Schwartz <davids@webmaster.com>,
	Pavel Roskin <proski@gnu.org>, rms@gnu.org,
	linux-kernel@vger.kernel.org, jonathan@jonmasters.org,
	rusty@rustcorp.com.au, pgiri@yahoo.com
References: <20080206105051.GA13874@cs181133002.pp.htv.fi> <MDEHLPKNGKAHNMBLJOLKGEAHKCAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKGEAHKCAC.davids@webmaster.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 03:38:52AM -0800, David Schwartz wrote:
> > 
> > Ndiswrapper loads and executes code with not GPLv2 compatible licences 
> > in a way in the kernel that might be considered similar to a GPLv2'ed 
> > userspace program dlopen() a dynamic library file with a not GPLv2 
> > compatible licence.
> > 
> > IANAL, but I do think there might be real copyright issues with 
> > ndiswrapper.
> 
> Neither the kernel+ndiswrapper nor the non-free driver were
> developed with knowledge of the other, so there is simply no way one
> could be a derivative work of the other. Since no creative effort is
> required to link them together, and the linked result is not fixed
> in a permanent medium, a derivative work cannot be created by the
> linking process itself.

Indeed, there is a similar issue with libss, which was originally
written for use with Kerberos v5, and licensed under an MIT (BSD-style
plus you must not use MIT's name in advertising) license.  Kerberos V5
was adapted by Sun to create a propietary product called SEAM (Sun
Enterprise Authentication Mechanism), and contains a program called
kadmin, which uses libss as part of its user interface.

In the meantime, libss was enhanced to use a search path to dlopen the
first readline library it can find (some are GPL, some are
BSD-licensed), so that people could use debugfs while being able to
have command-line editing, and this is shipping in e2fsprogs.  I used
dlopen so that use of libreadline is optional; so if it doesn't fit on
a rescue floppy, it's no big deal; you can still use debugfs to edit
an ext2/3/4 filesystem.  So there was very much a valid technical
reason for doing what I did; I wasn't trying to circumvent any license
requirements, but trying to solve a perfect valid problem when you
only have 1440k on a 3.5" floppy (and libreadline is 296k, or 21% of
total amount of space available).

But if you compile and install e2fsprogs on Solaris, and then run
kadmin, you can have in one address space the proprietary kadmin
binary from SEAM, the BSD-licensed libss shared library from
e2fsprogs, and the GPL-licensed libreadline shared library.

Answer quickly!  Is there a license violation, and if so, who was
responsible for comitting the license violation?  This is my favorate
real-life case study that I roll out when I want to torture people who
claim that dynamic linking with a GPL shared library automatically
results a GPL violation.  :-)

The bottom line is that you should ask a lawyer, and not believe
anyone who has claimed to give you legal advice, whether or not they
have talked to "dozens of lawyers".  What's most important is the
lawyer with whom you have paid money so he can take the facts specific
to your case, and apply them to the relevant legal statues in those
legal jurisdictions applicable for the software/product in question.

Regards,

						- Ted
