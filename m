Return-Path: <linux-kernel-owner+w=401wt.eu-S1766016AbZAPQWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766016AbZAPQWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 11:22:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758094AbZAPQVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 11:21:51 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:57846 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757746AbZAPQVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 11:21:50 -0500
Subject: Re: [PATCH] Allow SysRq emergency sync to thaw frozen filesystems
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, t-sato@yk.jp.nec.com
In-Reply-To: <497003CC.8030503@redhat.com>
References: <496EB639.6090800@redhat.com>
	 <20090115162031.a512232b.akpm@linux-foundation.org>
	 <497003CC.8030503@redhat.com>
Content-Type: text/plain
Date: Fri, 16 Jan 2009 10:21:47 -0600
Message-Id: <1232122907.15209.3.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-15 at 21:49 -0600, Eric Sandeen wrote:
> Andrew Morton wrote:
> > On Wed, 14 Jan 2009 22:06:17 -0600
> > Eric Sandeen <sandeen@redhat.com> wrote:

> >> Index: linux-2.6/drivers/char/sysrq.c
> >> ===================================================================
> >> --- linux-2.6.orig/drivers/char/sysrq.c
> >> +++ linux-2.6/drivers/char/sysrq.c
> >> @@ -151,6 +151,7 @@ static struct sysrq_key_op sysrq_reboot_
> >>  
> >>  static void sysrq_handle_sync(int key, struct tty_struct *tty)
> >>  {
> >> +	emergency_thaw();
> >>  	emergency_sync();
> >>  }
> > 
> > Kind of weird.   The thaw will happen after/during the sync().
> 
> oh, hrm.  Maybe I didn't think enough about how it's handed off to
> pdflush; I could rearrange if that makes sense?  Or maybe handing to
> pdflush is wrong, it was just so convenient....

I don't understand the reason for handing it to pdflush.  I would expect
thaw to be very fast.  Do we expect it to block anywhere, and if so, for
very long?  Not that I see any problem with it.

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

