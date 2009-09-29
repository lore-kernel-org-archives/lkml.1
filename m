Return-Path: <linux-kernel-owner+w=401wt.eu-S1751905AbZI2NYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbZI2NYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 09:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbZI2NYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 09:24:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbZI2NYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 09:24:52 -0400
Date: Tue, 29 Sep 2009 18:54:05 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: alan@linux.intel.com, virtualization@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for
	generic guest and host communication
Message-ID: <20090929132405.GB23395@amit-x200.redhat.com>
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com> <1252678386-17404-2-git-send-email-amit.shah@redhat.com> <200909292241.46275.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909292241.46275.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Tue) Sep 29 2009 [22:41:45], Rusty Russell wrote:
> On Fri, 11 Sep 2009 11:43:06 pm Amit Shah wrote:
> > Expose multiple char devices ("ports") for simple communication
> > between the host userspace and guest.
> 
> OK, I think other comments have died down, so it's time for a review.  This
> was the latest patch I could find.

I just sent a new patch in this thread; can you please review that one?

> The obvious way to do this is to use multiple pairs of virtqueues.  Is this
> silly for some reason?  Yes, we're restricted to 32k ports.

There were a couple of things to note about that:
- Avi, in the past, mentioned separate ivq and ovqs for each port for
  the kind of usage intended would be overkill.
- With the MSI rework, we can't init new i/ovqs for hotplugged ports as
  we find them. The queues all have to be init'ed at probe() time. I had
  some discussion with Michael some time back on virtualization@, but
  thought the overhead of implementing that would be high.

> It means that if we see the MULTIQUEUE feature, we can look for the other
> queues.  Our current MSI-X friendly API makes that a little painful, but
> if we resolve that our code should be sweetness, no?

If this is to solve the port numbering, etc., issues, I've thought of a
new way this can be done in the newest patch. What's more, Christian
tested it on s390 as well and it worked with a minor tweak. I tested the
new patch with combinations of qemu and kernel (old/new) and they worked
fine.

Thanks,
		Amit
