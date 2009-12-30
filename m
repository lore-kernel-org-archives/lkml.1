Return-Path: <linux-kernel-owner+w=401wt.eu-S1753482AbZL3VM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbZL3VM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 16:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbZL3VMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 16:12:55 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:45638 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbZL3VMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 16:12:54 -0500
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
       =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>, Pavel Machek <pavel@ucw.cz>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: RFC: disablenetwork facility. (v4)
References: <20091229151146.GA32153@us.ibm.com>
	<3e8340490912290805s103fb789y13acea4a84669b20@mail.gmail.com>
	<m3oclhzgm4.fsf@ursa.amorsen.dk> <m17hs5y0mg.fsf@fess.ebiederm.org>
	<20091229211139.0732a0c1@lxorguk.ukuu.org.uk>
	<m1iqbpwjtp.fsf@fess.ebiederm.org> <20091229223631.GB22578@us.ibm.com>
	<m1zl51uoqd.fsf@fess.ebiederm.org> <20091230035008.GA6819@us.ibm.com>
	<m11vidulsq.fsf@fess.ebiederm.org> <20091230180045.GA14493@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 30 Dec 2009 13:12:33 -0800
In-Reply-To: <20091230180045.GA14493@us.ibm.com> (Serge E. Hallyn's message of "Wed\, 30 Dec 2009 12\:00\:45 -0600")
Message-ID: <m1my10tbcu.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> "Serge E. Hallyn" <serue@us.ibm.com> writes:
>> 
>> >> In common cap we drop the new capabilities if we are being ptraced.
>> >> Look for brm->unsafe.
>> >
>> > Yes - that isn't the issue.
>> 
>> Right.  Sorry.  I saw that we set unsafe and totally
>> missed that we don't act on it in that case.
>> 
>> > It goes back to finding a way to figure out what is inside the
>> > file when the installer obviously thought we shouldn't be able
>> > to read the file.
>> >
>> > Do we care?  <shrug>
>> 
>> <shrug>
>> 
>> I expect two lines of testing bprm->unsafe and failing
>> at the right point would solve that. 
>
> But what is the right response?  Prevent excecution?  Stop the
> tracer?  Enter some one-shot mode where the whole exec appears
> as one step, but tracing continues if execution continues on a
> dumpable file?

The whole exec should already appear as one step.

The right response is to either fail the exec or disable
the tracer.  Since the other case drops privs.  I expect
failing the exec is the simplest and most consistent thing
we can do.

Eric
