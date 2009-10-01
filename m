Return-Path: <linux-kernel-owner+w=401wt.eu-S1756491AbZJANv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491AbZJANv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 09:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756200AbZJANv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 09:51:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756189AbZJANv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 09:51:56 -0400
Date: Thu, 1 Oct 2009 19:20:20 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@linux.intel.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for
	generic guest and host communication
Message-ID: <20091001135020.GA14186@amit-x200.redhat.com>
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com> <200910011228.30563.borntraeger@de.ibm.com> <20091001114244.GB12334@amit-x200.redhat.com> <200910011404.37601.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910011404.37601.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Thu) Oct 01 2009 [14:04:37], Christian Borntraeger wrote:
> Am Donnerstag 01 Oktober 2009 13:58:01 schrieben Sie:
> > I spawned two ports; one doing 'find /' and the other transferring a
> > 800M file from the host to the guest, both running at the same time.
> > This is on top of the latest Linus tree + my patches. It works fine.
> > 
> > Can you give me any additional info that can help me nail this down?
> 
> This is just a wild guess: My guest has 8 cpus and virtio requires that users do 
> a proper locking. But as far as I see you use schedule_work which should be 
> single threaded. 
> Or maybe this is an existing bug that is just exposed by your patch - dont know. 

I think there might be two bugs. One is the readbuf_head list needs
some locks around its operations. The readbuf_head list is a per-port
list where buffers received from the host for a port are stored.
They're taken off that list when userspace issues read() requests.

The other bug is the virtio one that you saw. I'll try to see how that
one gets triggered.

Thanks,
		Amit
