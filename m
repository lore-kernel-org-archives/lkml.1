Return-Path: <linux-kernel-owner+w=401wt.eu-S1752434AbXCWTH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbXCWTH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 15:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753404AbXCWTH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 15:07:56 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:53355 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbXCWTHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 15:07:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Z4kWBp6j4p1etgCo+qz37HxRRXjN+pYVXuAlhyIjhUM3T9vDf8JGVkbPkFXfDxpLNwlK2ASgsfXa9QueFEbpUwe8VIYwY4S6gCy9xP+Rb/zYe5ynZWiAftJfZ02bN6BNIiSqNZX+iUEL6SVT5H8/ztQn5HoEM7Xi1UXeYAyw76c=
From: Maxim <maximlevitsky@gmail.com>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
Date: Fri, 23 Mar 2007 21:07:33 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.c, pavel@suse.cz,
       linux-pm@lists.osdl.org,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric_RISS?= <frederic.riss@gmail.com>,
       Tino Keitel <tino.keitel@gmx.de>, Bob Moore <robert.moore@intel.com>,
       lenb@kernel.org, linux-acpi@vger.kernel.org,
       Tobias Doerffel <tobias.doerffel@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       Mike Harris <atarimike@wavecable.com>, Marcus Better <marcus@better.se>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Thomas Meyer <thomas@m3y3r.de>, Thomas Gleixner <tglx@linutronix.de>,
       Soeren Sonnenburg <kernel@nn7.de>, jgarzik@pobox.com,
       linux-ide@vger.kernel.org
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <20070323185022.GQ752@stusta.de>
In-Reply-To: <20070323185022.GQ752@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703232107.34020.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 March 2007 20:50:22 Adrian Bunk wrote:

> Subject    : suspend to disk hangs
> References : http://lkml.org/lkml/2007/3/16/126
> Submitter  : Maxim Levitsky <maximlevitsky@gmail.com>
> Caused-By  : Rafael J. Wysocki <rjw@sisk.pl>
>              commit e3c7db621bed4afb8e231cb005057f2feb5db557
>              commit ed746e3b18f4df18afa3763155972c5835f284c5
>              commit 259130526c267550bc365d3015917d90667732f1
> Status     : unknown
> 
> 

Hello, 
	It is fixed

	The problem is that now cpu_up/cpu_down is called with tasks frozen,
	and this can lead to deadlock if some driver that registered cpu up/down notifier, sleeps,

	On my system it froze in two places, one in XFS due to freezable workqueues, and in
	microcode update driver that ask the "frozen" userspace for firmware.

	Fix for XFS is already in mainline, and Rafael J. Wysocki. already posted a patch that fixes microcode issue,
	I will test it.

	But I feel that there are more drivers that can deadlock system in same way, on my system S3/S4 works perfect :-)
	Even the weird  hang i had disappeared.

	Big thanks to Rafael J. Wysocki.


	Best regards,
		Maxim Levitsky
