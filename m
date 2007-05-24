Return-Path: <linux-kernel-owner+w=401wt.eu-S1752620AbXEXR1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbXEXR1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 13:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750864AbXEXR1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 13:27:23 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:32873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750729AbXEXR1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 13:27:22 -0400
Date: Thu, 24 May 2007 10:27:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: linux-kernel@vger.kernel.org, tom.l.nguyen@intel.com,
       iss_storagedev@hp.com, jens.axboe@oracle.com,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Michael Ellerman <michael@ellerman.id.au>
Subject: Re: msi_free_irqs #2
Message-Id: <20070524102702.bca37396.akpm@linux-foundation.org>
In-Reply-To: <20070524160756.GA14083@beardog.cca.cpqcorp.net>
References: <20070524160756.GA14083@beardog.cca.cpqcorp.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007 11:07:56 -0500
"Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> wrote:

> So I guess I found the answer to my own question. msi_free_irqs was apparently added
> in 2.6.22-something. I don't find it in 2.6.21.2 or anywhere else. So somebody broke a
> couple of things.
> The most noticable is cciss hangs after turning on interrupts. The reason for that is
> the kernel now looks at my array of MSI-X vectors in reverse order. We have 4 ways of
> generating an interrupt on Smart Array hw. They are:
> 
> #       define DOORBELL_INT     0
> #       define PERF_MODE_INT    1
> #       define SIMPLE_MODE_INT  2
> #       define MEMQ_MODE_INT    3
> 
> For INTx these four lines are OR'ed together and run to one interrupt pin. MSI-X
> breaks this hardware OR'ing so we must register either all 4 or at the least the
> correct interrupt. When I first submitted the MSI/X support I was registering all 4.
> Someone changed that to only register a single MSI-X vector. That worked fine until
> 2.6.22-something. 
> Now it appears that the kernel is looking at the array in reverse order. IOW, I must
> register PERF_MODE_INT in order for cciss to work. That's messed up. Anybody want to
> `fess up to making these changes? :)
> I'll keep working this, but I'm going to undo someones change when I figure out where
> it's broke.
> 

I'd guess that you're referring to Michael's changes.  If you can identify
the offending code in a less vague fashion, more confident answers can
be given ;)

I canot find any sign of anyone altering the IRQ handling in cciss.c after
your initial MSI-support merge.  But that's perhaps isn't what you meant.
it's all rather foggy.  Please either quote file-n-line, or grab a copy
of git-blame.
