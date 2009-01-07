Return-Path: <linux-kernel-owner+w=401wt.eu-S1759479AbZAGQFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759479AbZAGQFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 11:05:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbZAGQEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 11:04:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:39955 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbZAGQEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 11:04:52 -0500
Message-ID: <4964D2A2.2010109@suse.de>
Date: Wed, 07 Jan 2009 17:04:50 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Daniel Pittman <daniel@rimspace.net>,
       Jeremy Katz <katzj@redhat.com>, Theodore Tso <tytso@mit.edu>,
       initramfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Dracut -- Cross distribution initramfs infrastructure
References: <1229540094.28858.150.camel@aglarond.local> <20081217190700.GA15377@infradead.org> <4949FD67.6040906@suse.de> <494B5031.5080306@bfh.ch> <20081219091841.207bc951@kopernikus.site> <494BA7CE.2020007@suse.de> <20081219152708.GE9871@mit.edu> <9C4F1B7D-CCBC-48D7-8624-9A7C314C1590@redhat.com> <87skojrm5e.fsf@rimspace.net> <20081220182254.GA2996@redhat.com>
In-Reply-To: <20081220182254.GA2996@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Sun, Dec 21, 2008 at 12:50:21AM +1100, Daniel Pittman wrote:
> 
>  > One of the features of the Debian / Ubuntu initramfs infrastructure,
>  > which sounds remarkably like your design (or vice-versa), is that it
>  > drops all the "standard" drivers into the initramfs.
>  > 
>  > This is, to me, worth several minutes of additional boot time, in terms
>  > of flexibility: being able to modify the hardware and be confident that
>  > the appropriate drivers are in place already makes life much, much
>  > easier.
> 
> There's another reason this is really useful.
> If something goes wrong, remotely debugging a users initrd right is
> a lot easier if you know what it looks like.  Right now, in Fedora for eg,
> where we generate an initrd for each users system at runtime, we need
> to get a copy of the generated initrd, and pull it apart just to find
> out what modules ended up in there, what didn't, and then somehow
> try to work backwards to try and figure out how the generator got into
> that state.  After doing this for five years, let me tell you it's
> _really_ _really_ painful.
> 
Whom do you tell.

I ended up on adding lots of shell escapes; everytime something goes
wrong you'll be dropped into a shell, which will resume execution
of the initrd once exited.
Quite handy for fixing up most things.

>  > (In practice I doubt this adds more than a second or five to boot time;
>  >  certainly, it takes no longer to get to rootfs mounted than the RHEL 4
>  >  systems that have nothing but what is essential in the initrd...)
> 
> At least in theory, with a kernel-event/udev driven system, the additional
> modules shouldn't cause any additional boot time. There wouldn't be
> events generated to cause them to be loaded, so they'd just be taking
> up space.  And the additional load time for a bigger initrd should be
> really lost in the noise of the overall boot.
> 
One can but hope. You certainly will notice a load time increase if the size
of the initrd increases by orders of magnitude.
Plus kdump / kexec will need to be configured to have more memory available.

Actually, I do like the callout idea:
Have the initrd configure a 'standard' system, and add some API which will
allow you to hook in additional scripts / services / whatever to configure
non-standard systems.
Which then can be distributed by the individual packages / vendors.
And then we would have a small common initramfs which well could be included
with the kernel sources.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)
