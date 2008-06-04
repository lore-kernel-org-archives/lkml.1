Return-Path: <linux-kernel-owner+w=401wt.eu-S1760923AbYFDTV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760923AbYFDTV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 15:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757127AbYFDTVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 15:21:19 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61178 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756762AbYFDTVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 15:21:19 -0400
Date: Wed, 4 Jun 2008 20:19:10 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jon Masters <jcm@redhat.com>
cc: Stefan Assmann <sassmann@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Olaf Dabrunz <od@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Boot IRQ quirks and rerouting
In-Reply-To: <1212605859.8410.22.camel@londonpacket.bos.redhat.com>
Message-ID: <Pine.LNX.4.55.0806042014110.28685@cliff.in.clinika.pl>
References: <12124107071847-git-send-email-od@suse.de>  <m1tzgauduu.fsf@frodo.ebiederm.org>
 <4846651F.4070802@suse.de>  <m1ve0pqy06.fsf@frodo.ebiederm.org> 
 <48467DA7.9030309@suse.de> <1212605859.8410.22.camel@londonpacket.bos.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2008, Jon Masters wrote:

> Meanwhile, I think this really shows that a couple of us who've been
> meaning to poke at per-device IRQs should do so once again. This is the
> real solution - kill off all those per-IRQ threads, have one per device
> and split each IRQ into a "top" and "bottom" (just kidding on the names)
> half. Have the first part be *incredibly* small and just return if the
> device actually was responsible for the IRQ (and quiesse it), and have
> the second part do the heavyweight handling. Since the second part can
> run as a thread (and actually sleep for however long, because it's now
> per device) - and since we have threaded tasklets and all this on RT
> anyway - we can just kill off most of the extra logic in many Linux
> interrupt handlers and have just the interrupt thread do the work. 

 This is how a lot of our drivers used to work in the old days -- modulo
implementation details.  It is still a good idea, but it requires more
care and effort to implement, so people tend to avoid it unless forced by
the design of hardware involved (cf. phylib in the interrupt mode).

  Maciej
