Return-Path: <linux-kernel-owner+w=401wt.eu-S1751677AbZI2NLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbZI2NLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 09:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbZI2NLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 09:11:45 -0400
Received: from ozlabs.org ([203.10.76.45]:57554 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbZI2NLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 09:11:45 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for generic guest and host communication
Date: Tue, 29 Sep 2009 22:41:45 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: alan@linux.intel.com, virtualization@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com> <1252678386-17404-2-git-send-email-amit.shah@redhat.com>
In-Reply-To: <1252678386-17404-2-git-send-email-amit.shah@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909292241.46275.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Sep 2009 11:43:06 pm Amit Shah wrote:
> Expose multiple char devices ("ports") for simple communication
> between the host userspace and guest.

OK, I think other comments have died down, so it's time for a review.  This
was the latest patch I could find.

The obvious way to do this is to use multiple pairs of virtqueues.  Is this
silly for some reason?  Yes, we're restricted to 32k ports.

It means that if we see the MULTIQUEUE feature, we can look for the other
queues.  Our current MSI-X friendly API makes that a little painful, but
if we resolve that our code should be sweetness, no?

Rusty.
