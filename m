Return-Path: <linux-kernel-owner+w=401wt.eu-S1752023Ab0AAAMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab0AAAMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 19:12:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751078Ab0AAAMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 19:12:49 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:47469 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab0AAAMs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 19:12:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=N5mnNnDwRYTQ6r3rlUDqtf36jEmz/hLF2C2YbspuVeOqSfp82yUadC53c6v47GQuwM
         9D8c0ytrC++GShe/BibNk23I3dqi6F9GcLgMvpXKfGrRfM99T+Vl4M3MgQu7UtLCZzFB
         dJBuEbCERM9FTYYrCB23V0Wj1+J3Si6mxtsI0=
MIME-Version: 1.0
In-Reply-To: <20091231170641.6dd46c6e@lxorguk.ukuu.org.uk>
References: <m1iqbpwjtp.fsf@fess.ebiederm.org>
	 <m1fx6suswz.fsf@fess.ebiederm.org> <20091230201712.GA23999@us.ibm.com>
	 <m1hbr8tb8q.fsf_-_@fess.ebiederm.org>
	 <20091230212931.233003b9@lxorguk.ukuu.org.uk>
	 <m1skasrvnq.fsf@fess.ebiederm.org>
	 <20091230230042.5d2e78ac@lxorguk.ukuu.org.uk>
	 <m2bphfti1u.fsf@ssh.synack.fr>
	 <e7d8f83e0912310608j2c52acabxbd57d24e2b3073ca@mail.gmail.com>
	 <20091231170641.6dd46c6e@lxorguk.ukuu.org.uk>
Date: Fri, 1 Jan 2010 10:12:44 +1000
Message-ID: <e7d8f83e0912311612t57477fc7g1bc74cc9067b71ec@mail.gmail.com>
Subject: Re: [RFC][PATCH v3] Unprivileged: Disable raising of privileges
From: Peter Dolding <oiaohm@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Samir Bellabes <sam@synack.fr>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Andrew G. Morgan" <morgan@kernel.org>,
       Bryan Donlan <bdonlan@gmail.com>,
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
       Casey Schaufler <casey@schaufler-ca.com>, Pavel Machek <pavel@ucw.cz>,
       Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 1, 2010 at 3:06 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Lets step back for a moment.  What is the common issue with both.
>>
>> The issue is simple.  "How to I generically tell the secuirty system
>> want particular restrictions."
>
> You don't. It's not "the security system", its a whole collection of
> completely different models of security and differing tools.
>
>> There is no generic LSM API for application or users to talk to the
>> LSM and say I want the following restricted.
>
> That's a meaningless observation I think because security doesn't work
> that way. Removing specific features from a specific piece of code
> generally isn't a security feature - its only meaningful in the context
> of a more general policy and that policy expression isn't generic.
>
Sandboxing it has meaning.  The LSM section of the Linux secuirty
system is out of reach of applications to talk to generically.  They
can use capabilities they can use DAC they can even talk generically
to the firewall.

>> To control the LSM the applications are expected to know what the LSM.
>>  This has caused items like chrome major issues.
>
> ..
>
>> Application does not need to be informed what is disabled from it.
>
> So why does it cause chrome problems ?
>
>
They were trying to create a sandbox inside there applications.

> There are multiple security models because nobody can agree on what they
> should look like, just like multiple desktops. Each of them is based on a
> totally different conceptual model so the idea of a single interface to
> them is a bit meaningless.
>
Bad argument flawed one and in breach of LSM API basic idea.

All the secuirty modules are using generic hooks.   All these patches
are duplications of generic hooks because applications and users
cannot control the generic hooks.  All your answer is use the LSM
because it already has the hook there.   Problem is they cannot
generically.   So LSM is failing to make LSM generic enough for all
requirements.

The interface I am talking about does not give a rats about 90 percent
of the secuirty module.   So if they want completely different
conceptual ideas there go for it.

Generic is the following.
Means for applications  or users to say I don't want to use any off
the following locations that LSM has hooks.   Everything in the
generic has to exist as LSM hooks.

Now a generic LSM interface for applications and users the LSM is free
to use the application and users provided data how they choose this
include disregarding just like file capabilities can be disabled.

API call is one way.   Section in the ELF file is another ie elf
having text data secuirty.  The section design has to be LSM generic
as well.  Lets say a LSM does not have a profile for an application it
sees that application comes with a secuirty section so is able to pick
this up and use this as a rough profile.

The generic is having nothing todo with role based secuirty controls
or inheritance of permissions to be correct the LSM is free to apply
those limitations over the top.

In some cases an application declaring in advance what features they
need could protect end users from data lose from LSM termination.
Reason the application did not start in the first place.  The biggest
headache with setting up non standard LSM  correctly is that
applications have no way of declaring a list of what they need and
don't need in a LSM generic way.

Everything in the generic interfaces for users and applications would
relate directly to the raw generic LSM hooks not to the security model
being applied past that.  This is not crossing into LSM turf.

I don't want to be inside the LSM turf when coding inside an
application and need to sandbox just need to tell the LSM that from
here on must be restricted.  Preferable in a way that is LSM generic.
I don't want as a application design to having to create rules for
every LSM in existance with verations for each distributions idea of
role base secuirty and the like.

Be truthful LSM hooks are a lot finer than capabilities and can cut a
lot more things off from applications.

Exactly what secuirty advantage is served by applications not being
able to talk to the LSM module in a generic way?
None that I know of.  If there is some please tell me.   But I can
think of plenty that can be served by applications being able to talk
to and provide generic information.

1) Simpler LSM configuration this is one of the biggest bug bears of LSM.
2) Less data loss from LSM configured wrong ie application being able
to provide list of what it needs so admin does not restrict it too
much.  It might take months it use a feature that causes the LSM to
terminate an application.
3) Sandboxing inside applications that works fairly simply for
application developers.
4) Windows managers and the like able to provide users with options
like networking on particular applications disabled on user demard in
a generic way.   Things that cannot always rewritten into policy.
Some applications users will want to run different ways depending on
what they are doing.  Like you might want to run a download manager
with networking disabled even that you are online because you are on a
voip call and you don't want it starting up downloading stuff.
5) Anti-virus/Anti-malware being able to apply restrictions to items
detected as suspect even if user decided to keep on running it in a
generic way.
6) Option to reduce how much in LSM secuirty configuration data has to
be LSM unique.  If lets say LSMs would use a secuirty section in the
elf data as part of there application config.   Any alteration in the
generic data would apply to all the LSM support it at once.  Less
duplication of data is better.  Lower the duplication less risk of
maintainer errors when updating LSM secuirty information.

Of course providing all this not one removes the need for role based
secuirty and the like over the top its in the role based secuiryt and
the like where LSM want to fight.  Let them lets just not cripple
users secuirty control while in use just because those guys cannot get
to a common design.  Yes applying what I say might cause a higher
level inside LSM's to become generic.  This would be LSM completing it
goals of being generic.  It exists to encourage generic methods in the
LSM modules.

Peter Dolding
