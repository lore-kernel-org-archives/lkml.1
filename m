Return-Path: <linux-kernel-owner+w=401wt.eu-S1756404AbXJXLMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404AbXJXLMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 07:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbXJXLM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 07:12:26 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:29286 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbXJXLMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 07:12:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=jR65JNoxTe216ZPu6Sff5kn1+9HKbjSTTVjxzWDQM5zVUr5HyTEGubMus3F8hxFOakbPdRpIjg8QXl0nZAS9p6fVSd/IN0qhcUYDsDiM+NQLHATOWcrSS2KmNsAqpRwcSKan8yyTHT88HlhGBB2u5da7mL4jhxTObG3eXpNfx4k=
Message-ID: <3ae72650710240412h55469ae4r4379df0a66412c94@mail.gmail.com>
Date: Wed, 24 Oct 2007 13:12:25 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: sysfs sys/kernel/ namespace (was Re: [PATCH 0/2] add new notifier function ,take2)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Takenori Nagano" <t-nagano@ah.jp.nec.com>, "Greg KH" <greg@kroah.com>
In-Reply-To: <200710241648.55939.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <471700F4.1080200@ah.jp.nec.com>
	 <200710212200.04361.nickpiggin@yahoo.com.au>
	 <471D4668.4090300@ah.jp.nec.com>
	 <200710241648.55939.nickpiggin@yahoo.com.au>
X-Google-Sender-Auth: 0ef6d528795393d7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> On Tuesday 23 October 2007 10:55, Takenori Nagano wrote:
> > Nick Piggin wrote:
>
> > > One thing I'd suggest is not to use debugfs, if it is going to
> > > be a useful end-user feature.
> >
> > Is /sys/kernel/notifier_name/ an appropriate place?

> I'm curious about the /sys/kernel/ namespace. I had presumed that
> it is intended to replace /proc/sys/ basically with the same
> functionality.

It was intended to be something like /proc/sys/kernel/ only.

> I _assume_ these are system software stats and
> tunables that are not exactly linked to device drivers (OTOH,
> where do you draw the line? eg. Would filesystems go here?

We already have /sys/fs/ ?

> Core network algorithm tunables might, but per interface ones probably
> not...).

We will merge the nonsense of "block/", "class/" and "bus/" to one
"subsystem". The block, class, bus directories will only be kept as
symlinks for compatibility. Then every subsystem has a directory like:
/sys/subsystem/block/, /sys/subsystem/net/ and the devices of the
subsystem are in a devices/ directory below that. Just like the
/sys/bus/< name>/devices/ layout looks today. All subsystem-global
tunables can go below the /sys/subsystem/<name>/ directory, without
clashing with the list of devices or anything else.

> I don't know. Is there guidelines for sysfs (and procfs for that
> matter)? Is anyone maintaining it (not the infrastructure, but
> the actual content)?

Unfortunately, there was never really a guideline.

> It's kind of ironic that /proc/sys/ looks like one of the best
> organised directories in proc, while /sys/kernel seems to be in
> danger of becoming a mess: it has kexec and uevent files in the
> base directory, rather than in subdirectories...

True, just looking at it now, people do crazy things like:
/sys/kernel/notes, which is a file with binary content, and a name
nobody will ever be able to guess what it is good for. That should
definitely go into a section/ directory.  Also the VM stuff there
should probably move to a /sys/vm/ directory along with the weird
placed top-level /sys/slab/.

Thanks,
Kay
