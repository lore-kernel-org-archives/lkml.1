Return-Path: <linux-kernel-owner+w=401wt.eu-S1752920AbYERGYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbYERGYp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 02:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbYERGYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 02:24:39 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:1404 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbYERGYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 02:24:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=aw2Wa1ynLGsjj4z+CaEuC5rhYY+8ZFNuwIqisah3YjwBusWeH+lSR4Cip6a+tW4ujS2V/6bVbp0928kunk6bZLGYSOCw5+Oa4SXKsuPoFFz7cMdB1Y1BSs6PhisZmA0++/P+VlSL5XZ4tN5AJGUEFaZhLmbNEm1nz+XXsM/dnvo=
Date: Sun, 18 May 2008 10:24:26 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mikael Pettersson <mikpe@it.uu.se>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Tom Spink <tspink@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] x86: merge nmi_32-64 to nmi.c
Message-ID: <20080518062426.GA6948@cvg>
References: <20080517192200.GA6914@cvg> <7b9198260805171328u555eec17t3597f3378edbda88@mail.gmail.com> <Pine.LNX.4.55.0805172148380.10067@cliff.in.clinika.pl> <18479.21161.437325.251769@harpo.it.uu.se> <alpine.LFD.1.10.0805180023100.18798@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805180023100.18798@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Thomas Gleixner - Sun, May 18, 2008 at 12:34:15AM +0200]
| On Sat, 17 May 2008, Mikael Pettersson wrote:
| > Maciej W. Rozycki writes:
| >  > On Sat, 17 May 2008, Tom Spink wrote:
| >  > 
| >  > > static inline unsigned int get_nmi_count(int cpu)
| >  > > {
| >  > > #ifdef CONFIG_X86_64
| >  > >         return cpu_pda(cpu)->__nmi_count;
| >  > > #else
| >  > >         return nmi_count(cpu);
| >  > > #endif
| >  > > }
| >  > > 
| >  > > I know it introduces a lot of these conditionals, but at least there
| >  > > is one place to look for the get_nmi_count function, instead of
| >  > > searching for all variants of the function.
| >  > 
| >  >  Well, I suppose some header should provide a definition like:
| >  > 
| >  > #ifdef CONFIG_X86_64
| >  > #define cpu_x86_64 1
| >  > #else
| >  > #define cpu_x86_64 0
| >  > #endif
| >  > 
| >  > and the you can remove the horrible #ifdef clutter and make the quoted 
| >  > function look like:
| >  > 
| >  > static inline unsigned int get_nmi_count(int cpu)
| >  > {
| >  > 	return cpu_x86_64 ? cpu_pda(cpu)->__nmi_count : nmi_count(cpu);
| >  > }
| >  > 
| >  > Much better -- isn't it?
| > 
| > IMO, no, the #ifdef is preferable.
| > 
| > Why? Because the #ifdef is a very visible signal to the platform
| > people that there are (in this case) subarch differences that force
| > "clients" to behave differently on different subarchs. By removing
| > the #ifdef you're IMO making it less likely for the platform people
| > to take notice and work towards eliminating those differences.
| 
| The #ifdef is a poor choice. Maciej is damned right, that the single
| function with a clear distinction of the return value is better in
| terms of readability and maintenance.
| 
| As I said before, We can make this more visible with an uppercase
| CONFIG_WHATEVER instaed of the innocent cpu_x86_64 one, but both
| solutions are better than #ifdefs and provide simple grepable
| patterns.
| 
| The awareness of those differences does not depend at all on an
| #ifdef. Developers who are aware of the platform differences prefer a
| readable not ifdef poluted code base. People who need to be poked into
| the difference via an #ifdef are probably not those who can actually
| clean it up.
| 
| Thanks,
| 
| 	tglx
|

Thanks to all for catching this nit. Actually I was using single
function definition with #ifdef inside at first attempt. But the
result was a too ugly imho, so I switched in the definition form
you see now. If single defs is preferrable - no problem, will change
it. Anyway, I found there are some additional patches in Ingo's tip
tree so I have to remake my patch completely. So, as only I've got
it done - will send to LKML again for your justice ;)

		- Cyrill -
