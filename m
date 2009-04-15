Return-Path: <linux-kernel-owner+w=401wt.eu-S1757114AbZDOW5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114AbZDOW5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 18:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753682AbZDOW5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 18:57:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753395AbZDOW5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 18:57:03 -0400
Date: Wed, 15 Apr 2009 15:50:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Izik Eidus <ieidus@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
       avi@redhat.com, aarcange@redhat.com, chrisw@redhat.com,
       mtosatti@redhat.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 4/4] add ksm kernel shared memory driver.
Message-Id: <20090415155058.9e4635b2.akpm@linux-foundation.org>
In-Reply-To: <49E661A5.8050305@redhat.com>
References: <1239249521-5013-1-git-send-email-ieidus@redhat.com>
	<1239249521-5013-2-git-send-email-ieidus@redhat.com>
	<1239249521-5013-3-git-send-email-ieidus@redhat.com>
	<1239249521-5013-4-git-send-email-ieidus@redhat.com>
	<1239249521-5013-5-git-send-email-ieidus@redhat.com>
	<20090414150929.174a9b25.akpm@linux-foundation.org>
	<49E661A5.8050305@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Apr 2009 01:37:25 +0300
Izik Eidus <ieidus@redhat.com> wrote:

> Andrew Morton wrote:
> > On Thu,  9 Apr 2009 06:58:41 +0300
> > Izik Eidus <ieidus@redhat.com> wrote:
> >
> >   
> >
> > Confused.  In the covering email you indicated that v2 of the patchset
> > had abandoned ioctls and had moved the interface to sysfs.
> >   
> We have abandoned the ioctls that control the ksm behavior (how much cpu 
> it take, how much kernel pages it may allocate and so on...)
> But we still use ioctls to register the application memory to be used 
> with ksm.

hm. ioctls make kernel people weep and gnash teeth.

An appropriate interface would be to add new syscalls.  But as ksm is
an optional thing and can even be modprobed, that doesn't work.  And
having a driver in mm/ which can be modprobed is kinda neat.

I can't immediately think of a nicer interface.  You could always poke
numbers into some pseudo-file but to me that seems as ugly, or uglier
than an ioctl (others seem to disagee).

Ho hum.  Please design the ioctl interface so that it doesn't need any
compat handling if poss.

