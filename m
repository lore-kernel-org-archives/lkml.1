Return-Path: <linux-kernel-owner+w=401wt.eu-S1753166AbXHVEIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbXHVEIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 00:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbXHVEIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 00:08:13 -0400
Received: from web36602.mail.mud.yahoo.com ([209.191.85.19]:26373 "HELO
	web36602.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750926AbXHVEIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 00:08:11 -0400
X-YMail-OSG: y1mCrzEVM1mYZuVYCJ.OKeM1fhPYH2BvEfhaX21ob.C231EhfswevKQwefqTqvFAh2c7K33yAA--
X-RocketYMMF: rancidfat
Date: Tue, 21 Aug 2007 21:08:10 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Smack: Simplified Mandatory Access Control Kernel
To: Kyle Moffett <mrmacman_g4@mac.com>, casey@schaufler-ca.com
Cc: Valdis.Kletnieks@vt.edu, Pavel Machek <pavel@ucw.cz>,
       linux-security-module@vger.kernel.org,
       LKML Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <358B80A7-A00F-4E89-834B-0F7038602AE9@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <867222.72638.qm@web36602.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Kyle Moffett <mrmacman_g4@mac.com> wrote:

> On Aug 21, 2007, at 11:50:48, Casey Schaufler wrote:
> > --- Kyle Moffett <mrmacman_g4@mac.com> wrote:
> >> Well, in this case the "box" I want to secure will eventually be  
> >> running multi-user X on a multi-level-with-IPsec network.  For  
> >> that kind of protection profile, there is presently no substitute  
> >> for SELinux with some X11 patches.  AppArmor certainly doesn't  
> >> meet the confidentiality requirements (no data labelling), and  
> >> SMACK has no way of doing the very tight per-syscall security  
> >> requirements we have to meet.
> >
> > And what requirements would those be? Seriously, I've done Common  
> > Criteria and TCSEC evaluations on systems with less flexibility and  
> > granularity than Smack that included X, NFSv3, NIS, clusters, and  
> > all sorts of spiffy stuff.
> 
> These are requirements more of the "give the client warm fuzzies".

OK, that's perfectly reasonable. If the client has been sold
on the concept of SELinux the client will get warm fuzzies
only from SELinux. Security is how you feel about it, after all.
   
> On the other hand, when designing a box that could theoretically be  
> run on a semi-public unclassified network and yet still be safe  
> enough to run classified data over IPsec links, you want to give the  
> client all the warm fuzzies they ask for and more.

Yes. Of course, a little hard technology behind it doesn't hurt, either.
 
> > I mean, if the requirement is anything short of "runs SELinux" I  
> > have good reason to believe that a Smack based system is up to it.
> 
> "up to it", yes, but I think you'll find that beyond the simplest  
> policies, an SELinux policy that properly uses the SELinux  
> infrastructure will be much shorter than the equivalent SMACK policy,  

Well, I find that hard to believe. Maybe I'm only thinking of what
you would consider the simplest policies.

> not even including all the things that SELinux does and SMACK doesn't.

Of course.
 
> >> I didn't make this clear initially but that is the kind of system  
> >> I'm talking about wanting to secure some 50 million lines of code on.
> >
> > Cool. SELinux provides one approach to dealing with that, and the  
> > huge multiuser general purpose machine chuck full of legacy  
> > software hits the SELinux sweet spot.
> 
> Well, given that 99.9% of the systems people are really concerned  
> about security on are multi-user general-purpose machines chuck full  
> of legacy software, that seems to work just fine.

Err, no. By unit count such systems are extremely rare. There is
tremendous concern for security in your cell phone, your DVR,
your PDA, and even your toaster.

> If it's a single- 
> user box then you don't even need MAC, just a firewall, a good locked  
> rack/case/keyboard/etc, and decent physical security.

You cell phone has really lousy physical security.

> If it's  
> entirely custom-controlled software then you can just implement the  
> "MAC" entirely in your own software.  "General-purpose" vs "special- 
> purpose" is debatable, so I'll just leave that one lie.

Indeed. Total control over the software on your phone is not
a competetive option for a provider.

> Replying to another email:
> >> but you written it in wrong language. You written it in C, while  
> >> you should have written it in SELinux policy language (and your  
> >> favourite scripting language as frontend).
> >
> > I have often marvelled at the notion of a simplification layer.  I  
> > believe that you build complex things on top of simple things, not  
> > the other way around.
> 
> There is no "one answer" to this question in software development.   

You're correct. Can I quote you on that?

> Generally you prioritize things based on maximizing maintainability  
> and speed and minimizing code, bugs, and complexity.  Those are often  
> both conflicting and in agreement.  Here are a few common examples of  
> simple-thing-on-complex-thing:
> ...
> 
> Look at the SELinux model again; it has the following things:
>    (A) Labels on almost-all user-visible kernel objects
>    (B) Individual access rules for almost every operation on those  
> objects
>    (C) "Transition" rules to set the label on newly created objects.
>    (D) Fundamental "constraints" which enforce hard limits on what  
> may be permitted with "allow" rules
> 
>  From a fundamental standpoint it's harder to get much simpler than  
> that.

It's easy to get simpler than that:
    (A) Labels on all objects and subjects
    (B) Access rules for subjects and objects

No transformations. Operations in terms of rwx. lots simpler.

>  On top of that model, we also have a bit of additional  
> *flexibility* for MLS/RBAC, although that flexibility may be ignored  
> completely.
>    (1) You can define "users" which may only assume some "roles"
>    (2) You can define "roles" may only run in some "types"
>    (3) There's a simple way of declaring multiple "levels" and  
> "dominance".
> 
> So you see, SELinux is a pretty fundamental description of the  
> degrees of flexibility needed to secure everything.  That kind of  
> FUNDAMENTAL description is what belongs in the kernel.  Anything else  
> can and should be built on top with better libraries and/or user  
> interfaces.

I don't believe that. I understand that some people do.

> As for the script, I'm partway through debugging it but my time is  
> all chewed up with other stuff now, so it may take me an extra couple  
> days.

Curse that day job!

Thank you.


Casey Schaufler
casey@schaufler-ca.com
