Return-Path: <linux-kernel-owner+w=401wt.eu-S1752463AbZL0P7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbZL0P7m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 10:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbZL0P7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 10:59:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59970 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbZL0P7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 10:59:39 -0500
X-Authority-Analysis: v=1.0 c=1 a=QR-QLlQdE-oA:10 a=Op-mwl0xAAAA:8 a=m0bHr2FCAAAA:8 a=sMBj6sIwAAAA:8 a=gu6fZOg2AAAA:8 a=FtDF64Qn_qdOJVXGIEgA:9 a=kMha1ED_-dO8v6cx8-8A:7 a=dtpt07eger3aaiDLQNhiaCwR7QUA:4 a=d4CUUju0HPYA:10 a=LTSpQyL4TFhlDVPa:21 a=ORhdNw08DCQR7y5y:21
X-Cloudmark-Score: 0
X-Originating-IP: 70.124.57.33
Date: Sun, 27 Dec 2009 10:12:03 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
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
       Am?rico Wang <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>, Pavel Machek <pavel@ucw.cz>
Subject: Re: RFC: disablenetwork facility. (v4)
Message-ID: <20091227161203.GA20031@hallyn.com>
References: <20091227150300.GB19414@hallyn.com> <20091227154747.GA12645@heat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091227154747.GA12645@heat>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Michael Stone (michael@laptop.org):
> Serge Hallyn writes:
>
>> Michael Stone, without looking back over the patches, do you also
>> restrict opening netlink sockets?  
>
> The current version of the patch restricts netlink sockets which were not bound
> to an address before calling disablenetwork(). It does so primarily on the
> grounds of "fail safe", due to the following sorts of discussions and
> observations:
>
>   http://kerneltrap.org/mailarchive/linux-kernel/2007/12/7/493793/thread
>   http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-5461
>   http://marc.info/?l=linux-kernel&m=125448727130301&w=2
>
> I would be willing to entertain an argument that some kind of exemption for
> AF_NETLINK ought to be introduced but I'd need to hear some more details before
> I could implement it and before I could satisfy myself that the result was
> sound.
>
>> Should we worry about preventing an error message from being sent to the
>> audit daemon?
>
> I've considered the matter and I don't see much to worry about at this 
> time. 

I don't either, because I don't know of userspace programs other than
/bin/login (and I'm guessing at that) using netlink to send audit messages,
but I could be wrong, and there could be "important software" out there
that does so.

> The first reason why I'm not too worried is that anyone in a position to use
> disablenetwork for nefarious purposes is also probably able to use ptrace(),
> kill(), and/or LD_PRELOAD to similar ends.

How do you mean?  I thought that disabling network was a completely
unprivileged operation?  And subsequently executing a setuid-root
application won't reset the flag.

> The second reason why I'm not too worried is that I believe it to be
> straightforward to use the pre-existing MAC frameworks to prevent individually
> important processes from dropping networking privileges.
>
> Do you have a specific concern in mind not addressed by either of these
> observations?

Near as I can tell the worst one could do would be to prevent remote
admins from getting useful audit messages, which could give you unlimited
time to keep re-trying the server, on your quest to a brute-force attack
of some sort, i.e. restarting the server with random passwords, and now
no audit msg about the wrong password gets generated, so you're free to
exhaust the space of valid passwords.

Not saying I'm all that worried about it - just something that came to
mind.

-serge
