Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbXJHQSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbXJHQSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 12:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbXJHQSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 12:18:46 -0400
Received: from smtp106.sbc.mail.re2.yahoo.com ([68.142.229.99]:27113 "HELO
	smtp106.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751509AbXJHQSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 12:18:44 -0400
X-YMail-OSG: BiOLfxYVM1lHp3gH6mklVtjpC0I8Lvpd6GDfb2QCP0UA5rzaDJZWEacbWYdBOmVwYjzjiGHdTA--
Date: Mon, 8 Oct 2007 11:18:35 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory
	Access Control Kernel
Message-ID: <20071008161835.GB7106@vino.hallyn.com>
References: <A508A802-AB11-4DFF-9CA8-498897CE5D03@mac.com> <63003.78064.qm@web36613.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63003.78064.qm@web36613.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Casey Schaufler (casey@schaufler-ca.com):
> 
> --- Kyle Moffett <mrmacman_g4@mac.com> wrote:
> 
> > On Oct 05, 2007, at 00:45:17, Eric W. Biederman wrote:
> > > Kyle Moffett <mrmacman_g4@mac.com> writes:
> > >
> > >> On Oct 04, 2007, at 21:44:02, Eric W. Biederman wrote:
> > >>> SElinux is not all encompassing or it is generally  
> > >>> incomprehensible I don't know which.  Or someone long ago would  
> > >>> have said a better  way to implement containers was with a  
> > >>> selinux ruleset, here is a  selinux ruleset that does that.   
> > >>> Although it is completely possible  to implement all of the  
> > >>> isolation with the existing LSM hooks as  Serge showed.
> > >>
> > >> The difference between SELinux and containers is that SELinux (and  
> > >> LSM as a whole) returns -EPERM to operations outside the scope of  
> > >> the  subject, whereas containers return -ENOENT (because it's not  
> > >> even in  the same namespace).
> > >
> > > Yes.  However if you look at what the first implementations were.   
> > > Especially something like linux-vserver.  All they provided was  
> > > isolation.  So perhaps you would not see every process ps but they  
> > > all had unique pid values.
> > >
> > > I'm pretty certain Serge at least prototyped a simplified version  
> > > of that using the LSM hooks.  Is there something I'm not remember  
> > > in those hooks that allows hiding of information like processes?
> > >
> > > Yes. Currently with containers we are taking that one step farther  
> > > as that solves a wider set of problems.
> > 
> > IMHO, containers have a subtly different purpose from LSM even though  
> > both are about information hiding.  Basically a container is  
> > information hiding primarily for administrative reasons; either as a  
> > convenience to help prevent errors or as a way of describing  
> > administrative boundaries.  For example, even in an environment where  
> > all sysadmins are trusted employees, a few head-honcho sysadmins  
> > would get root container access, and all others would get access to  
> > specific containers as a way of preventing "oops" errors.  Basically  
> > a container is about "full access inside this box and no access  
> > outside".
> > 
> > By contrast, LSM is more strictly about providing *limited* access to  
> > resources.  For an accounting business all client records would  
> > grouped and associated together, however those which have passed this  
> > year's review are read-only except by specific staff and others may  
> > have information restricted to some subset of the employees.
> >
> > So containers are exclusive subsets of "the system" while LSM should  
> > be about non-exclusive information restriction.
> 
> Yes. Isolation is a much simpler problem than access control.
> 
> > >>> We also have in the kernel another parallel security mechanism  
> > >>> (for what is generally a different class of operations) that has  
> > >>> been  quite successful, and different groups get along quite  
> > >>> well, and  ordinary mortals can understand it.   The linux  
> > >>> firewalling code.
> > >>
> > >> Well, I wouldn't go so far as the "ordinary mortals can understand  
> > >> it" part; it's still pretty high on the obtuse-o-meter.
> > >
> > > True.  Probably a more accurate statement is:`unix command line  
> > > power users can and do handle it after reading the docs.  That's  
> > > not quite ordinary mortals but it feels like it some days.  It  
> > > might all be perception...
> > 
> > I have seen more *wrong* iptables firewalls than I've seen correct  
> > ones.  Securing TCP/IP traffic properly requires either a lot of  
> > training/experience or a good out-of-the-box system like Shorewall  
> > which structures the necessary restrictions for you based on an  
> > abstract description of the desired functionality.  For instance what  
> > percentage of admins do you think could correctly set up their  
> > netfilter firewalls to log christmas-tree packets, smurfs, etc  
> > without the help of some external tool?  Hell, I don't trust myself  
> > to reliably do it without a lot of reading of docs and testing, and  
> > I've been doing netfilter firewalls for a while.
> > 
> > The bottom line is that with iptables it is *CRITICAL* to have a good  
> > set of interface tools to take the users' "My system is set up  
> > like..." description in some form and turn it into the necessary set  
> > of efficient security rules.  The *exact* same issue applies to  
> > SELinux, with 2 major additional problems:
> > 
> > 1)  Half the tools are still somewhat beta-ish and under heavy  
> > development.  Furthermore the semi-official reference policy is  
> > nowhere near comprehensive and pretty ugly to read (go back to the  
> > point about the tools being beta-ish).
> > 
> > 2)  If you break your system description or translation tools then  
> > instead of just your network dying your entire *system* dies.
> > 
> > 
> > >>> The linux firewalling codes has hooks all throughout the  
> > >>> networking stack, just like the LSM has hooks all throughout the  
> > >>> rest of linux  kernel.  There is a difference however.  The linux  
> > >>> firewalling code in addition to hooks has tables behind those  
> > >>> hooks that it  consults. There is generic code to walk those  
> > >>> tables and consult with different kernel modules to decide if we  
> > >>> should drop a packet.  Each of those kernel modules provides a  
> > >>> different capability that can be used to generate a firewall.
> > >>
> > >> This is almost *EXACTLY* what SELinux provides as an LSM module.   
> > >> The one difference is that with SELinux some compromises and  
> > >> restrictions  have been made so that (theoretically) the resulting  
> > >> policy can be  exhaustively analyzed to *prove* what it allows and  
> > >> disallows.  It  may be that SELinux should be split into 2 parts,  
> > >> one that provides  the underlying table-matching and the other  
> > >> that uses it to provide  the provability guarantees.  Here's a   
> > >> direct comparison:
> > >>
> > >> netfilter:
> > >>   (A) Each packet has src, dst, port, etc that can be matched
> > >>   (B) Table of rules applied sequentially (MATCH => ACTION)
> > >>   (C) Rules may alter the properties of packets as they are routed/
> > >> bridged/etc
> > >>
> > >> selinux:
> > >>   (A) Each object has user, role, and type that can be matched
> > >>   (B) Table of rules searched by object parameters (MATCH => allow/
> > >> auditallow/transition)
> > >>   (C) Rules may alter the properties of objects through transition  
> > >> rules.
> > >
> > > Ok.  There is something here.
> > >
> > > However in a generic setup, at least role would be an extended  
> > > match criteria provided by the selinux module.  It would not be a  
> > > core attribute.  It would need to depend on some extra  
> > > functionality being compiled in.
> > 
> > Now see I think *THAT* is where Casey should be going with his SMACK  
> > code.  Don't add another LSM, start looking at SELinux and figuring  
> > out what parts he does not need and how they can be parameterized out  
> > at build time for smaller systems.
> 
> Good suggestion. In fact, that is exactly how I approached my
> first two attempts at the problem. What you get if you take that
> route is an imposing infrastructure that has virually nothing
> to do and that adds no value to the solution. Programming to the
> LSM interface, on the other hand, allowed me to drastically reduce
> the size and complexity of the implementation.

(tongue-in-cheek)

No no, everyone knows you don't build simpler things on top of more
complicated ones, you go the other way around.  So what he was
suggesting was that selinux be re-written on top of smack.

:)

-serge
