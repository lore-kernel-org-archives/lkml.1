Return-Path: <linux-kernel-owner+w=401wt.eu-S1751526Ab0AJXlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab0AJXlf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 18:41:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751090Ab0AJXlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 18:41:35 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:53929 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab0AJXle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 18:41:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=BY6sbLv2W7tp0tzIymLgtTVhQMRuCYWX32DCVZvRDhysxktbYSrParImgXIFu0CbC3
         fumPA6VWHiNyMQnc5P7h2LhpIQir8cl6d1q4E8ihS7MSORoqhZbT4eIkDKPXCrTEWoLA
         N8IYkb1lF0g9/ouYUMyykeuD0OduqXxM0FrGY=
MIME-Version: 1.0
In-Reply-To: <20100110230839.GB3825@heat>
References: <f73f7ab81001101418x3b3f8652j256f6311ad6244c5@mail.gmail.com> 
	<20100110230839.GB3825@heat>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Sun, 10 Jan 2010 18:41:10 -0500
Message-ID: <3e8340491001101541tc776ad9r887be13393bcb7fd@mail.gmail.com>
Subject: Re: [PATCH 2/3] Security: Implement disablenetwork semantics. (v4)
To: Michael Stone <michael@laptop.org>
Cc: Kyle Moffett <kyle@moffetthome.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
       Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, Pavel Machek <pavel@ucw.cz>,
       Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 10, 2010 at 6:08 PM, Michael Stone <michael@laptop.org> wrote:
> Paraphrasing Kyle:
>
>> Suppose there exist PAM modules which lazily fork background processes.
>> Now
>> assume that one of those PAM modules is hooked from /etc/pam.d/su, that
>> the
>> module fails closed when the network is unavailable, and that Mallory wins
>> the race to start the daemon. Boom.
>
> I'm not disagreeing that there are configurations of programs, written for
> kernels without disablenetwork, which cease to be correct on kernels that
> provide it. However, all this says to me is that people who need to use
> those
> configurations probably shouldn't use disablenetwork. (Or that we haven't
> found
> exactly the right semantics for disablenetwork yet.)

With the semantics given, the choice for using disablenetwork is given
to the unprivileged process, not to the administrator or privileged
process, so people using these configurations have no choice - the
malicious local user can just use it anyway.

I still think requiring a drop of suid abilities would be best - if
the suid process wants to run in a no-network environment it can still
disablenetwork itself.
