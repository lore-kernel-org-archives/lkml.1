Return-Path: <linux-kernel-owner+w=401wt.eu-S1756110AbZD0HDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbZD0HDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 03:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbZD0HCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 03:02:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46464 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbZD0HCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 03:02:43 -0400
To: "Styner, Douglas W" <douglas.w.styner@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-driver@qlogic.com, linux-scsi@vger.kernel.org
Subject: Re: Mainline kernel OLTP performance update
From: Andi Kleen <andi@firstfloor.org>
References: <D7C42C27E6CB1E4D8CBDF2F81EA92A260345836A3A@azsmsx501.amr.corp.intel.com>
Date: Mon, 27 Apr 2009 09:02:40 +0200
In-Reply-To: <D7C42C27E6CB1E4D8CBDF2F81EA92A260345836A3A@azsmsx501.amr.corp.intel.com> (Douglas W. Styner's message of "Thu, 23 Apr 2009 09:49:57 -0700")
Message-ID: <87ljpmk29b.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Styner, Douglas W" <douglas.w.styner@intel.com> writes:

>
> ======oprofile 0.9.3 CPU_CLK_UNHALTED for top 30 functions
> Cycles% 2.6.24.2                   Cycles% 2.6.30-rc2
> 74.8578 <database>                   67.6966 <database>

The dip in database cycles is indeed worrying.

> 1.0500 qla24xx_start_scsi          1.1724 qla24xx_start_scsi
> 0.8089 schedule                    1.0578 qla24xx_intr_handler
> 0.5864 kmem_cache_alloc            0.8259 __schedule
> 0.4989 __blockdev_direct_IO        0.7451 kmem_cache_alloc
> 0.4357 __sigsetjmp                 0.4872 __blockdev_direct_IO
> 0.4152 copy_user_generic_string    0.4390 task_rq_lock
> 0.3953 qla24xx_intr_handler        0.4338 __sigsetjmp

And also why the qla24xx_intr_handler became ~2.5x as expensive.
Cc linux-scsi and qla24xx maintainers.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
