Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbXKXLij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbXKXLij (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 06:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbXKXLic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 06:38:32 -0500
Received: from mail8.dotsterhost.com ([66.11.233.1]:56765 "HELO
	mail8.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752467AbXKXLia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 06:38:30 -0500
Message-ID: <47480D6B.9080907@crispincowan.com>
Date: Sat, 24 Nov 2007 03:39:23 -0800
From: Crispin Cowan <crispin@crispincowan.com>
Organization: Crispin's Labs
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: casey@schaufler-ca.com
CC: Andrew Morgan <morgan@kernel.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       chrisw@sous-sol.org, darwish.07@gmail.com, jmorris@namei.org,
       method@manicmethod.com, paul.moore@hp.com,
       LSM List <linux-security-module@vger.kernel.org>
Subject: Re: + smack-version-11c-simplified-mandatory-access-control-kernel.patch
 added to -mm tree
References: <335711.34116.qm@web36610.mail.mud.yahoo.com>
In-Reply-To: <335711.34116.qm@web36610.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler wrote:
> --- Andrew Morgan <morgan@kernel.org> wrote:
>> I do have a question about whether one capability is sufficient in
>> general for MAC. Looking at the:
>>
>>   http://wt.xpilot.org/publications/posix.1e/download.html
>>
>> last draft, there are no less than 5 capabilities (p173) allocated for
>> MAC. Presumably there was a good reason for 5 and not 1 back then -
>> could you summarize what is different now?
>>     
> There are to my mind two important differences. The first is that
> my experiance with Trusted Irix (Trix from here on), which used (uses?)
> capabilities and MAC together, is that the granularity is lost on
> 99 44/100% of programs, programmers, evaluators, admins, and problems.
> You just don't get that many cases where it actually gets you anything
> to have less than all the MAC capabilities. Applications that care
> about MAC to the extent that they use the capabilities tend to use the
> lot, if not all the time, in certain circumstances. I'm afraid that
> I am not a major fan of fine grained privilege based on my experiance
> with it.
>
> The second and perhaps more important reason is that the POSIX
> draft assumed a Bell & LaPadula sensitivity model, or at least
> a model very much like it. What would CAP_MAC_DOWNGRADE mean on
> a Smack system configured:
>
>     OneHand      OtherHand    r---
>     OtherHand    GrippingHand r---
>     GrippingHand OneHand      r---
>   
Shout out to Niven & Pournelle :-)

> What would CAP_MAC_UPGRADE mean, for that matter? It's even worse
> to consider that the relationships can change.
>
> CAP_MAC_READ and CAP_MAC_WRITE still make sense, as does
> CAP_MAC_RELABEL_SUBJ. But if you have CAP_MAC_WRITE you can
> do pretty much the same damage as if you have CAP_MAC_RELABEL_SUBJ,
> and the other way around, and if you're not going to use one
> of the other capabilities after you find out interesting things
> using CAP_MAC_READ it's hard to figure why you'd bother.
>   
All of that assumes a hierarchical security model (BLP, Biba). This
depends on whether you think "MAC" means:

    * specifically the hierarchical models BLP and Biba, or
    * any policy system where the rules are mandatory with respect to
      the users

The former would include SMACK, the venerable Argus Pitbull system (if
it ever gets ported to LSM), and the recent MLS work implemented on top
of FLASK. It would notably *not* include SELinux's Type Enforcement, 
AppArmor, or TOMOYO.

If you take the latter view (a I do) then the meaning of MAC_READ vs.
MAC_WRITE, and especially MAC_RELABEL_SUBJECT, becomes murky, e.g. I
have no clue WtF "relabel subject" means to AppArmor. But I can very
easily understand what "CAP_MAC_OVERRIDE" means to AppArmor.

So I'm with Casey; I support a simple 1-bit capability for MAC override.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin
CEO, Mercenary Linux		   http://mercenarylinux.com/
	       Itanium. Vista. GPLv3. Complexity at work

