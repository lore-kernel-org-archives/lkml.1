Return-Path: <linux-kernel-owner+w=401wt.eu-S1763405AbXHLBgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763405AbXHLBgT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 21:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756249AbXHLBgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 21:36:06 -0400
Received: from web36611.mail.mud.yahoo.com ([209.191.85.28]:44850 "HELO
	web36611.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756232AbXHLBgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 21:36:04 -0400
X-YMail-OSG: 3DpCrfgVM1lE5_ka5SPqzFu9PH9.bRF36gS3bZG8yjDLi5b4kYZGEbZedKSAGC31fFh3OtsrFQ--
X-RocketYMMF: rancidfat
Date: Sat, 11 Aug 2007 18:36:02 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Smack: Simplified Mandatory Access Control Kernel
To: Andi Kleen <andi@firstfloor.org>, casey@schaufler-ca.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@osdl.org, torvalds@osdl.org
In-Reply-To: <p73zm0xslyk.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <515984.88226.qm@web36611.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Andi Kleen <andi@firstfloor.org> wrote:

> Casey Schaufler <casey@schaufler-ca.com> writes:
> 
> > Smack is the Simplified Mandatory Access Control Kernel.
> 
> I like the simplified part.
> 
> > +static int smk_get_access(smack_t sub, smack_t obj)
> > +{
> > +	struct smk_list_entry *sp = smack_list;
> > +
> > +	for (; sp != NULL; sp = sp->smk_next)
> > +		if (sp->smk_rule.smk_subject == sub &&
> > +		    sp->smk_rule.smk_object == obj)
> > +			return sp->smk_rule.smk_access;
> 
> Do I miss something, or is there really no locking for the reader side
> of the list? That looks dangerous. Of course a global lock for readers 
> would be likely a scaling disaster. You could use RCU.

Entries are never deleted, although they can be modified.

> Or if you assume rules are changed only very infrequently it might
> be more cache friendly to compile all the rules into a linear buffer
> and then just replace the whole buffer atomically with a RCU
> grace period on cahnges.

Individual entries can be modified without changing the whole
thing, but they shouldn't change often.

> It doesn't look like it would scale to larger numbers of rules though.
> Is that intended? Would caching of decisions fit into the design?

I put some thought into clever schemes for supporting large rule sets
well but decided to go ahead with the simplest possible mechanism
because I expect that in real deployments the number of rules will
be small. In fact, experiance says that virtually all access choices
will be covered either by the subject==object case or the subject can
read floor case. Cacheing, hashing, and 2D structures are all
possibilties that I would be happy to entertain as enhancements.

> Also in general code style would need some improvements;
> e.g. no externs in .c; no ../.. include hacks etc.
> You also seem weak on the Documentation front.

Yes, it is pretty sparse.

> Other than that it looks reasonably clean (haven't read all of it)

Thank you for your comments. I think the next version will be improved.


Casey Schaufler
casey@schaufler-ca.com
