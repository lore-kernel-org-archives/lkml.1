Return-Path: <linux-kernel-owner+w=401wt.eu-S1755143AbZBCTOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbZBCTOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 14:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbZBCTOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 14:14:12 -0500
Received: from smtp-out.google.com ([216.239.33.17]:28864 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144AbZBCTOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 14:14:10 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=n45pO0Ced+UdtuS29wtoiHlMDxfQPDVzrtPtU5Khm/Q2mRxSnTJJzrMYRZlO/DTxo
	kF7z5zeMGn3Wm9Erx6WlA==
MIME-Version: 1.0
In-Reply-To: <20090203185117.GB3359@mini-me.seanius.net>
References: <20090202200013.GU3643@vespa.holoscopio.com>
	 <1233606371.15779.32.camel@radis.liafa.jussieu.fr>
	 <20090202205246.GA28593@glandium.org>
	 <20090202214153.GV3643@vespa.holoscopio.com>
	 <20090203102416.GA8886@redhat.com> <87ljsnzo4v.fsf@benfinney.id.au>
	 <1233671913.8902.53.camel@abacate.horta>
	 <6599ad830902030855h1753f4a4o3a303b4dbddf10de@mail.gmail.com>
	 <20090203184915.GA10004@glandium.org>
	 <20090203185117.GB3359@mini-me.seanius.net>
Date: Tue, 3 Feb 2009 11:14:03 -0800
Message-ID: <6599ad830902031114t7de1b570p4ed5ec497e2e150e@mail.gmail.com>
Subject: Re: cgroup mount point
From: Paul Menage <menage@google.com>
To: sean finney <seanius@seanius.net>
Cc: Gustavo Noronha <kov@debian.org>, debian-devel@lists.debian.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.25.146.38
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 3, 2009 at 10:51 AM, sean finney <seanius@seanius.net> wrote:
> On Tue, Feb 03, 2009 at 07:49:15PM +0100, Mike Hommey wrote:
>> > Having one virtual filesystem mounted on top of another virtual
>> > filesystem seems like a recipe for problems.
>>
>> Like with /sys/fs/fuse/connections ? Come on, there is no problem with a
>> virtual filesystem mounted on top of another.
>
> or /proc/bus/usb or /dev/shm or /dev/pts... :)
>

/dev is a bit different though - even if it's mounted as a udev fs,
you can create a new directory in there to act as a mount point.

Cgroups supports multiple hierarchies on different mount points.

So if you have two cgroups hierarchies - say one for CPU/network and
one for memory isolation, you could create /dev/cgroup/cpunet and
/dev/cgroup/memory and mount the two hierarchies. But sysfs doesn't
allow you to create new subdirectories to act as mountpoints. If we
can have a /sys/cgroups directory which allows you to create arbitrary
subdirs to act as mountpoints, that could be OK.

Or just fake it by mounting a tmpfs on /sys/cgroups and then create
mount points in there, but that seems like a bit of a hack.

Paul
