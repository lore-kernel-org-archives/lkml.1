Return-Path: <linux-kernel-owner+w=401wt.eu-S1752342AbZLaOIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbZLaOIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 09:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbZLaOIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 09:08:49 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:49675 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbZLaOIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 09:08:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=doyRIJcd//XTyX0GiD6+g0YrBurwUEArAGyDqMEzGdUYQ+55pmYzn6PF7nBlROSPzV
         po77PPthUXjCfdvZa1MS5qSh38ICNO49hFXMnAllCAabyalyqSJ8HM6xa8nVgLbhdJTa
         DUQk6XtefBpm74IQg+vNhYfzK+aZ62DZ0GseY=
MIME-Version: 1.0
In-Reply-To: <m2bphfti1u.fsf@ssh.synack.fr>
References: <m1iqbpwjtp.fsf@fess.ebiederm.org>
	 <551280e50912300652r1007dee0j8de750bf33af9b3c@mail.gmail.com>
	 <20091230183513.GC14493@us.ibm.com> <m1fx6suswz.fsf@fess.ebiederm.org>
	 <20091230201712.GA23999@us.ibm.com>
	 <m1hbr8tb8q.fsf_-_@fess.ebiederm.org>
	 <20091230212931.233003b9@lxorguk.ukuu.org.uk>
	 <m1skasrvnq.fsf@fess.ebiederm.org>
	 <20091230230042.5d2e78ac@lxorguk.ukuu.org.uk>
	 <m2bphfti1u.fsf@ssh.synack.fr>
Date: Fri, 1 Jan 2010 00:08:44 +1000
Message-ID: <e7d8f83e0912310608j2c52acabxbd57d24e2b3073ca@mail.gmail.com>
Subject: Re: [RFC][PATCH v3] Unprivileged: Disable raising of privileges
From: Peter Dolding <oiaohm@gmail.com>
To: Samir Bellabes <sam@synack.fr>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 31, 2009 at 11:00 PM, Samir Bellabes <sam@synack.fr> wrote:
> Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
>
>> Well to be fair its random regurgitated security idea of every year or
>> two.
>
> true, last year the same kind of discussion occurs with the 'personal
> firewall' aka a network MAC.
> http://marc.info/?t=123247387500003&r=3&w=2
> http://marc.info/?t=123187029200001&r=2&w=2

Lets step back for a moment.  What is the common issue with both.

The issue is simple.  "How to I generically tell the secuirty system
want particular restrictions."

There is no generic LSM API for application or users to talk to the
LSM and say I want the following restricted.   Of course the
restrictions have to be tighter than what the profiles already say.

To control the LSM the applications are expected to know what the LSM.
 This has caused items like chrome major issues.

Also by providing a generic LSM API there would be a base set of
requirements for a LSM to provide to meet the requirements of the
generic interfaces.

Basically until a generic interface to talk to LSM module is provided
these requests are going to keep coming.  Maybe assign secuirty ops
string values that applications can say disable the following secuirty
operations from me.

Application does not need to be informed what is disabled from it.

Peter Dolding
