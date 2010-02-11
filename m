Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134Ab0BKU4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 15:56:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756966Ab0BKU4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 15:56:10 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Salman Qazi <sqazi@google.com>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, taviso@google.com,
       Roland Dreier <rolandd@cisco.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Race in ptrace.
In-Reply-To: Salman Qazi's message of  Thursday, 11 February 2010 12:39:09 -0800 <4352991a1002111239m681107f8g9e3802daf7ab706b@mail.gmail.com>
References: <20100208143231.6d804590.akpm@linux-foundation.org>
	<20100210133556.GA21925@redhat.com>
	<4352991a1002101038s6a2e67d9mc373416c17de9e6a@mail.gmail.com>
	<20100211125607.GA5086@redhat.com>
	<4352991a1002110832j1a4e6680scf4aa7effeb83a75@mail.gmail.com>
	<20100211165059.GA16053@redhat.com>
	<4352991a1002111043l35f1c1b5mcd9ad4c76f6351a7@mail.gmail.com>
	<20100211185530.GA22055@redhat.com>
	<4352991a1002111108n2be5f432i9484d2e8869daaa9@mail.gmail.com>
	<20100211201026.GA25172@redhat.com>
	<4352991a1002111239m681107f8g9e3802daf7ab706b@mail.gmail.com>
X-Zippy-Says: America!!  I saw it all!!  Vomiting!  Waving!  JERRY FALWELLING
    into your void tube of UHF oblivion!!  SAFEWAY of the mind --
Message-Id: <20100211205558.B5BCB8163@magilla.sf.frob.com>
Date: Thu, 11 Feb 2010 12:55:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What I don't agree with is that when we send SIGCONT later with
> "kill", we wake up the child at all.  It may make sense to someone who
> has access to the kernel source code, but from a user's point of view
> this is a surprise.  The signal is intercepted and should not have an
> effect on the child.

This is the behavior of SIGCONT and doesn't really have anything to do with
ptrace.  Once you have let the SIGSTOP through, the process is in job
control stop just like if you'd sent a SIGSTOP without using ptrace at all.

The distinction that is confusing you is that *generating* SIGCONT is what
resumes the process, not *delivering* it.  Another example is that if your
process has SIGCONT blocked or ignored, SIGCONT still wakes it up.  Another
example is that SIGCONT wakes up all the threads in a process, before one
of those threads delivers the SIGCONT (i.e. runs a handler).


Thanks,
Roland
