Return-Path: <linux-kernel-owner+w=401wt.eu-S1751647AbZL2SER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbZL2SER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 13:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbZL2SEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 13:04:16 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:60237 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbZL2SEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 13:04:14 -0500
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Michael Stone <michael@laptop.org>, linux-kernel@vger.kernel.org,
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
References: <20091229050114.GC14362@heat> <m1y6km11lj.fsf@fess.ebiederm.org>
	<20091229151146.GA32153@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 29 Dec 2009 10:03:57 -0800
In-Reply-To: <20091229151146.GA32153@us.ibm.com> (Serge E. Hallyn's message of "Tue\, 29 Dec 2009 09\:11\:46 -0600")
Message-ID: <m1pr5xy7w2.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serue@us.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: RFC: disablenetwork facility. (v4)
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:
>
> I have two comments on the idea:
>
> 1. We don't want to complicate the current capabilities
>    concepts and API, so if we do something like this,
>    we should make sure not to try to store these
>    unprivileged capabilities with the current privilege
>    capabilities.

I was afraid there might be a complication like that.
Then the user interface side of what I am proposing
needs some more thought.

> In my last email last night I detailed a way to use regular
> capabilities to make the prctl(PR_SET_NETWORK, PR_DROP_NET)
> safer.

Yes.  I missed that earlier my apologies.

>> I can see one of two possible reasons you are avoiding the
>> suggestion to disable setuid root.
>> - You have a use for setuid root executables in your contained
>>   environment.  If you do what is that use?
>
> I don't think Michael was avoiding that.  Rather, we haven't quite
> spelled out what it means to disable setuid root, and we haven't
> (to my satisfaction) detailed how setuid root would undo the
> prctl(PR_SET_NETWORK, PR_DROP_NET) - i.e. is it only on a
> privilege-granting setuid-root, or all setuids?

Michael finds suid-root granting network access incompatible
with what he is trying to achieve.  The practical example is
network denied applications may communicate with the outside
world by calling ping.

> Eric, let me specifically point out a 'disable setuid-root'
> problem on linux: root still owns most of the system even when
> it's not privileged.  So does "disable setuid-root" mean
> we don't allow exec of setuid-root binaries at all, or that
> we don't setuid to root, or that we just don't raise privileges
> for setuid-root?

The semantics I am suggesting under the title "disable suid exec" are
to flag a process such that, that process and any future children may
not increase their kernel enforced privileges.  In practice this means
attempts to exec any suid binaries will fail.  Likewise attempting to
exec a binary flagged with in the filesystem to gain capabilities will
also fail.

This would appear to require denying of ptracing applications
with other/more privileges, failing attempts to raise the
capabilities on one of the processes, and I think failing
all setuid/setgid calls.

In my conception this is a useful subset of unshare(USERNS) that can
be easily implemented now.

>> - Disabling suid root executables is an indirect path to your
>>   goal.
>> 
>> The problem with the disable_network semantics you want
>> is that they allow you to perform a denial of service attack
>> on privileged users.  An unprivileged DOS attack is unsuitable
>> for a general purpose feature in a general purpose kernel.
>
> Though to be honest I'm still unconvinced that the disablenetwork
> is dangerous.  I think long-term a more general solution like what
> I outlined above might be good, but short-term a sysctl that
> turns on or off the ability to drop network would suffice imo.

I have seen the following arguments put forth.
  - Certain kinds of logging are broken from suid executables.
  - Certain questionable but existing user space authentication
    policies will be broken.

That is enough for me to strongly suspect someone with a more
devious mind than myself could find something worse.  I know
it took me over a year to figure out how someone could exploit
unshare(NETNS).

The goal is to find something that unprivileged applications can use
safely, and can be available by default in distro kernels.

A syscall that removes the ability to exec suid executables appears to
meet that goal, as well as be the necessary prerequisite for enabling
other forms of isolation without causing security problems.

Eric
