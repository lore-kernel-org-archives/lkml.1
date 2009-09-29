Return-Path: <linux-kernel-owner+w=401wt.eu-S1751820AbZI2NK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbZI2NK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 09:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbZI2NK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 09:10:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbZI2NK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 09:10:28 -0400
Date: Tue, 29 Sep 2009 18:39:50 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Alan Cox <alan@linux.intel.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for
	generic guest and host communication
Message-ID: <20090929130950.GA23395@amit-x200.redhat.com>
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com> <200909291403.08547.borntraeger@de.ibm.com> <20090929122006.GB3766@amit-x200.redhat.com> <200909291456.56723.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909291456.56723.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Tue) Sep 29 2009 [14:56:56], Christian Borntraeger wrote:
> Am Dienstag 29 September 2009 14:20:06 schrieb Amit Shah:
> > Christian tested the patch on s390 and found that the output was
> > very slow. He tracked it down to put_chars never getting init'ed
> > to the final value.
> > 
> > Signed-off-by: Amit Shah <amit.shah@redhat.com>
> 
> Thanks. This fix is 
> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Tested-by: Christian Borntraeger <borntraeger@de.ibm.com> 

Great, thanks. However I was thinking of moving this init to the probe()
routine instead of in the init_conosle routine just because multiple
consoles can be added and we don't want to init this each time.. just
once in probe is fine.

> I am a bit reluctant to Ack the whole change, since my preference would have
> been to not merge virtio serial/console and instead keeping both separate.
> We have already managed to clutter all other virtio drivers with tons of 
> configuration stuff and feature bits - and every driver uses a different model
> for configuration and commands (feature bits, config space, config_change 
> indication, extra config virtqueue, commands embedded into the data....).
> Using a different device ID for a different use seem like a better way to me.

Well, Anthony described your objection as a comment in passing and that
you weren't strongly against merging the two drivers when I brought up
your argument sometime back.

Also, it was difficult to make progress and just keep fighting about
these issues. So even though I didn't like merging the stuff, I had to.

Rusty too in a recent mail mentioned he sees both the drivers as one
because the functionlities are similar.

> On the other hand, this patch allows more than one console (I have not tested
> this feature) and with this fix applied I dont see any obvious problems.

Note though that to use the multiple consoles, you'll have to modify
your userspace to handle the new messages that get passed between the
host and the guest (one can argue I've done the guest part; you only
have the host part to be done :-))

> For the console part I can give a 
> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com> (console)

Thanks again. I'll put this in the next spin.

> Ignoring my preference for having a separate driver and devids, I have no 
> opinion about the generic communication stuff - no ack or nack.

		Amit
