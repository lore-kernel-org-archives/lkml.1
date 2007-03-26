Return-Path: <linux-kernel-owner+w=401wt.eu-S1752350AbXCZFhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbXCZFhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 01:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbXCZFhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 01:37:12 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:8314 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbXCZFhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 01:37:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CMt70EgSC9SqkqP39tgeSOSu4XZKyCJvXEpgOPnb2lxvox4ZEr5blIStGp05gUIVCsGE8aRqsf95DGnFYaq2bqHObQ0iYoKk0noW5njGEbq4VXczmBkaxwnqDof/ojmEA7rahBsLKRcwum9IksFSnQLWYqfkuvHKAQ2B/MTq+gQ=
Message-ID: <b6a2187b0703252237l4f662fb3n7f57dfb10360c4f6@mail.gmail.com>
Date: Mon, 26 Mar 2007 13:37:08 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: [3/6] 2.6.21-rc4: known regressions
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz,
       "Jens Axboe" <jens.axboe@oracle.com>, "Len Brown" <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, jgarzik@pobox.com,
       linux-ide@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20070326040509.GU16477@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <20070318184919.GW752@stusta.de>
	 <b6a2187b0703251825l2b2ab9d3j43e17523cbca87ac@mail.gmail.com>
	 <20070326040509.GU16477@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/26/07, Adrian Bunk <bunk@stusta.de> wrote:

> > Resume from RAM (s2ram) still broke (tried with or without
> > CONFIG_NO_HZ). Suspend to RAM seems ok, but upon resume, the screen
> > will only display "inu" and only after pressing the power button will
> > the system return to console. But "date" still doesn't advance.
>
> This might be related to the following regression:
>
> Subject    : first disk access after resume takes several minutes
>              ('date' does not advance after resume from RAM, CONFIG_NO_HZ=n)
> References : http://lkml.org/lkml/2007/3/8/117
>              http://lkml.org/lkml/2007/3/25/20
> Submitter  : Michael S. Tsirkin <mst@mellanox.co.il>
> Handled-By : Thomas Gleixner <tglx@linutronix.de>
>              Ingo Molnar <mingo@elte.hu>
> Status     : problem is being debugged

Adrian,

It's related. I tested without CONFIG_HPET_TIMER, and now my X60 can
suspend and resume from RAM (s2ram). Even better, it works
with/without CONFIG_NO_HZ.

But, suspend to disk still broke with CONFIG_NO_HZ set.

Thanks,
Jeff.
