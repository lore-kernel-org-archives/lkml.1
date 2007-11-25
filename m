Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbXKYDgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbXKYDgG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 22:36:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752876AbXKYDfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 22:35:55 -0500
Received: from mail8.dotsterhost.com ([66.11.233.1]:44603 "HELO
	mail8.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752741AbXKYDfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 22:35:54 -0500
Message-ID: <4748EDCB.90403@crispincowan.com>
Date: Sat, 24 Nov 2007 19:36:43 -0800
From: Crispin Cowan <crispin@crispincowan.com>
Organization: Crispin's Labs
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Kyle Moffett <mrmacman_g4@mac.com>
CC: Andrew Morgan <morgan@kernel.org>, casey@schaufler-ca.com,
       Stephen Smalley <sds@tycho.nsa.gov>,
       "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       chrisw@sous-sol.org, darwish.07@gmail.com, jmorris@namei.org,
       method@manicmethod.com, paul.moore@hp.com,
       LSM List <linux-security-module@vger.kernel.org>
Subject: Re: + smack-version-11c-simplified-mandatory-access-control-kernel.patch
 added to -mm tree
References: <335711.34116.qm@web36610.mail.mud.yahoo.com> <4747C003.3070709@kernel.org> <47480D76.8030701@crispincowan.com> <823A64A2-C962-403C-A0EB-95EA79B2DB91@mac.com>
In-Reply-To: <823A64A2-C962-403C-A0EB-95EA79B2DB91@mac.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
> On Nov 24, 2007, at 06:39:34, Crispin Cowan wrote:
>> Andrew Morgan wrote:
>>> It feels to me as if a MAC "override capability" is, if true to its
>>> name, extra to the MAC model; any MAC model that needs an 'override'
>>> to function seems under-specified... SELinux clearly feels no need
>>> for one,
>> That's not quite right. More specifically, it already has one in the
>> form of unconfined_t. AppArmor has a similar escape hatch in the "Ux"
>> permission. Its not that they don't need one, it is that they already
>> have one. They get to have one because they allow you to actually
>> write a policy that is more nuanced than "process label must dominate
>> object label".
> Actually, a fully-secured strict-mode SELinux system will have no
> unconfined_t processes; none of my test systems have any.  Generally
> "unconfined_t" is used for situations similar to what AppArmor was
> designed for, where the only "interesting" security is that of the
> daemon (which is properly labelled) and one or more of the users are
> unconfined.
Interesting. In a Targeted Policy, you do your policy administration
from unconfined_t. But how do you administer a Strict Policy machine? I
can think of 2 ways:

    * reboot to single user and hack away
          o hurts usability because you need physical presence to change
            policy, but is highly secure
    * there is some type that is tighter than unconfined_t but none the
      less has sufficient privilege to change policy
          o to me, this would be semantically equivalent to
            unconfined_t, because any rogue code or user with this type
            could then fabricate unconfined_t and do what they want


> Even then "unconfined_t" is not an implicit part of the policy, it is
> explicitly given the ability to take any action on any object by rules
> in the policy, and it typically still falls under a few MLS labeling
> restrictions even in the targeted policy.
Which is more or less the distinction I was trying to draw between
hierarchical systems (MLS) and policy systems (SELinux TE, AppArmor,
etc.) that policy systems let you write yourself an escape hatch in
policy, and MLS systems don't. Or at least they need to kludge something :)

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin
CEO, Mercenary Linux		   http://mercenarylinux.com/
	       Itanium. Vista. GPLv3. Complexity at work

