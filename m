Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbXKXLix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbXKXLix (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 06:38:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbXKXLin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 06:38:43 -0500
Received: from mail8.dotsterhost.com ([66.11.233.1]:56789 "HELO
	mail8.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754191AbXKXLil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 06:38:41 -0500
Message-ID: <47480D76.8030701@crispincowan.com>
Date: Sat, 24 Nov 2007 03:39:34 -0800
From: Crispin Cowan <crispin@crispincowan.com>
Organization: Crispin's Labs
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morgan <morgan@kernel.org>
CC: casey@schaufler-ca.com, Stephen Smalley <sds@tycho.nsa.gov>,
       "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       chrisw@sous-sol.org, darwish.07@gmail.com, jmorris@namei.org,
       method@manicmethod.com, paul.moore@hp.com,
       LSM List <linux-security-module@vger.kernel.org>
Subject: Re: + smack-version-11c-simplified-mandatory-access-control-kernel.patch
 added to -mm tree
References: <335711.34116.qm@web36610.mail.mud.yahoo.com> <4747C003.3070709@kernel.org>
In-Reply-To: <4747C003.3070709@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morgan wrote:
> Its not so much why you are wrong, as being clear that we're not using a
> generic name and inadvertently limiting ourselves to a SMACK-like model...
>   
It seems we all agree that it is a bad idea to tie a POSIX Capability to
one specific LSM model.

> It feels to me as if a MAC "override capability" is, if true to its
> name, extra to the MAC model; any MAC model that needs an 'override' to
> function seems under-specified...
An interesting observation. This is a core part of why I have always
found the hierarchical models BLP and Biba to be unsatisfying. These
systems essentially have one simple fixed policy "process label must
dominate object label to get access", and then you express all the rest
of your "policy" by labeling your stuff. It is impossible to manage such
systems without a MAC_OVERRIDE escape hatch of some kind, because the
"policy" is too simple and inflexible, e.g. it does not allow you to
reclassify anything.

>  SELinux clearly feels no need for one,
>   
That's not quite right. More specifically, it already has one in the
form of unconfined_t. AppArmor has a similar escape hatch in the "Ux"
permission. Its not that they don't need one, it is that they already
have one. They get to have one because they allow you to actually write
a policy that is more nuanced than "process label must dominate object
label".

> and browsing through your SMACK patch, there are many instances where
> this capability is used as an convenience privileged override. However,
> in other situations, it appears as if the capability is required for
> basic SMACK operations to succeed.
>
> My sense is that there is a case to be made for: CAP_MAC_ADMIN and
> CAP_MAC_OVERRIDE here. The former being for cases where SMACK (or
> whatever MAC supports it) requires privilege to perform a privileged MAC
> operation, and the latter for saying "OK, I'm without a paddle but need
> one" (or words to that effect).
>   
I don't get the difference. Both seem to permit the process to violate
the MAC policy. I could make up a meaning for MAC_ADMIN that is
different from MAC_OVERRIDE in the AppArmor sense, but I don't want to
:-) and worse, I suspect the distinction would be different for each
LSM. So let not, and just have one MAC_OVERRIDE capability.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin
CEO, Mercenary Linux		   http://mercenarylinux.com/
	       Itanium. Vista. GPLv3. Complexity at work

