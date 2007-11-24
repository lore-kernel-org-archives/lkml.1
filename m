Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbXKXEr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbXKXEr2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 23:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbXKXErT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 23:47:19 -0500
Received: from web36610.mail.mud.yahoo.com ([209.191.85.27]:31627 "HELO
	web36610.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751429AbXKXErS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 23:47:18 -0500
X-YMail-OSG: V_4ul_MVM1kpSBpUj7SgvaY9L8Nvbd2orl8DYRffA2mS65fi6aStn9FwSh.JO8N1O8iAftUFvFtPLdzkhKoG9xdZxYvoZVolpi__QDBDRFRWxJ4uxT8-
X-RocketYMMF: rancidfat
Date: Fri, 23 Nov 2007 20:47:17 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: + smack-version-11c-simplified-mandatory-access-control-kernel.patch added to -mm tree
To: Andrew Morgan <morgan@kernel.org>, casey@schaufler-ca.com
Cc: Stephen Smalley <sds@tycho.nsa.gov>, "Serge E. Hallyn" <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, chrisw@sous-sol.org, darwish.07@gmail.com,
       jmorris@namei.org, method@manicmethod.com, paul.moore@hp.com,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <4747999E.4020201@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <335711.34116.qm@web36610.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Andrew Morgan <morgan@kernel.org> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Casey Schaufler wrote:
> > In the end we can call it CAP_LATE_FOR_DINNER if that's the only way
> > I can move forward. CAP_MAC_OVERRIDE is the obvious partner to
> > CAP_DAC_OVERRIDE, so that's still my preference. CAP_SMACK_OVERRIDE
> > unnecessarily ties it to one LSM, and in spite of what some people
> > still seem to think, I see more LSMs in the pipeline.
> 
> I'd personally not like to see SMACK appear in a capability name. No
> offense Casey, but SMACK may be displaced with YAMAC (*) someday, and
> I'd hate to have wasted a capability on it.

No offense taken. Technology continues marching forward and all that.

> Using CAP_MAC_OVERRIDE makes
> sense to me - even if its not (yet/ever) honored by all MAC LSMs.

Thanks.

> I do have a question about whether one capability is sufficient in
> general for MAC. Looking at the:
> 
>   http://wt.xpilot.org/publications/posix.1e/download.html
> 
> last draft, there are no less than 5 capabilities (p173) allocated for
> MAC. Presumably there was a good reason for 5 and not 1 back then -
> could you summarize what is different now?

There are to my mind two important differences. The first is that
my experiance with Trusted Irix (Trix from here on), which used (uses?)
capabilities and MAC together, is that the granularity is lost on
99 44/100% of programs, programmers, evaluators, admins, and problems.
You just don't get that many cases where it actually gets you anything
to have less than all the MAC capabilities. Applications that care
about MAC to the extent that they use the capabilities tend to use the
lot, if not all the time, in certain circumstances. I'm afraid that
I am not a major fan of fine grained privilege based on my experiance
with it.

The second and perhaps more important reason is that the POSIX
draft assumed a Bell & LaPadula sensitivity model, or at least
a model very much like it. What would CAP_MAC_DOWNGRADE mean on
a Smack system configured:

    OneHand      OtherHand    r---
    OtherHand    GrippingHand r---
    GrippingHand OneHand      r---

What would CAP_MAC_UPGRADE mean, for that matter? It's even worse
to consider that the relationships can change.

CAP_MAC_READ and CAP_MAC_WRITE still make sense, as does
CAP_MAC_RELABEL_SUBJ. But if you have CAP_MAC_WRITE you can
do pretty much the same damage as if you have CAP_MAC_RELABEL_SUBJ,
and the other way around, and if you're not going to use one
of the other capabilities after you find out interesting things
using CAP_MAC_READ it's hard to figure why you'd bother.

Now I know that there are lots of people who don't share my
views on granularity, but I have lots of experiance with this
and the cases where it actually makes sense to break the MAC
capabilities up are rare.

That's my going in position, at any rate. I'm always open to
finding out why I'm wrong.

Thank you.


Casey Schaufler
casey@schaufler-ca.com
