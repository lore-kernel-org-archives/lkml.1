Return-Path: <linux-kernel-owner+w=401wt.eu-S1755216AbYERO1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbYERO1V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 10:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbYERO1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 10:27:10 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:49089
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbYERO1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 10:27:09 -0400
Message-ID: <48303CB9.7070406@qumranet.com>
Date: Sun, 18 May 2008 17:27:05 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Mark McLoughlin <markmc@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio_net: free transmit skbs in a timer
References: <1209565906-9019-1-git-send-email-markmc@redhat.com> <200805160925.18087.rusty@rustcorp.com.au> <482FCF45.1050307@qumranet.com> <200805190016.10823.rusty@rustcorp.com.au>
In-Reply-To: <200805190016.10823.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (firebolt.argo.co.il [0.0.0.0]); Sun, 18 May 2008 17:27:05 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> OK.  And since the current situation is that the host doesn't throttle, the 
> feature bit should be "don't throttle, host is doing it for you", and Mark's 
> patch should go in...
>   

Yes.

We should have thought of this before, though, especially as Xen does 
this or something very similar:

> /* Shared ring page */                            \
> struct __name##_sring {                            \
>     RING_IDX req_prod, req_event;                    \
>     RING_IDX rsp_prod, rsp_event;                    \
>     uint8_t  pad[48];                            \
>     union __name##_sring_entry ring[1]; /* variable-length */        \
> };                                    \

req_event and rsp_event allow the other side to indicate when it wants a 
notification.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

