Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbZA1Gid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbZA1Gid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 01:38:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbZA1GiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 01:38:25 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:47743 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbZA1GiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 01:38:24 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 27 Jan 2009 22:38:22 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Greg KH <gregkh@suse.de>
cc: Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>
Subject: Re: [patch 016/104] epoll: introduce resource usage limits
In-Reply-To: <20090128052630.GA9512@suse.de>
Message-ID: <alpine.DEB.1.10.0901272135400.20262@alien.or.mcafeemobile.com>
References: <1232704065.25510.1296328851@webmail.messagingengine.com> <20090123170631.GB11566@suse.de> <20090124130334.GA8031@brong.net> <20090125110126.GA11598@brong.net> <20090125122039.GA16603@brong.net> <20090128003519.GA11395@suse.de>
 <20090128033824.GA1662@brong.net> <alpine.DEB.1.10.0901271942270.20262@alien.or.mcafeemobile.com> <20090128035746.GA3351@brong.net> <alpine.DEB.1.10.0901272002180.20262@alien.or.mcafeemobile.com> <20090128052630.GA9512@suse.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009, Greg KH wrote:

> On Tue, Jan 27, 2009 at 08:10:41PM -0800, Davide Libenzi wrote:
> > In my servers, I know if they are going to be loaded, and I bump NFILES 
> > (and a few other things) to the correct place. Since many of those 
> > limits do not actually pre-allocate any resource, I don't need to wait and 
> > monitor the values, before taking proper action.
> 
> But what about people who want to know what the current usages are, so
> that they _can_ monitor things and adjust them on the fly if things are
> about to go boom?
> 
> I see no reason why we can't leave the value where it is today, and add
> the ability to both turn the limits off entirely, and also report our
> current usage.  That keeps the DOS from happening on "default" systems,
> and lets admins have an idea if they need to bump up the values on their
> systems as well.
> 
> I don't understand your objection to allowing the usage to be monitored.

Do you really want to add that crud just to monitor a value? That cost 
absolutely zero (in terms of pre-allocated resources) to bump up?
Is not like, that you want to keep the bound value close to the current 
peak because using an even higher value could result in pre-allocated 
resource waste. No because I could understand if rising such number to 
higher-than-needed values could result in waste of resources, so you want 
to monitor it to keep it as close as possible to the peak. But this is not 
the case.
So today we have three groups of users:

- Users that have been hit by the limit
  * Those have probably bumped the value up to the wazzoo.

- Unaware users with machines having potential of hitting the current limit
  * Those, monitor or not, being unaware, they won't notice it until hits. 
    And since rising it costs zero, they'd likely prefer to bump it to the 
    stars instead of monitoring an incrementing by small steps.
  * Applying a lomem-dependent max_instances default value like the two 
    lines patch I posted, is probably the best choice even for stable.

- Unaware users with low-load machines
  * Those won't even notice it.

The default value can be rised, bound to lomem sizes. I see no problems in 
there. Or, like Willy said, make (for -stable) the default unlimited, and 
let sysadmins to put the bounds if they feel the DoS can apply to them.




- Davide


