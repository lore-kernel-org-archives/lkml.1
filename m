Return-Path: <linux-kernel-owner+w=401wt.eu-S1759258AbYFTVVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759258AbYFTVVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 17:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340AbYFTVVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 17:21:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50227
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752270AbYFTVVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 17:21:38 -0400
Date: Fri, 20 Jun 2008 14:21:37 -0700 (PDT)
Message-Id: <20080620.142137.242155859.davem@davemloft.net>
To: a.beregalov@gmail.com
Cc: kernel-testers@vger.kernel.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc: SPARC: Sun Ultra 10 can not boot
From: David Miller <davem@davemloft.net>
In-Reply-To: <a4423d670806201419i2f0c0982j69eb423f9ecd239d@mail.gmail.com>
References: <a4423d670806190902l48c542e0i6a7380a2d3e7f520@mail.gmail.com>
	<20080619.190048.193701955.davem@davemloft.net>
	<a4423d670806201419i2f0c0982j69eb423f9ecd239d@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Alexander Beregalov" <a.beregalov@gmail.com>
Date: Sat, 21 Jun 2008 01:19:29 +0400

> 2008/6/20 David Miller <davem@davemloft.net>:
> > When you revert that changeset, there is a loop in the backtrace of
> > all kernel threads, and therefore lockdep turns itself off when all of
> > the stack backtrace slots get consumed by that loop in the backtraces.
> >
> > After the revert you should see a set of kernel messages like:
> >
> > BUG: MAX_STACK_TRACE_ENTRIES too low!
> > turning off the locking correctness validator.
> >
> > and that would confirm my theory.
> 
> No, I do not have such messages.

When you revert that patch, this is exactly what you should
see.

Make sure to check "dmesg" because they get lost on the screeen
during the time between registering the VC console driver and
the ATY framebuffer registry.
