Return-Path: <linux-kernel-owner+w=401wt.eu-S1752659AbYLTOBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbYLTOBR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 09:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbYLTOBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 09:01:01 -0500
Received: from ppp59-167-189-244.static.internode.on.net ([59.167.189.244]:53110
	"EHLO isinu.rimspace.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbYLTOBA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 09:01:00 -0500
X-Greylist: delayed 630 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Dec 2008 09:00:58 EST
From: Daniel Pittman <daniel@rimspace.net>
To: Jeremy Katz <katzj@redhat.com>
Cc: Theodore Tso <tytso@mit.edu>, initramfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Dracut -- Cross distribution initramfs infrastructure
Organization: I know I put it down here, somewhere.
References: <1229540094.28858.150.camel@aglarond.local>
	<20081217190700.GA15377@infradead.org> <4949FD67.6040906@suse.de>
	<494B5031.5080306@bfh.ch> <20081219091841.207bc951@kopernikus.site>
	<494BA7CE.2020007@suse.de> <20081219152708.GE9871@mit.edu>
	<9C4F1B7D-CCBC-48D7-8624-9A7C314C1590@redhat.com>
Date: Sun, 21 Dec 2008 00:50:21 +1100
In-Reply-To: <9C4F1B7D-CCBC-48D7-8624-9A7C314C1590@redhat.com> (Jeremy Katz's
	message of "Fri, 19 Dec 2008 11:56:47 -0500")
Message-ID: <87skojrm5e.fsf@rimspace.net>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Katz <katzj@redhat.com> writes:
> On Dec 19, 2008, at 10:27 AM, Theodore Tso wrote:
>> On Fri, Dec 19, 2008 at 02:55:26PM +0100, Hannes Reinecke wrote:
>>>
>>> The goal of the initrd is to activate and mount the root fs.
>>> And the root fs _only_. Every other system should be configured
>>> once the main system is running.

[...]

>> There may also be times when it is useful to operate on the root
>> filesystem in some way before it is mounted; in most cases the
>> operation can bedone on a filesystem mounted read-only, yes --- but at
>> the cost of needing to reboot afterwards if the root filesystem needs
>> to be modified by said userspace tool.
>
> I think that once you start getting into this realm, though, you end
> up with an incredibly over-complicated and slow initramfs.  If we
> instead focus on keeping things "fast", the reboot afterwards isn't
> that costly.

One of the features of the Debian / Ubuntu initramfs infrastructure,
which sounds remarkably like your design (or vice-versa), is that it
drops all the "standard" drivers into the initramfs.

This is, to me, worth several minutes of additional boot time, in terms
of flexibility: being able to modify the hardware and be confident that
the appropriate drivers are in place already makes life much, much
easier.

(In practice I doubt this adds more than a second or five to boot time;
 certainly, it takes no longer to get to rootfs mounted than the RHEL 4
 systems that have nothing but what is essential in the initrd...)


So, it would certainly be my hope — with my systems administration hat
on — that your proposed system would support that similar operation as
an option, at least.

Personally, I think it makes the right default: better correct than
fast, but obviously tastes vary there.

Regards,
        Daniel
