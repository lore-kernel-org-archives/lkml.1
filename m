Return-Path: <linux-kernel-owner+w=401wt.eu-S1759294AbYHDX7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294AbYHDX7D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 19:59:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760919AbYHDX6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 19:58:41 -0400
Received: from relay1.sgi.com ([192.48.171.29]:56485 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760073AbYHDX6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 19:58:40 -0400
Date: Mon, 4 Aug 2008 18:58:38 -0500
From: Robin Holt <holt@sgi.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Stephen Champion <schamp@sgi.com>, Robin Holt <holt@sgi.com>,
       linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Paul Menage <menage@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch] Scale pidhash_shift/pidhash_size up based on
	num_possible_cpus().
Message-ID: <20080804235838.GJ7290@sgi.com>
References: <20080731193204.GG9663@sgi.com> <m1iqul25rk.fsf@frodo.ebiederm.org> <20080731200835.GK9663@sgi.com> <m1bq0d1zhz.fsf@frodo.ebiederm.org> <20080801120455.GP9663@sgi.com> <m1proszj3r.fsf@frodo.ebiederm.org> <20080801191336.GK10501@sgi.com> <m14p64zetj.fsf@frodo.ebiederm.org> <4896FFFE.7080400@sgi.com> <m17iawy0tl.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m17iawy0tl.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 01:36:38PM -0700, Eric W. Biederman wrote:
> Stephen Champion <schamp@sgi.com> writes:
> If we want something that tunes to the work load I expect a radix tree
> would be best.  If the goal after 4k cpus is 64k cpus which I heard someone
> mention I think that is what you really want.  A design that scales to
> the workload on the system.

But if we simply scale based upon num_possible_cpus(), we get a relatively
representative scaling function.  Usually, customers buy machines with 1,
2, or 4GB per cpu.  I would expect a waste of 256k, 512k, or even 1m to
be acceptable at this size of machine.

For 2.6.27, would you accept an upper cap based on the memory size
algorithm you have now and adjusted for num_possible_cpus()?  Essentially
the first patch I posted.

I would like to try and not be responsible for the radix tree
implementation as I have other more pressing obligations.  If, however,
it was a condition of getting an interim solution into 2.6.27, I would
be willing to discuss this with my management.

Thanks,
Robin
