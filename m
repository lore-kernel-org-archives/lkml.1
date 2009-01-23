Return-Path: <linux-kernel-owner+w=401wt.eu-S1758337AbZAWT2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337AbZAWT2v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 14:28:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbZAWT2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 14:28:42 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:47860 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbZAWT2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 14:28:42 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 23 Jan 2009 11:28:38 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Bron Gondwana <brong@fastmail.fm>
cc: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>
Subject: Re: [patch 016/104] epoll: introduce resource usage limits
In-Reply-To: <1232704065.25510.1296328851@webmail.messagingengine.com>
Message-ID: <alpine.DEB.1.10.0901231125570.27255@alien.or.mcafeemobile.com>
References: <20081203193901.715896543@mini.kroah.org> <20081203194849.GQ8950@kroah.com> <1232686261.9977.1296303473@webmail.messagingengine.com> <20090123051620.GA8122@suse.de> <1232704065.25510.1296328851@webmail.messagingengine.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2009, Bron Gondwana wrote:

> On Thu, 22 Jan 2009 21:16 -0800, "Greg KH" <gregkh@suse.de> wrote:
> > On Fri, Jan 23, 2009 at 03:51:01PM +1100, Bron Gondwana wrote:
> > > On Wed, 03 Dec 2008 11:48 -0800, "Greg KH" <gregkh@suse.de> wrote:
> > > > The default value for "max_user_instances" is set to 128, that should be enough too.
> > > 
> > > Our fairly heavily loaded postfix backup mx (lots of spams rejected per day) hit this
> > > limit running kernel 2.6.27.8.  Any particular reason for it being as low as 128
> > > by default?
> > 
> > Something had to be picked :)
> 
> Fair enough :)
> 
> > > This is a kvm virtual machine running on a reasonably beefy external box, but
> > > with 2Gb RAM allocated to the mx instance because that's all kvm would let me
> > > use last time I checked.  We're using KVM so the local copy of the database is
> > > a little further away from the "internet facing side" and so we can build each
> > > machine with our standard FAI setup.
> > 
> > I would suggest just changing this default value then, it's a simple
> > userspace configuration item, and for your boxes, it sounds like a
> > larger value would be more suitable.
> 
> Yes - I've pushed it up to 4096 now.  Should be plenty!
> 
> I guess Postfix is a bit of an odd case here.   It runs lots of processes, yet
> uses epoll within many of them as well - sort of a historical design in some ways,
> but also to enforce maximum privilege separation with many of the daemons able to
> be run under chroot with limited capabilities.
> 
> So I guess I have a few questions left:
> 
> 1) is this value ever supposed to be hit in practice by non-malicious software?
>    If not, it appears 128 is too low.
> 
> 2) if we're going to stick with 128, is there any way to query the kernel as to how
>    close to the limit it's getting?  As an example, our system checks poll
>    /proc/sys/fs/file-max every 2 minutes, and warn us if its getting "full".

Why? If you know you have a loaded, non multi-user server, just bump the 
value up and forget about it. An higher value is not going to cost you 
anything in terms of resource allocation. Adding more /proc code to 
monitor a silly value, probably is.



- Davide


