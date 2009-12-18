Return-Path: <linux-kernel-owner+w=401wt.eu-S932387AbZLRRro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387AbZLRRro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 12:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932350AbZLRRrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 12:47:41 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:52309 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294AbZLRRrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:47:39 -0500
To: Michael Stone <michael@laptop.org>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
       Oliver Hartkopp <socketcan@hartkopp.net>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>, Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
References: <20091218154634.79decdc4@lxorguk.ukuu.org.uk>
	<20091218163348.GA24269@heat>
	<20091218172054.556de51b@lxorguk.ukuu.org.uk>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 18 Dec 2009 09:47:23 -0800
In-Reply-To: <20091218172054.556de51b@lxorguk.ukuu.org.uk> (Alan Cox's message of "Fri\, 18 Dec 2009 17\:20\:54 +0000")
Message-ID: <m13a38uqc4.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH 1/3] Security: Add prctl(PR_{GET,SET}_NETWORK)
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> the LSM-based version *does not* resolve the situation to my satisfaction as a
>> userland hacker due to the well-known and long-standing adoption and
>> compositionality problems facing small LSMs. ;)
>
> For things like Fedora it's probably an "interesting idea, perhaps we
> should do it using SELinux" sort of problem, but a config option for a
> magic network prctl is also going to be hard to adopt without producing a
> good use case - and avoiding that by dumping crap into everyones kernel
> fast paths isn't a good idea either.

If I understand the problem the goal is to disable access to ipc
mechanism that don't have the usual unix permissions.  To get
something that is usable for non-root processes, and to get something
that is widely deployed so you don't have to jump through hoops in
end user applications to use it.

We have widely deployed mechanisms that are what you want or nearly
what you want already in the form of the various namespaces built for
containers.

I propose you introduce a permanent disable of executing suid 
applications. 

After which point it is another trivial patch to allow unsharing of
the network namespace if executing suid applications are disabled.

Eric
