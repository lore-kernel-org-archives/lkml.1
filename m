Return-Path: <linux-kernel-owner+w=401wt.eu-S1752559AbZL2RCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbZL2RCH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 12:02:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbZL2RCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 12:02:06 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:39653 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbZL2RCC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 12:02:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=k4Gw1BIn0pLDlQU3hNmaTuOD20gmF+6yKAIw4ABVGnetkPTqTqNdrPe6j8rv36XzyI
         qFBTfij+VZoCrvkdLvJu6arOpHVzHChyS6ggf6L/PxEwrh2zg+MAB/P/zmCzh9oc6O1W
         U/y9fmXL+n0g6d9seYk97vZyFw/Ff6qlGKys4=
MIME-Version: 1.0
In-Reply-To: <20091229163939.GA6984@us.ibm.com>
References: <20091229050114.GC14362@heat> <m1y6km11lj.fsf@fess.ebiederm.org> 
	<20091229151146.GA32153@us.ibm.com> <3e8340490912290805s103fb789y13acea4a84669b20@mail.gmail.com> 
	<20091229163939.GA6984@us.ibm.com>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Tue, 29 Dec 2009 12:01:39 -0500
Message-ID: <3e8340490912290901y60d7daf2w5778c25f44972955@mail.gmail.com>
Subject: Re: RFC: disablenetwork facility. (v4)
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Michael Stone <michael@laptop.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
       Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>, Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>, Pavel Machek <pavel@ucw.cz>,
       Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 29, 2009 at 11:39 AM, Serge E. Hallyn <serue@us.ibm.com> wrote:
> Quoting Bryan Donlan (bdonlan@gmail.com):
>> On Tue, Dec 29, 2009 at 10:11 AM, Serge E. Hallyn <serue@us.ibm.com> wrote:
>> > Eric, let me specifically point out a 'disable setuid-root'
>> > problem on linux: root still owns most of the system even when
>> > it's not privileged.  So does "disable setuid-root" mean
>> > we don't allow exec of setuid-root binaries at all, or that
>> > we don't setuid to root, or that we just don't raise privileges
>> > for setuid-root?
>>
>> I, for one, think it would be best to handle it exactly like the
>> nosuid mount option - that is, pretend the file doesn't have any
>> setuid bits set. There's no reason to deny execution; if the process
>> would otherwise be able to execute it, it can also copy the file to
>> make a non-suid version and execute that instead. And some programs
>> can operate with reduced function without setuid. For example, screen
>> comes to mind; it needs root to share screen sessions between multiple
>> users, but can operate for a single user just fine without root, and
>> indeed the latter is usually the default configuration.
>
> That's fine with me, seems safe for a fully unprivileged program to
> use, and would make sense to do through one of the securebits set
> with prctl(PR_SET_SECUREBITS).
>
> In addition, I assume we would also refuse to honor file capabilities?

Yes - essentially a one-time switch saying "never allow me to gain
capabilities again".
