Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995Ab0ALPxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab0ALPxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 10:53:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548Ab0ALPxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 10:53:11 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:45179 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab0ALPxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 10:53:09 -0500
Date: Tue, 12 Jan 2010 09:52:46 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Michael Stone <michael@laptop.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       David Lang <david@lang.hm>, Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>, Pavel Machek <pavel@ucw.cz>,
       Al Viro <viro@ZenIV.linux.org.uk>, Kyle Moffett <kyle@moffetthome.net>
Subject: Re: [PATCH 2/3] Security: Implement disablenetwork semantics. (v4)
Message-ID: <20100112155246.GA9255@us.ibm.com>
References: <20100111174922.GA17285@us.ibm.com>
 <20100112061058.GA5231@heat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100112061058.GA5231@heat>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Michael Stone (michael@laptop.org):
> Serge Hallyn wrote:
> >Michael, I'm sorry, I should go back and search the thread for the
> >answer, but don't have time right now - do you really need
> >disablenetwork to be available to unprivileged users?
> 
> Rainbow can only drop the networking privileges when we know at app launch time
> (e.g. based on a manifest or from the human operator) that privileges can be
> dropped. Unfortunately, most of the really interesting uses of disablenetwork
> happen *after* rainbow has dropped privilege and handed control the app.
> Therefore, having an API which can be used by at least some low-privilege
> processes is important to me.
> 
> >is it ok to require CAP_SETPCAP (same thing required for dropping privs from
> >bounding set)?
> 
> Let me try to restate your idea:
> 
>   We can make disablenetwork safer by permitting its use only where explicitly
>   permitted by some previously privileged ancestor. The securebits facility
>   described in
> 
>     http://lwn.net/Articles/280279/
> 
>   may be a good framework in which to implement this control.
> 
> Did I understand correctly? If so, then yes, this approach seems like it would
> work for me.

That is a little more than I was saying this time though I think I
suggested it earlier.

But really I don't think anyone would care to separate a system into
some processes allowed to do unprivileged disablenetwork and other
processes not allowed to, so a (root-owned mode 644) sysctl seems just
as useful.

> Regards, and thanks very much for your help,
> 
> Michael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
