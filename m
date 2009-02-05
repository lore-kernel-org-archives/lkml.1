Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbZBEVa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbZBEVa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 16:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbZBEVaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 16:30:18 -0500
Received: from quark.amimatica.com ([62.93.188.92]:46301 "EHLO
	quark.amimatica.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbZBEVaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 16:30:17 -0500
X-Greylist: delayed 631 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Feb 2009 16:30:16 EST
Message-ID: <498B57E9.2020707@adv-solutions.net>
Date: Thu, 05 Feb 2009 22:19:37 +0100
From: =?ISO-8859-1?Q?Jos=E9_Luis_Tall=F3n?= <jltallon@adv-solutions.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: debian-devel@lists.debian.org
CC: linux-kernel@vger.kernel.org
Subject: Re: cgroup mount point
References: <20090202200013.GU3643@vespa.holoscopio.com>	<1233606371.15779.32.camel@radis.liafa.jussieu.fr>	<20090202205246.GA28593@glandium.org>	<20090202214153.GV3643@vespa.holoscopio.com>	<20090203102416.GA8886@redhat.com>	<87ljsnzo4v.fsf@benfinney.id.au>	<1233671913.8902.53.camel@abacate.horta>	<6599ad830902030855h1753f4a4o3a303b4dbddf10de@mail.gmail.com>	<20090203184915.GA10004@glandium.org>	<20090203185117.GB3359@mini-me.seanius.net>	<6599ad830902031114t7de1b570p4ed5ec497e2e150e@mail.gmail.com> <20090204003847.308cd0df@sbs173>
In-Reply-To: <20090204003847.308cd0df@sbs173>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harald Braumann wrote:
> On Tue, 3 Feb 2009 11:14:03 -0800
> Paul Menage <menage@google.com> wrote:
>
>   
>> On Tue, Feb 3, 2009 at 10:51 AM, sean finney <seanius@seanius.net>
>> wrote:
>>     
>>> or /proc/bus/usb or /dev/shm or /dev/pts... :)
>>>
>>>       
>> /dev is a bit different though - even if it's mounted as a udev fs,
>> you can create a new directory in there to act as a mount point.
>>     
>
> So, what's the problem with /dev/cgroups then? If shm/ and pts/
> are allowed under /dev, wouldn't it be discriminating against
> cgroups/, to not allow it there?
>   
/dev/pts refers to the virtual pseudo-tty subsystem
    i.e. virtual pseudo-tty devices

/dev/shm refers to the "shared memory" device
    (ok, this is a bit forced)

/dev/log refers to the "log" device
    it could perfectly well be just a file. The fact that it is actually
a socket (more like a pipe to the logging daemon) does not hinder its
equivalence to a logfile.

whereas I can't fathom why a cgroup "feels" like a /device/.

I admit not being an expert in virtualization abstraction (I do run a
significant number of virtual machines, tough), but in fact /sys seems
to be a much better place for it. Please feel free to argue against if
my proposal does not in fact make sense.
While it does indeed feel "hackish", mounting a tmpfs on /sys/cgroups
and then creating as many subdirs as/if necessary is indeed achievable,
practical and flexible.

/proc might be useable though, but it has historically been associated
with "processes" and the information related to them. And yes, that
means that /proc/cpuinfo, /proc/meminfo, and /proc/bus would actually be
out of place there... but keeping backwards compatibility and not
surprising users is most important.



IMHO, other mount points (/var/run/cgroups maybe?) might make sense too.
However the fact that the most common use of cgroup is to split the
system into virtual "partitions" in some way suggests it belongs in /sys.


In any case, I want to show my appreciation and gratitude to all kernel
hackers out there. You're doing a great job, people.


Regards,

    J.L.
