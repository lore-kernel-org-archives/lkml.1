Return-Path: <linux-kernel-owner+w=401wt.eu-S1752046AbZL2Sgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbZL2Sgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 13:36:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbZL2Sgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 13:36:42 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:54052 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbZL2Sgl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 13:36:41 -0500
To: Bryan Donlan <bdonlan@gmail.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Michael Stone <michael@laptop.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       David Lang <david@lang.hm>, Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>, Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>, Pavel Machek <pavel@ucw.cz>,
       Al Viro <viro@zeniv.linux.org.uk>
References: <20091229050114.GC14362@heat> <m1y6km11lj.fsf@fess.ebiederm.org>
	<20091229151146.GA32153@us.ibm.com>
	<3e8340490912290805s103fb789y13acea4a84669b20@mail.gmail.com>
	<20091229163939.GA6984@us.ibm.com>
	<3e8340490912290901y60d7daf2w5778c25f44972955@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 29 Dec 2009 10:36:31 -0800
In-Reply-To: <3e8340490912290901y60d7daf2w5778c25f44972955@mail.gmail.com> (Bryan Donlan's message of "Tue\, 29 Dec 2009 12\:01\:39 -0500")
Message-ID: <m1fx6ty6ds.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Bryan Donlan <bdonlan@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: RFC: disablenetwork facility. (v4)
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Donlan <bdonlan@gmail.com> writes:

> On Tue, Dec 29, 2009 at 11:39 AM, Serge E. Hallyn <serue@us.ibm.com> wrote:
>> Quoting Bryan Donlan (bdonlan@gmail.com):
>>> On Tue, Dec 29, 2009 at 10:11 AM, Serge E. Hallyn <serue@us.ibm.com> wrote:
>>> > Eric, let me specifically point out a 'disable setuid-root'
>>> > problem on linux: root still owns most of the system even when
>>> > it's not privileged.  So does "disable setuid-root" mean
>>> > we don't allow exec of setuid-root binaries at all, or that
>>> > we don't setuid to root, or that we just don't raise privileges
>>> > for setuid-root?
>>>
>>> I, for one, think it would be best to handle it exactly like the
>>> nosuid mount option - that is, pretend the file doesn't have any
>>> setuid bits set. There's no reason to deny execution; if the process
>>> would otherwise be able to execute it, it can also copy the file to
>>> make a non-suid version and execute that instead. And some programs
>>> can operate with reduced function without setuid. For example, screen
>>> comes to mind; it needs root to share screen sessions between multiple
>>> users, but can operate for a single user just fine without root, and
>>> indeed the latter is usually the default configuration.
>>
>> That's fine with me, seems safe for a fully unprivileged program to
>> use, and would make sense to do through one of the securebits set
>> with prctl(PR_SET_SECUREBITS).
>>
>> In addition, I assume we would also refuse to honor file capabilities?
>
> Yes - essentially a one-time switch saying "never allow me to gain
> capabilities again".

That is what I was thinking.  Does setresuid case problems?  Assuming
the application that drop permissions could have successfully
called setresuid?

Ignoring the bits instead of honoring them when execing an executable
makes sense as that is the existing precedent.

If it works prctl appears to be a fine interface.

Eric
