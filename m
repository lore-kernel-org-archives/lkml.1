Return-Path: <linux-kernel-owner+w=401wt.eu-S1752877AbZFRFQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbZFRFQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 01:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbZFRFQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 01:16:34 -0400
Received: from ozlabs.org ([203.10.76.45]:46813 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbZFRFQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 01:16:33 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [KVM PATCH v2 2/2] kvm: use POLLHUP to close an irqfd instead of an explicit ioctl
Date: Thu, 18 Jun 2009 14:46:30 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, avi@redhat.com, davidel@xmailserver.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org
References: <20090604124047.10544.38861.stgit@dev.haskins.net> <4A3639B2.7080006@novell.com> <20090615125439.GI6351@redhat.com>
In-Reply-To: <20090615125439.GI6351@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906181446.31373.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009 10:24:39 pm Michael S. Tsirkin wrote:
> On Mon, Jun 15, 2009 at 08:08:18AM -0400, Gregory Haskins wrote:
> > Hmm.  I understand what you are saying conceptually (i.e. the .text
> > could get yanked before we hit the next line of code, in this case the
> > "return 0").  However, holding a reference when you _know_ someone else
> > holds a reference to me says that one of the references is redundant.
> > In addition, there is certainly plenty of precedence for
> > module_put(THIS_MODULE) all throughout the kernel (including
> > module_put_and_exit()).  Are those broken as well?
>
> Maybe not, but I don't know why. It works fine as long as you don't
> unload any modules though :) Rusty, could you enlighten us please?

Yep, they're almost all broken.  A few have comments indicating that someone 
else is holding a reference (eg. loopback).

But at some point you give up playing whack-a-mole for random drivers.

module_put_and_exit() does *not* have this problem, BTW.

Rusty.
