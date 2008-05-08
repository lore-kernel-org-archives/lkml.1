Return-Path: <linux-kernel-owner+w=401wt.eu-S1758734AbYEHIa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734AbYEHIa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 04:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbYEHIaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 04:30:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753220AbYEHIah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 04:30:37 -0400
Date: Thu, 8 May 2008 01:29:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] call_usermodehelper_setup() should use GFP_KERNEL
Message-Id: <20080508012957.c778c8e7.akpm@linux-foundation.org>
In-Reply-To: <20080508163039.0EF4.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080508153337.0EEE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<4822AA6F.5040703@cn.fujitsu.com>
	<20080508163039.0EF4.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 May 2008 16:31:29 +0900 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > KOSAKI Motohiro wrote:
> > > Now, call_usermodehelper_setup() use GFP_ATOMIC.
> > > but it is slighly odd.
> > > because call_usermodehelper() is always called process context.
> > > 
> > 
> > Are you sure? I found the following call chain:
> > 
> >   static irqreturn_t power_handler(int irq, void *dev_id)
> >   ->orderly_poweroff(true);
> >     ->call_usermodehelper_setup()
> 
> sorry, you are right.
> I'll make patch again.

How many times do we have to make this mistake :(

Only the caller knows what allocation mode the callee can use. 
call_usermodehelper_setup() should be extended to take a gfp_t argument.

