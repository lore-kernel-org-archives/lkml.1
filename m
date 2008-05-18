Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbYERJf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbYERJf4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 05:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbYERJfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 05:35:45 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:18678 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbYERJfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 05:35:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=l0JwSKtiK11aLH51zYHRWgKeihUcEnux9rIDEi6BuhYhLQRnTsGwi6vbCPiMMD/W9xZ4QTfERkIXjH0OjXkQsgMhZOaZ4jl9dBpXdjHrbU3x6Y4rSGQsgscfGCuj6hI5KK9x9xs9QQD9O/l0rO724wlB/jRKGIEHEypcg4BJ/S4=
Date: Sun, 18 May 2008 13:35:33 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Tom Spink <tspink@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] x86: merge nmi_32-64 to nmi.c
Message-ID: <20080518093533.GE6948@cvg>
References: <20080517192200.GA6914@cvg> <7b9198260805171328u555eec17t3597f3378edbda88@mail.gmail.com> <Pine.LNX.4.55.0805172148380.10067@cliff.in.clinika.pl> <alpine.LFD.1.10.0805172331030.18798@apollo.tec.linutronix.de> <482FD9F2.8080204@goop.org> <alpine.LFD.1.10.0805181108420.18798@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805181108420.18798@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Thomas Gleixner - Sun, May 18, 2008 at 11:09:22AM +0200]
| On Sun, 18 May 2008, Jeremy Fitzhardinge wrote:
| 
| > Thomas Gleixner wrote:
| > > Definitely, but we should do it at the Kconfig level which allows us
| > > to have integer defines as well, so we end up with something like:
| > > 
| > > static inline unsigned int get_nmi_count(int cpu)
| > > {
| > >       return CONFIG_X86_64 ? cpu_pda(cpu)->__nmi_count : nmi_count(cpu);
| > > }
| > >   
| > 
| > Unfortunately that doesn't work because when CONFIG_X86_64 isn't defined it
| > doesn't expand to 0.  It would be nice if CONFIG_* expanded to 0/1, but we'd
| > need to change all the #ifdef CONFIG_* to #if CONFIG_*...
| 
| You can have int type CONFIG_ which is always expanded. We have to add
| one of those though.
| 
| Thanks,
| 	tglx
| 

Thomas, unfortunetly as I see we can't go by a simple way like that,
these static funstions also hides the differen types and args list.
So even we could leave it as it is now, or could define them as macroses.
Anyway I'll try to find out how to handle this.

		- Cyrill -
