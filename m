Return-Path: <linux-kernel-owner+w=401wt.eu-S1760751AbXKME6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760751AbXKME6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 23:58:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758049AbXKME6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 23:58:25 -0500
Received: from web36601.mail.mud.yahoo.com ([209.191.85.18]:43373 "HELO
	web36601.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758017AbXKME6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 23:58:24 -0500
X-YMail-OSG: Iumkj1YVM1nCHsRn1tELYYWd9Qmhb74GVM50apgKw1T3OvsNAIfxPWveq6vdR4.0ZOxdn5YZzX7MG6fruF6zUo93yw--
X-RocketYMMF: rancidfat
Date: Mon, 12 Nov 2007 20:58:23 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: AppArmor Security Goal
To: Joshua Brindle <method@manicmethod.com>, casey@schaufler-ca.com
Cc: Crispin Cowan <crispin@crispincowan.com>,
       "Dr. David Alan Gilbert" <linux@treblig.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       LSM ML <linux-security-module@vger.kernel.org>,
       apparmor-dev <apparmor-dev@forge.novell.com>
In-Reply-To: <4738EB67.40304@manicmethod.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <916293.58775.qm@web36601.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Joshua Brindle <method@manicmethod.com> wrote:

> Casey Schaufler wrote:
> > --- Crispin Cowan <crispin@crispincowan.com> wrote:
> >
> >   
> >> Dr. David Alan Gilbert wrote:
> >> ...
> >>
> >> Can you explain why you want a non-privileged user to be able to edit
> >> policy? I would like to better understand the problem here.
> >>
> >> Note that John Johansen is also interested in allowing non-privileged
> >> users to manipulate AppArmor policy, but his view was to only allow a
> >> non-privileged user to further tighten the profile on a program. To me,
> >> that adds complexity with not much value, but if lots of users want it,
> >> then I'm wrong :)
> >>     
> >
> > Now this is getting interesting. It looks to me as if you've implemented
> > a mandatory access control scheme that some people would like to be able
> > to use as a discretionary access control scheme. This is creepy after
> > seeing the MCS implementation in SELinux, which is also a DAC scheme
> > wacked out of a MAC scheme. Very interesting indeed.
> >   
> 
> This is the same sort of thing we are trying to do in SELinux with the 
> policy management server 
> <http://oss.tresys.com/projects/policy-server/wiki/PolicyServerDesign>, 
> ofcourse the policy management server enforces SELinux policy on what 
> can be changed and what can't. We devised a scheme to allow the policy 
> to become more restrictive without being able to change the policy 
> 'intent' using a type hierarchy.
> 
> In fact I was talking to a coworker today about how this could be done 
> with smack, using the same kind of hierarchy and allowing unprivileged 
> users (eg., those without MAC_OVERRIDE) to create new smack labels 
> 'under' their own which would be restricted. This is interesting because 
> of the ability to create new smack domains on the fly but since only 
> privileged users can do it it is of limited use. Imagine if a user could 
> create a new domain for their webbrowser or anything else they care to. 
> Since they can't add rules to the policy it would effectively just be a 
> user sandbox, an interesting use indeed.

It would be easy to add a label "owner" the same way that there's
an optional CIPSO mapping now. Writes to /smack/load would require
that the writer be the owner of the object label in the rule. I think
it would still require privilege to assign ownership, a non-parsed
write to /smack/labelowner should suffice for the mechanism. It seems
that you might need to support multiple labels for this to be really
effective, but I'm not sure why I think that. I'm also not sure that
once you draw a complete picture it won't be indistinguishable from
POSIX ACLs.


Casey Schaufler
casey@schaufler-ca.com
