Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbZHQA6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbZHQA6j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 20:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbZHQA6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 20:58:38 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:39605 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbZHQA6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 20:58:38 -0400
From: David Wagner <daw@cs.berkeley.edu>
Message-Id: <200908170058.n7H0wahu005383@taverner.cs.berkeley.edu>
Subject: Re: Security: information leaks in /proc enable keystroke recovery
To: rwatson@FreeBSD.org (Robert N. M. Watson)
Date: Sun, 16 Aug 2009 17:58:36 -0700 (PDT)
Cc: oliver.pntr@gmail.com (Oliver Pinter), freebsd-hackers@FreeBSD.org,
       linux-kernel@vger.kernel.org, daw@cs.berkeley.edu (David Wagner)
In-Reply-To: <7F29E9E1-AB92-45E3-9DF3-C8455533BA19@FreeBSD.org> from "Robert N. M. Watson" at Aug 17, 2009 12:25:07 AM
Secret-Bounce-Tag: 9a029cbee41caf2ca77a77efa3c13981
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I still think my definitions of "covert channel" vs "side channel"
better reflect accepted usage these days, but whatever.  I don't
have any great desire to debate the definitions.  That doesn't seem
like a good use of everyone's time.

I was trying to define some shorthand to more concisely make my point.
Since it appears my preferred shorthand turned out to be a barrier to
communication, rather than an aid, I'll try to make my point again, this
time spelling it out without using the problematic shorthand.  I care
more about the ultimate point than the language we use to communicate it.

My broader point is this:

I accept your argument that there is no point trying to defend
against deliberate communication of information between two cooperating
processes via some sneaky channel; there is no hope of stopping that
in general-purpose commodity OS's.  If process X and Y are both
colluding to send information from X to Y, they will succeed, no
matter how hard we try.  We have no hope of closing all such channels,
for general-purpose commodity OS's (like FreeBSD or Linux).

However I do not accept that this argument means we should throw up
our hands and ignore cases where the kernel allows malicious process
Y to spy on process X, against X's will.  If the kernel has a leak that
lets process Y eavesdrop on keystrokes typed into process X, that's
arguably worth fixing.  Trying to prevent that is not clearly hopeless.

There is a significant difference in threat model between

  "both X and Y are malicious and colluding with each other to
   facilitate some joint purpose shared by both X and Y"

vs

  "Y is malicious and is attempting to subvert the security of
   process X, against X's will".

If the designers deliberately intended to allow process Y to snoop on
the ESP and EIP of process X, even when there is no relationship between
X and Y (e.g., they don't have the same uid, and Y isn't root), well,
I would claim that was a design error.  Facilitating keystroke recovery
does not seem like a good design goal.

It's possible that the impact could be broader than discussed in the
Usenix Security paper.  Imagine if process X is doing crypto, say an RSA
decryption, and process Y is running on the same machine and is malicious.
If process Y is allowed to observe the EIP of process X, then process Y
may be able to observe which path process X has taken through the code.
In some cases, such as a naive implementation of RSA decryption, this
may reveal X's private key.

Leaking EIP and ESP to every other user on the same system strikes me
as pretty dubious.
