Return-Path: <linux-kernel-owner+w=401wt.eu-S1760518AbXJEQ1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760518AbXJEQ1m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 12:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761173AbXJEQ1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 12:27:10 -0400
Received: from web36613.mail.mud.yahoo.com ([209.191.85.30]:37582 "HELO
	web36613.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760878AbXJEQ1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 12:27:08 -0400
X-YMail-OSG: NDCUmYcVM1nhTAE38SJW6i2Q1YHGKDuOQIGnZorJzlYvSnbqeCuXK17IJHC2mUeDSajXlO7WEw--
X-RocketYMMF: rancidfat
Date: Fri, 5 Oct 2007 09:27:06 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
To: Kyle Moffett <mrmacman_g4@mac.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Serge E. Hallyn" <serge@hallyn.com>
In-Reply-To: <A508A802-AB11-4DFF-9CA8-498897CE5D03@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <63003.78064.qm@web36613.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Kyle Moffett <mrmacman_g4@mac.com> wrote:

> On Oct 05, 2007, at 00:45:17, Eric W. Biederman wrote:
> > Kyle Moffett <mrmacman_g4@mac.com> writes:
> >
> >> On Oct 04, 2007, at 21:44:02, Eric W. Biederman wrote:
> >>> SElinux is not all encompassing or it is generally  
> >>> incomprehensible I don't know which.  Or someone long ago would  
> >>> have said a better  way to implement containers was with a  
> >>> selinux ruleset, here is a  selinux ruleset that does that.   
> >>> Although it is completely possible  to implement all of the  
> >>> isolation with the existing LSM hooks as  Serge showed.
> >>
> >> The difference between SELinux and containers is that SELinux (and  
> >> LSM as a whole) returns -EPERM to operations outside the scope of  
> >> the  subject, whereas containers return -ENOENT (because it's not  
> >> even in  the same namespace).
> >
> > Yes.  However if you look at what the first implementations were.   
> > Especially something like linux-vserver.  All they provided was  
> > isolation.  So perhaps you would not see every process ps but they  
> > all had unique pid values.
> >
> > I'm pretty certain Serge at least prototyped a simplified version  
> > of that using the LSM hooks.  Is there something I'm not remember  
> > in those hooks that allows hiding of information like processes?
> >
> > Yes. Currently with containers we are taking that one step farther  
> > as that solves a wider set of problems.
> 
> IMHO, containers have a subtly different purpose from LSM even though  
> both are about information hiding.  Basically a container is  
> information hiding primarily for administrative reasons; either as a  
> convenience to help prevent errors or as a way of describing  
> administrative boundaries.  For example, even in an environment where  
> all sysadmins are trusted employees, a few head-honcho sysadmins  
> would get root container access, and all others would get access to  
> specific containers as a way of preventing "oops" errors.  Basically  
> a container is about "full access inside this box and no access  
> outside".
> 
> By contrast, LSM is more strictly about providing *limited* access to  
> resources.  For an accounting business all client records would  
> grouped and associated together, however those which have passed this  
> year's review are read-only except by specific staff and others may  
> have information restricted to some subset of the employees.
>
> So containers are exclusive subsets of "the system" while LSM should  
> be about non-exclusive information restriction.

Yes. Isolation is a much simpler problem than access control.

> >>> We also have in the kernel another parallel security mechanism  
> >>> (for what is generally a different class of operations) that has  
> >>> been  quite successful, and different groups get along quite  
> >>> well, and  ordinary mortals can understand it.   The linux  
> >>> firewalling code.
> >>
> >> Well, I wouldn't go so far as the "ordinary mortals can understand  
> >> it" part; it's still pretty high on the obtuse-o-meter.
> >
> > True.  Probably a more accurate statement is:`unix command line  
> > power users can and do handle it after reading the docs.  That's  
> > not quite ordinary mortals but it feels like it some days.  It  
> > might all be perception...
> 
> I have seen more *wrong* iptables firewalls than I've seen correct  
> ones.  Securing TCP/IP traffic properly requires either a lot of  
> training/experience or a good out-of-the-box system like Shorewall  
> which structures the necessary restrictions for you based on an  
> abstract description of the desired functionality.  For instance what  
> percentage of admins do you think could correctly set up their  
> netfilter firewalls to log christmas-tree packets, smurfs, etc  
> without the help of some external tool?  Hell, I don't trust myself  
> to reliably do it without a lot of reading of docs and testing, and  
> I've been doing netfilter firewalls for a while.
> 
> The bottom line is that with iptables it is *CRITICAL* to have a good  
> set of interface tools to take the users' "My system is set up  
> like..." description in some form and turn it into the necessary set  
> of efficient security rules.  The *exact* same issue applies to  
> SELinux, with 2 major additional problems:
> 
> 1)  Half the tools are still somewhat beta-ish and under heavy  
> development.  Furthermore the semi-official reference policy is  
> nowhere near comprehensive and pretty ugly to read (go back to the  
> point about the tools being beta-ish).
> 
> 2)  If you break your system description or translation tools then  
> instead of just your network dying your entire *system* dies.
> 
> 
> >>> The linux firewalling codes has hooks all throughout the  
> >>> networking stack, just like the LSM has hooks all throughout the  
> >>> rest of linux  kernel.  There is a difference however.  The linux  
> >>> firewalling code in addition to hooks has tables behind those  
> >>> hooks that it  consults. There is generic code to walk those  
> >>> tables and consult with different kernel modules to decide if we  
> >>> should drop a packet.  Each of those kernel modules provides a  
> >>> different capability that can be used to generate a firewall.
> >>
> >> This is almost *EXACTLY* what SELinux provides as an LSM module.   
> >> The one difference is that with SELinux some compromises and  
> >> restrictions  have been made so that (theoretically) the resulting  
> >> policy can be  exhaustively analyzed to *prove* what it allows and  
> >> disallows.  It  may be that SELinux should be split into 2 parts,  
> >> one that provides  the underlying table-matching and the other  
> >> that uses it to provide  the provability guarantees.  Here's a   
> >> direct comparison:
> >>
> >> netfilter:
> >>   (A) Each packet has src, dst, port, etc that can be matched
> >>   (B) Table of rules applied sequentially (MATCH => ACTION)
> >>   (C) Rules may alter the properties of packets as they are routed/
> >> bridged/etc
> >>
> >> selinux:
> >>   (A) Each object has user, role, and type that can be matched
> >>   (B) Table of rules searched by object parameters (MATCH => allow/
> >> auditallow/transition)
> >>   (C) Rules may alter the properties of objects through transition  
> >> rules.
> >
> > Ok.  There is something here.
> >
> > However in a generic setup, at least role would be an extended  
> > match criteria provided by the selinux module.  It would not be a  
> > core attribute.  It would need to depend on some extra  
> > functionality being compiled in.
> 
> Now see I think *THAT* is where Casey should be going with his SMACK  
> code.  Don't add another LSM, start looking at SELinux and figuring  
> out what parts he does not need and how they can be parameterized out  
> at build time for smaller systems.

Good suggestion. In fact, that is exactly how I approached my
first two attempts at the problem. What you get if you take that
route is an imposing infrastructure that has virually nothing
to do and that adds no value to the solution. Programming to the
LSM interface, on the other hand, allowed me to drastically reduce
the size and complexity of the implementation.

> On the other hand, the "user" and "role" fields in SELinux are  
> already fairly flexible.  The one constant is that user=>role and  
> role=>type must both be allowed for a label to be valid.  Other than  
> that, the constraints specify what must be true for a transition to  
> be allowed.  For example the standard strict reference policy  
> includes this bit:
> 
> constrain process transition (
> 	(u1 == u2) or
> 	(t1 == can_change_process_identity and t2 == process_user_target) or
> 	(t1 == cron_source_domain and (t2 == cron_job_domain or u2 ==  
> system_u)) or
> 	(t1 == can_system_change and u2 == system_u) or
> 	(t1 == process_uncond_exempt)
> );
> 
> Basically all constraints on a particular access vector must be  
> satisfied for that to be allowed (in addition to other things).  For  
> the above example, a process running exec() may only change its user  
> if one of the following:
> 
>   * It's a login-like program and is starting a user entrypoint
>   * It's a cron-like program and is starting a user or system cronjob
>   * It's a process allowed to start system processes (admin runs  
> initscripts)
>   * It's unconditionally exempt
> 
> By creating types and assigning meaningful attributes to those types  
> you may restrict the changing of the "user" and "role" however you  
> would like, including not at all.
> 
> Really SELinux is just a fairly elaborate security state-machine.   
> Each process on the system is in a given "state", defined by its  
> label, and "state transitions" are only allowed based on the rules  
> defined in the database.  Since there are 4 extremely common security  
> models that people like to combine there are 4 fields in each SELinux  
> label:
>    (A)  User: User A may not poke user B's processes/data, even if  
> they happen to be running in the same UNIX UID
>    (B)  Role: Users may only perform operations for the role they are  
> currently logged in as
>    (C)  Type-enforcement: An apache process may only read files that  
> it needs to operate correctly
>    (D)  Multi-level:  Top-secret data can't magically become  
> unclassified
> 
> Perhaps the thing to do would be to make it possible to compile out  
> the portions which people don't want.  That would certainly satisfy  
> Casey, he would build only the "Type-enforcement" portion or only the  
> "Multi-level" portion and be able to do exactly the same things he  
> does now with a bit finer granularity of operations.  By defining the  
> lists of operations he cares about for "r" (read), "w" (write),  
> "x" (exec), "a" (append), and requires-capabilities, you can just  
> give those permissions directly in a simplified SELinux-type policy.

But Kyle, it's already possible to compile out the part I don't
want. I configure SELinux off and away I go.

Smack is not a subset of SELinux, it behaves differently. SELinux
has a policy that is program behavior oriented, Smack is strictly
subjet/object oriented. Your 4 components (A-D) are meaningless to
Smack.

> >>> I'm not yet annoyed enough to go implement an iptables like  
> >>> interface to the LSM enhancing it with more generic mechanism to  
> >>> make the problem simpler, but I'm getting there.  Perhaps next  
> >>> time  I'm bored.
> >>
> >> I think a fair amount of what we need is already done in SELinux,  
> >> and efforts would be better spent in figuring out what seems too  
> >> complicated in SELinux and making it simpler.

The granularity and consequently the size of the policy specificiation
result in policies that are too complicated. Tieing the policy to the
expected behavior of specific applications adds to the complexity.
SELinux is designed to increase in complexity as it evolves. Making
it simpler would conflict with the design goal of finer granularity.

> >> Probably a fair amount  of that just means better tools.

Now what kind of tools are you talking about? Static analysis?
Data flow diagrammers for Java?

> > How about thinking of it another way.
> >
> > Perform the split up you talked about above and move the table  
> > matching into the LSM hooks.
> >
> > Use something like the iptables action and match to module mapping  
> > code so we can have multiple modules compiled in and useable at the  
> > same time with the LSM hooks.
> >
> > I think it is firmly established that selling SElinux to everyone  
> > is politically untenable.  However enhancing the LSM (even if it is  
> > mostly selinux code movement down a layer) I think can be sold.

That would be silly. Smack uses a significantly smaller set of hooks
than SELinux requires and still does interesting things. We went through
the "replace LSM with the SELinux interface" exercise a couple years
ago, I would hate to have to regurgitate all those discussions.

> > If I could run Serge's isolation code and selinux rules at the same  
> > time that would be interesting.
> >
> > My impression is that selinux is one monolithic blob that doesn't  
> > allow me to incrementally add matching or action features that I  
> > find interesting.
> 
> Well the major problem here is the performance one.  As anybody who  
> has tried to do a thousand-linear-rule IPtables set will quickly tell  
> you, it makes performance go all to hell.  Good iptables frontends  
> like shorewall build little subchains to keep the fast-path as  
> efficient as possible but regardless the search is a linear rule- 
> traversal (IE: O(N) where N is the number of rules you had to test).   
> In order to get good enough performance out of SELinux they had to  
> *start* with an O(log(N) rule traversal which means that execution- 
> order-style rules are impossible, so you *MUST* limit the fields and  
> prevent any overlap between rules.  For example, in SELinux nobody  
> writes "deny" rules because the interpretation-order is undefined.   
> Instead you only write "allow" rules for the things you actually want  
> to allow.  The one exception is "neverallow" rules which are verified  
> at compile time as sanity checks and never actually loaded in the  
> kernel.
> 
> Cheers,
> Kyle Moffett
> 
> 
> 


Casey Schaufler
casey@schaufler-ca.com
