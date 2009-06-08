Return-Path: <linux-kernel-owner+w=401wt.eu-S1755937AbZFHOWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbZFHOWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 10:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbZFHOWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 10:22:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54939 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754744AbZFHOWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 10:22:08 -0400
Date: Mon, 8 Jun 2009 16:21:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oliver Neukum <oliver@neukum.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: Run-time PM idea (was: Re: [linux-pm] [RFC][PATCH 0/2] PM:
	Rearrange core suspend code)
Message-ID: <20090608142154.GD14234@elte.hu>
References: <Pine.LNX.4.44L0.0906071651060.25203-100000@netrider.rowland.org> <20090608131159.GA15100@srcf.ucam.org> <20090608132235.GC13214@elte.hu> <200906081539.20459.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906081539.20459.oliver@neukum.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oliver Neukum <oliver@neukum.org> wrote:

> Am Montag, 8. Juni 2009 15:22:35 schrieb Ingo Molnar:
> 
> > What will the 'user space policy' bit do what the kernel cannot?
> >
> > If you mean the user has to configure something manually - that 
> > wont really happen in practice. We are happy if they know where 
> > to put those USB sticks in ;-)
> 
> User space need not be the user. Currently user space doesn't tell 
> the kernel how much functionality it needs. open/close give a 
> binary opposition which badly maps onto the graduated capabilities 
> devices have.

If the kernel isnt told what capabilities are used that's buggy code 
then.

> For example do you really need every key pressed while the screen 
> saver is running or is it enough for the keyboard to be able to 
> generate a wakeup event?

The sane default here is to suspend the keyboard, except if an audio 
app is running that binds to the volume keys of the keyboard.

If the 'keyboard' is properly abstracted in the kernel and the 
kernel driver _knows_ that the volume keys are in use, this is not a 
problem.

Arguing otherwise is just saying the equivalent of: "we have a 
broken model to utilize hardware, and instead of fixing it properly, 
introduce an _even more broken_ model, because in the current model 
things cannot be made to work".

The kernel _needs_ to have precise information about whether a piece 
of hardware is in use or not.

	Ingo
