Return-Path: <linux-kernel-owner+w=401wt.eu-S1752004AbZL3DzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbZL3DzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 22:55:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbZL3DzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 22:55:24 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52345 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbZL3DzX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 22:55:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=IK4RBgFKwfld8x9/8cel7q5ZRr/IUTs5vqGhnEVW6tUrGGOfyHPbDKLvcdhwxFSjD4
         /ZuGcrtLJezaHRPSUToy2HfF88cClEQUh5Z/EW+iY1qMdkAgDVW6w9qsPambVU+63DPN
         9zPOWz1YF+oo7/3OyVZrn0UUIItSwomk9p6pU=
MIME-Version: 1.0
In-Reply-To: <m1aax1uoa3.fsf_-_@fess.ebiederm.org>
References: <20091229050114.GC14362@heat> <m1y6km11lj.fsf@fess.ebiederm.org> 
	<20091229151146.GA32153@us.ibm.com> <3e8340490912290805s103fb789y13acea4a84669b20@mail.gmail.com> 
	<m3oclhzgm4.fsf@ursa.amorsen.dk> <m17hs5y0mg.fsf@fess.ebiederm.org> 
	<20091229211139.0732a0c1@lxorguk.ukuu.org.uk> <m1iqbpwjtp.fsf@fess.ebiederm.org> 
	<20091229223631.GB22578@us.ibm.com> <m1aax1uoa3.fsf_-_@fess.ebiederm.org>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Tue, 29 Dec 2009 22:54:59 -0500
Message-ID: <3e8340490912291954v5a837a26p64bd776102d281d7@mail.gmail.com>
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 29, 2009 at 10:35 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> If we can know that a process will never raise it's priveleges we can
> enable a lot of features that otherwise would be unsafe, because they
> could break assumptions of existing suid executables.
>
> To allow this to be used as a sand boxing feature also disable
> ptracing other executables without this new restriction.
>
> For the moment I have used a per thread flag because we are out of per
> process flags.
>
> To ensure all descendants get this flag I rely on the default copying
> of procss structures.
>
> The disabling of suid executables is exactly the same as MNT_NOSUID.
>
> This should be what we have been talking about in for disabling of
> suid exec.  I choose not to use securebits as that interface requires
> privilege and assumes capabilities.  This implementation is more basic
> than capabilities and only adds additional sanity checks when
> linux capabilities are not present.
>
> I attempt to ensure there are no mixed priveleges present, when we
> perform the disable so I don't need to handle or think about
> interactions with setreuid or capabilities in this code.

Is this sufficient for other security models such as selinux or
TOMOYO? Can processes in these models gain privileges through means
not restricted here?

Also, perhaps there should be a corresponding GET prctl?
