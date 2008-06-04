Return-Path: <linux-kernel-owner+w=401wt.eu-S1761983AbYFDWIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761983AbYFDWIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 18:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbYFDWIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 18:08:42 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62900 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757778AbYFDWIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 18:08:41 -0400
Date: Wed, 4 Jun 2008 23:07:52 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jon Masters <jcm@redhat.com>
cc: Stefan Assmann <sassmann@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Olaf Dabrunz <od@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Boot IRQ quirks and rerouting
In-Reply-To: <1212609577.8410.32.camel@londonpacket.bos.redhat.com>
Message-ID: <Pine.LNX.4.55.0806042243080.28685@cliff.in.clinika.pl>
References: <12124107071847-git-send-email-od@suse.de>  <m1tzgauduu.fsf@frodo.ebiederm.org>
 <4846651F.4070802@suse.de>  <m1ve0pqy06.fsf@frodo.ebiederm.org> 
 <48467DA7.9030309@suse.de>  <1212605859.8410.22.camel@londonpacket.bos.redhat.com>
  <Pine.LNX.4.55.0806042014110.28685@cliff.in.clinika.pl>
 <1212609577.8410.32.camel@londonpacket.bos.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2008, Jon Masters wrote:

> I disagree. I think it's now actually the *inverse*. It /used/ to be
> harder, because you didn't have a context in which you could do many
> things (so you need to schedule some kind of deferred work), but
> actually, it'll become a lot more attractive with device threads.

 Well, I mean it's easier to do all the handling sequentially in the
hardirq context than split the thing and deal with all the communication,
locking, possible races, etc. so people avoid it unless really forced to.  
In principle all the interrupt handlers could be split like this except
those really, really tiny ones or where latency is absolutely critical.  
Yet it often does not happen.

> The only real caveat is for performance critical cases (the reasons we
> have special softirqs and the like right now) but there will always be
> special cases. Still, I'd like it if writing a Linux interrupt handler
> came down to registering two functions - one lightweight tiny one, and
> one that's just a thread. Much less room for making mistakes.

 The two will have to pass some state between each other, might run
concurrently or in parallel, etc. and require some effort to be written
correctly.

  Maciej
