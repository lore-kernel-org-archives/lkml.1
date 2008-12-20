Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbYLTSYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbYLTSYE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 13:24:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbYLTSXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 13:23:52 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39828 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbYLTSXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 13:23:51 -0500
Date: Sat, 20 Dec 2008 13:22:54 -0500
From: Dave Jones <davej@redhat.com>
To: Daniel Pittman <daniel@rimspace.net>
Cc: Jeremy Katz <katzj@redhat.com>, Theodore Tso <tytso@mit.edu>,
       initramfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Dracut -- Cross distribution initramfs infrastructure
Message-ID: <20081220182254.GA2996@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Daniel Pittman <daniel@rimspace.net>,
	Jeremy Katz <katzj@redhat.com>, Theodore Tso <tytso@mit.edu>,
	initramfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1229540094.28858.150.camel@aglarond.local> <20081217190700.GA15377@infradead.org> <4949FD67.6040906@suse.de> <494B5031.5080306@bfh.ch> <20081219091841.207bc951@kopernikus.site> <494BA7CE.2020007@suse.de> <20081219152708.GE9871@mit.edu> <9C4F1B7D-CCBC-48D7-8624-9A7C314C1590@redhat.com> <87skojrm5e.fsf@rimspace.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87skojrm5e.fsf@rimspace.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2008 at 12:50:21AM +1100, Daniel Pittman wrote:

 > One of the features of the Debian / Ubuntu initramfs infrastructure,
 > which sounds remarkably like your design (or vice-versa), is that it
 > drops all the "standard" drivers into the initramfs.
 > 
 > This is, to me, worth several minutes of additional boot time, in terms
 > of flexibility: being able to modify the hardware and be confident that
 > the appropriate drivers are in place already makes life much, much
 > easier.

There's another reason this is really useful.
If something goes wrong, remotely debugging a users initrd right is
a lot easier if you know what it looks like.  Right now, in Fedora for eg,
where we generate an initrd for each users system at runtime, we need
to get a copy of the generated initrd, and pull it apart just to find
out what modules ended up in there, what didn't, and then somehow
try to work backwards to try and figure out how the generator got into
that state.  After doing this for five years, let me tell you it's
_really_ _really_ painful.

 > (In practice I doubt this adds more than a second or five to boot time;
 >  certainly, it takes no longer to get to rootfs mounted than the RHEL 4
 >  systems that have nothing but what is essential in the initrd...)

At least in theory, with a kernel-event/udev driven system, the additional
modules shouldn't cause any additional boot time. There wouldn't be
events generated to cause them to be loaded, so they'd just be taking
up space.  And the additional load time for a bigger initrd should be
really lost in the noise of the overall boot.

	Dave

-- 
http://www.codemonkey.org.uk
