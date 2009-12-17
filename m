Return-Path: <linux-kernel-owner+w=401wt.eu-S1754402AbZLQTxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402AbZLQTxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 14:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbZLQTx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 14:53:26 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:60890 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbZLQTxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 14:53:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Jt45vy3x3O6/BoRjB7Wpnwxf6GkX03Cky9lGFCXQjn++Gkz3XS7dLTHBILFNQ/zTMH
         msZ3btyJHUz7LeE9BIkXIBwqP+OUqF+PIPReiTHn7juh4GfNS6jK6xjRPTycCs0LVXoD
         YiqPEEhz36F7B9gT9S75aCLNoicFlqrg0OF8w=
MIME-Version: 1.0
In-Reply-To: <1261078517.4073.32.camel@giskard.codewiz.org>
References: <m1ljh7jijk.fsf@fess.ebiederm.org> <20091213142149.GB4777@heat> 
	<fb69ef3c0912170931l5cbf0e3dh81c88e6502651042@mail.gmail.com> 
	<3e8340490912171024n2120e88q569c69fe7d09140f@mail.gmail.com> 
	<1261078517.4073.32.camel@giskard.codewiz.org>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Thu, 17 Dec 2009 14:53:00 -0500
Message-ID: <3e8340490912171153s56e966d6lb76041fefc52e735@mail.gmail.com>
Subject: Re: Network isolation with RLIMIT_NETWORK, cont'd.
To: Bernie Innocenti <bernie@codewiz.org>
Cc: Mark Seaborn <mrs@mythic-beasts.com>, Michael Stone <michael@laptop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       David Lang <david@lang.hm>, Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       =?ISO-8859-1?Q?R=E9mi_Denis=2DCourmont?= <rdenis@simphalempin.com>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>,
       Linux Containers <containers@lists.osdl.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 2:35 PM, Bernie Innocenti <bernie@codewiz.org> wrote:
> On Thu, 2009-12-17 at 13:24 -0500, Bryan Donlan wrote:
>> Can this be done using openat() and friends currently? It would seem
>> the natural way to implement this; open /proc/(pid)/root, then
>> openat() things from there (or even chdir to it and see the mounts
>> that it sees from there...)
>
> Yeah, but /proc/<pid>/root is just a symlink. It's correct for chroots,
> but I doubt it can be meaningful for per-process namespaces.

The files in /proc/<pid>/fs are 'just symlinks', but opening them can
provide access to objects (eg, deleted files) not accessible through
the normal filesystem namespace. I see no reason, API-wise, why
/proc/<pid>/root couldn't be extended similarly - but I've not looked
at the namespaces implementation, so maybe there's some reason it'd be
difficult to implement...
