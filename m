Return-Path: <linux-kernel-owner+w=401wt.eu-S1752273AbZL3D0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbZL3D0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 22:26:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbZL3D0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 22:26:22 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:59586 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbZL3D0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 22:26:21 -0500
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Benny Amorsen <benny+usenet@amorsen.dk>,
       Bryan Donlan <bdonlan@gmail.com>, Michael Stone <michael@laptop.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       David Lang <david@lang.hm>, Oliver Hartkopp <socketcan@hartkopp.net>,
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
	<m3oclhzgm4.fsf@ursa.amorsen.dk> <m17hs5y0mg.fsf@fess.ebiederm.org>
	<20091229211139.0732a0c1@lxorguk.ukuu.org.uk>
	<m1iqbpwjtp.fsf@fess.ebiederm.org> <20091229223631.GB22578@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 29 Dec 2009 19:26:02 -0800
In-Reply-To: <20091229223631.GB22578@us.ibm.com> (Serge E. Hallyn's message of "Tue\, 29 Dec 2009 16\:36\:31 -0600")
Message-ID: <m1zl51uoqd.fsf@fess.ebiederm.org>
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
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: RFC: disablenetwork facility. (v4)
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
>> 
>> >> > Execute != read. The executable file may contain secrets which must not
>> >> > be available to the user running the setuid program. If you fail the
>> >> > setuid, the user will be able to ptrace() and then the secret is
>> >> > revealed.
>> >> >
>> >> > It's amazing how many security holes appear from what seems like a very
>> >> > simple request.
>> >> 
>> >> Do we have a security hole in nosuid mount option?
>> >> Can someone write a patch to fix it?
>> >
>> > If a setuid app can read a key when its erroneously not set setuid then
>> > the user can read it too.
>> >
>> > Anything you can do with ptrace you can do yourself !
>> 
>> Now that I think about it this is really something completely separate
>> from setuid.  This is about being able to read the text segment with
>> ptrace when you on have execute permissions on the file.
>> 
>> I just skimmed through fs/exec.c and we set the undumpable process
>> flag in that case so ptrace should not work in that case.
>
> And in fact you can't do a new ptrace_attach, but if you're already
> tracing the task when it execs the unreadable-but-executable file,
> then the ptrace can continue.
>
> Just looking at the code, it appears 2.2 was the same way (though I
> could be missing where it used to enforce that).
>
> So, is that intended?  What exactly would we do about it if not?
> Just refuse exec of a unreadable-but-executable file if we're
> being traced?

In common cap we drop the new capabilities if we are being ptraced.
Look for brm->unsafe.

Eric
