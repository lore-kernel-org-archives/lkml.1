Return-Path: <linux-kernel-owner+w=401wt.eu-S1752473AbZL0Ppm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbZL0Ppm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 10:45:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbZL0Ppl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 10:45:41 -0500
Received: from lists.laptop.org ([18.85.2.145]:59937 "EHLO mail.laptop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752233AbZL0Ppj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 10:45:39 -0500
Date: Sun, 27 Dec 2009 10:47:47 -0500
From: Michael Stone <michael@laptop.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
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
       Michael Stone <michael@laptop.org>
Subject: Re: RFC: disablenetwork facility. (v4)
Message-ID: <20091227154747.GA12645@heat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20091227150300.GB19414@hallyn.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge Hallyn writes:

> Michael Stone, without looking back over the patches, do you also
> restrict opening netlink sockets?  

The current version of the patch restricts netlink sockets which were not bound
to an address before calling disablenetwork(). It does so primarily on the
grounds of "fail safe", due to the following sorts of discussions and
observations:

   http://kerneltrap.org/mailarchive/linux-kernel/2007/12/7/493793/thread
   http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-5461
   http://marc.info/?l=linux-kernel&m=125448727130301&w=2

I would be willing to entertain an argument that some kind of exemption for
AF_NETLINK ought to be introduced but I'd need to hear some more details before
I could implement it and before I could satisfy myself that the result was
sound.

> Should we worry about preventing an error message from being sent to the
> audit daemon?

I've considered the matter and I don't see much to worry about at this time. 

The first reason why I'm not too worried is that anyone in a position to use
disablenetwork for nefarious purposes is also probably able to use ptrace(),
kill(), and/or LD_PRELOAD to similar ends.

The second reason why I'm not too worried is that I believe it to be
straightforward to use the pre-existing MAC frameworks to prevent individually
important processes from dropping networking privileges.

Do you have a specific concern in mind not addressed by either of these
observations?

Regards,

Michael
