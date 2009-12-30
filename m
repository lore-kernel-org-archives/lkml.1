Return-Path: <linux-kernel-owner+w=401wt.eu-S1752001AbZL3E6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbZL3E6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 23:58:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbZL3E6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 23:58:14 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:38769 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbZL3E6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 23:58:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=KzDTjtQ+HYVHK3pYVN0GbBnrfREDTymApiwiG0CBVF+wQOTEeb931lEplbKUcpslxj
         8zkfRa5XJL1j18w8eANY9T4rbHmqjnGs3C/9ZSNfMHiO10LjFZhXZUKJUpDQoRCMKI6N
         e51ql3R8uShPdEWzmzehpsGpft7h+ZEejh3Ss=
MIME-Version: 1.0
In-Reply-To: <m1r5qdt721.fsf@fess.ebiederm.org>
References: <20091229050114.GC14362@heat> <3e8340490912290805s103fb789y13acea4a84669b20@mail.gmail.com> 
	<m3oclhzgm4.fsf@ursa.amorsen.dk> <m17hs5y0mg.fsf@fess.ebiederm.org> 
	<20091229211139.0732a0c1@lxorguk.ukuu.org.uk> <m1iqbpwjtp.fsf@fess.ebiederm.org> 
	<20091229223631.GB22578@us.ibm.com> <m1aax1uoa3.fsf_-_@fess.ebiederm.org> 
	<3e8340490912291954v5a837a26p64bd776102d281d7@mail.gmail.com> 
	<m1r5qdt721.fsf@fess.ebiederm.org>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Tue, 29 Dec 2009 23:57:50 -0500
Message-ID: <3e8340490912292057g3e87eaabn115f85b78af2b08c@mail.gmail.com>
Subject: Re: [RFC][PATCH] Unprivileged: Disable acquisition of privileges
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Benny Amorsen <benny+usenet@amorsen.dk>,
       Michael Stone <michael@laptop.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
       Oliver Hartkopp <socketcan@hartkopp.net>,
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 29, 2009 at 11:33 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Bryan Donlan <bdonlan@gmail.com> writes:
>
>> Is this sufficient for other security models such as selinux or
>> TOMOYO? Can processes in these models gain privileges through means
>> not restricted here?
>
> The LSM is primarily about returning -EPERM more often.
> Except for the prctl and the capability hooks I am not aware
> of anywhere a LSM can increase a processes capabilities.

I'm more concerned about a case where a privilege that the LSM
currently denies is lifted by execing some executable - this is still
an increase in privilege, even though the LSM only adds additional
restrictions. That is:

1) Initial state: LSM denies access to /somefile (although normal
POSIX permissions would permit access)
2) Disable capability-gaining
3) Disable network access with proposed API
4) Exec some application, which is labeled in a way that permits
access to /somefile
5) Application fails to access the network, then does something to /somefile

I'm not entirely sure if step 4) can happen in any of the currently
existing LSMs - if it's not possible to gain privileges in them via a
suid-like mechanism, this isn't a problem, but it's something that
needs to be checked for.
