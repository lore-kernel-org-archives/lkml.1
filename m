Return-Path: <linux-kernel-owner+w=401wt.eu-S1752794AbZL2LGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbZL2LGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 06:06:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbZL2LGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 06:06:46 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:55894 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbZL2LGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 06:06:45 -0500
To: Michael Stone <michael@laptop.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
       Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>, Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>, Pavel Machek <pavel@ucw.cz>,
       Al Viro <viro@ZenIV.linux.org.uk>
References: <20091229050114.GC14362@heat>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 29 Dec 2009 03:06:16 -0800
In-Reply-To: <20091229050114.GC14362@heat> (Michael Stone's message of "Tue\, 29 Dec 2009 00\:01\:14 -0500")
Message-ID: <m1y6km11lj.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Michael Stone <michael@laptop.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: RFC: disablenetwork facility. (v4)
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Stone <michael@laptop.org> writes:

> Serge,
>
> I think that Pavel's point, at its strongest and most general, could be
> rephrased as:
>
>   "Adding *any* interesting isolation facility to the kernel breaks backwards
>    compatibility for *some* program [in a way that violates security goals]."

*some* privileged program.

> The reason is the one that I identified in my previous note:
>
>   "The purpose of isolation facilities is to create membranes inside which
>    grievous security faults are converted into availability faults."
>
> The question then is simply:
>
>   "How do we want to deal with the compatibility-breaking changes created by
>    introducing new isolation facilities?"

You have a very peculiar taxonomy of the suggestions,
that fails to capture the concerns.

I strongly recommend working out a way to disable
setuid exec.  Ideally we would use capabilities to
achieve this.  

Serge can we have a capability that unprivelged processes
normally have an can drop without privelege?

I can see one of two possible reasons you are avoiding the
suggestion to disable setuid root.
- You have a use for setuid root executables in your contained
  environment.  If you do what is that use?
- Disabling suid root executables is an indirect path to your
  goal.

The problem with the disable_network semantics you want
is that they allow you to perform a denial of service attack
on privileged users.  An unprivileged DOS attack is unsuitable
for a general purpose feature in a general purpose kernel.

Your sysctl, your boot option, your Kconfig option all fail
to be viable options for the same reason.  Your facility is
only valid in an audited userspace.

Disabling setuid-exec especially to a subset of processes is
valid in an unaudited userspace as it does not allow propagating
the DOS to privileged processes.

Eric
