Return-Path: <linux-kernel-owner+w=401wt.eu-S1755680AbXKXTQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbXKXTQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 14:16:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbXKXTQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 14:16:49 -0500
Received: from web36601.mail.mud.yahoo.com ([209.191.85.18]:41820 "HELO
	web36601.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753731AbXKXTQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 14:16:48 -0500
X-YMail-OSG: UnoM7EIVM1m3Uetiq5t3zxNJ9EZg6h_069PRpJz8
X-RocketYMMF: rancidfat
Date: Sat, 24 Nov 2007 11:16:46 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: + smack-version-11c-simplified-mandatory-access-control-kernel.patch added to -mm tree
To: Crispin Cowan <crispin@crispincowan.com>,
       Andrew Morgan <morgan@kernel.org>
Cc: casey@schaufler-ca.com, Stephen Smalley <sds@tycho.nsa.gov>,
       "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       chrisw@sous-sol.org, darwish.07@gmail.com, jmorris@namei.org,
       method@manicmethod.com, paul.moore@hp.com,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <47480D76.8030701@crispincowan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <388264.27091.qm@web36601.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Crispin Cowan <crispin@crispincowan.com> wrote:

> Andrew Morgan wrote:
> > Its not so much why you are wrong, as being clear that we're not using a
> > generic name and inadvertently limiting ourselves to a SMACK-like model...
> >   
> It seems we all agree that it is a bad idea to tie a POSIX Capability to
> one specific LSM model.

I think that's fair.

> > It feels to me as if a MAC "override capability" is, if true to its
> > name, extra to the MAC model; any MAC model that needs an 'override' to
> > function seems under-specified...

That's the reason we have a privilege model, not just for
MAC, but DAC as well. The Unix/Linux model where administration
and system tasks are performed by normal processes that are
just a little bit special, as opposed to a completely separate
set of interfaces, often makes things look a little contrived.
This is one of the advantages of SELinux, with it's model of
complete specification.

> An interesting observation. This is a core part of why I have always
> found the hierarchical models BLP and Biba to be unsatisfying. These
> systems essentially have one simple fixed policy "process label must
> dominate object label to get access", and then you express all the rest
> of your "policy" by labeling your stuff. It is impossible to manage such
> systems without a MAC_OVERRIDE escape hatch of some kind, because the
> "policy" is too simple and inflexible, e.g. it does not allow you to
> reclassify anything.

Weeeellllll... That's sort of what the "mandatory" is all about.

> >  SELinux clearly feels no need for one,
> >   
> That's not quite right. More specifically, it already has one in the
> form of unconfined_t. AppArmor has a similar escape hatch in the "Ux"
> permission. Its not that they don't need one, it is that they already
> have one. They get to have one because they allow you to actually write
> a policy that is more nuanced than "process label must dominate object
> label".

That SELinux doesn't require any capabilities is an artifact of
design on that LSM. The whole notion of privilege is somewhat out
of context when your model is to explicitly state how every possible
decision ought to go. That is one important philosophical difference
between SELinux and Smack, with Smack taking a higher level view
on policy and hence privilege.

> > and browsing through your SMACK patch, there are many instances where
> > this capability is used as an convenience privileged override. However,
> > in other situations, it appears as if the capability is required for
> > basic SMACK operations to succeed.
> >
> > My sense is that there is a case to be made for: CAP_MAC_ADMIN and
> > CAP_MAC_OVERRIDE here. The former being for cases where SMACK (or
> > whatever MAC supports it) requires privilege to perform a privileged MAC
> > operation, and the latter for saying "OK, I'm without a paddle but need
> > one" (or words to that effect).
> >   
> I don't get the difference. Both seem to permit the process to violate
> the MAC policy. I could make up a meaning for MAC_ADMIN that is
> different from MAC_OVERRIDE in the AppArmor sense, but I don't want to
> :-) and worse, I suspect the distinction would be different for each
> LSM. So let not, and just have one MAC_OVERRIDE capability.

I am pretty close to agreeing with Andrew that a distinction
between allowing a process to change the state of the MAC
configuration (e.g. set file or process MAC labels, add rules)
and violating the rules is in order. SELinux can ignore both,
AppArmor can ignore one, and the upcoming DG/UX port* can ask for
further granularity when they show up.

I will look in this direction and see if I can patches proposed
before the virus in my sinuses knocks me out completely.

Thank you.

----
*  DG/UX supported over 330 capabilities and is my personal
   poster child for excesses of granularity with regard to
   capabilities. I don't really expect to see a Linux port.


Casey Schaufler
casey@schaufler-ca.com
