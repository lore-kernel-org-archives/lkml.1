Return-Path: <linux-kernel-owner+w=401wt.eu-S1753783AbXLICIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbXLICIr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 21:08:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbXLICIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 21:08:40 -0500
Received: from THUNK.ORG ([69.25.196.29]:36552 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743AbXLICIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 21:08:39 -0500
Date: Sat, 8 Dec 2007 21:08:28 -0500
From: Theodore Tso <tytso@mit.edu>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] random: use xor for mixing
Message-ID: <20071209020828.GX17037@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Matt Mackall <mpm@selenic.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <2.753618428@selenic.com> <3.753618428@selenic.com> <20071209000103.GS17037@thunk.org> <20071209004017.GQ19691@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071209004017.GQ19691@waste.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 06:40:17PM -0600, Matt Mackall wrote:
> I'm working on strengthening forward security for cases where the
> internals are exposed to an attacker. There are any number of
> situations where this can and does happen, and ensuring we don't
> expose ourselves to backtracking is a worthwhile theoretical concern.

See my other comments; I don't think we are currently vulnerable to
backtracking.

I tend to view backtracking as largely a theoretical concern, as most
of the time, if the attacker has read access to kernel memory in order
to compromise the internal state of /dev/random, the attacker very
likely has *write* access to kernel memory, at which point you have
much bigger problems to worry about, at least going forward.  

I suppose if you had *just* generated an 80-bit AES session key, right
before the internal state was compromised, this might be interesting,
but if the attacker can compromise arbitrary kernel memory, then
attacker might as well just grab keying information from the userspace
process --- such as perhaps the long-term private key of the user, or
the data to be encrypted.

So my personal take on it is that protecting against backtracking
attacks is mainly useful in silencing academics who like to come up
with, well, largely academic and theoretical scenario.  If it doesn't
take much effort, sure, let's try to protect against it (and I think
we're OK already).

But a much better use of our time would be spent creating userspace
support so we can more efficiently pull entropy from TPM modules, or
the noise from a sound/microphone input, etc., or other hardware
sources of entropy.  That would provide a much more practical
improvement to the /dev/random subsystem than worry about what I feel
are largely academic concerns.

Regards,

						- Ted
