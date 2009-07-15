Return-Path: <linux-kernel-owner+w=401wt.eu-S1753999AbZGOKqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbZGOKqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 06:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbZGOKqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 06:46:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49693 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbZGOKqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 06:46:47 -0400
To: Zhang Rui <rui.zhang@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
Subject: Re: [PATCH 8/8] i8042: support device async suspend & shutdown
From: Andi Kleen <andi@firstfloor.org>
References: <1247643522.26272.83.camel@rzhang-dt>
Date: Wed, 15 Jul 2009 12:46:45 +0200
In-Reply-To: <1247643522.26272.83.camel@rzhang-dt> (Zhang Rui's message of "Wed, 15 Jul 2009 15:38:42 +0800")
Message-ID: <87k52a6x62.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang Rui <rui.zhang@intel.com> writes:

> i8042 controller support device async actions.
>
> If boot option "dev_async_action" is added,
> i8042 controller and its child devices can be
> suspended/resumed/shutdown asynchronously.
>

>From a quick look at the i8042 driver it still 
seems to do a lot of slow actions without actually sleeping
or worse holding locks. e.g. the delay loop in i8042_flush()

Did you measure how long that one takes?

Due to the locks even preempt kernels couldn't do
something during that time.

The spinlocks are probably needed when the code is executed
during interrupts, but perhaps the suspend variant
could use a different code path.

Perhaps it only makes sense to do this when this 
code is converted to sleep during delays too?

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
