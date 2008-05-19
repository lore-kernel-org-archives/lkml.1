Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbYESGfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbYESGfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 02:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbYESGfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 02:35:14 -0400
Received: from ozlabs.org ([203.10.76.45]:56688 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753647AbYESGfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 02:35:12 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@qumranet.com>
Subject: Re: [PATCH] virtio_net: free transmit skbs in a timer
Date: Mon, 19 May 2008 11:52:27 +1000
User-Agent: KMail/1.9.9
Cc: Mark McLoughlin <markmc@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <1209565906-9019-1-git-send-email-markmc@redhat.com> <200805190016.10823.rusty@rustcorp.com.au> <48303CB9.7070406@qumranet.com>
In-Reply-To: <48303CB9.7070406@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805191152.28409.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 May 2008 00:27:05 Avi Kivity wrote:
> Rusty Russell wrote:
> > OK.  And since the current situation is that the host doesn't throttle,
> > the feature bit should be "don't throttle, host is doing it for you", and
> > Mark's patch should go in...
>
> Yes.
>
> We should have thought of this before, though, especially as Xen does
>
> this or something very similar:
> > /* Shared ring page */                            \
> > struct __name##_sring {                            \
> >     RING_IDX req_prod, req_event;                    \
> >     RING_IDX rsp_prod, rsp_event;                    \
> >     uint8_t  pad[48];                            \
> >     union __name##_sring_entry ring[1]; /* variable-length */        \
> > };                                    \
>
> req_event and rsp_event allow the other side to indicate when it wants a
> notification.

Well, we do have such a thing, in the ring suppression flags.  Note that DaveM 
is talking about moving network tx queue into the net drivers themselves, 
which will make them much more efficient (ie. drain entire queue before 
kick), which may again change the balance of what the Right Thing is.

I'll merge Mark's patch, and look at hacking up a feature to change behaviour 
to never suppress tx-done interrupts.

Thanks,
Rusty.
