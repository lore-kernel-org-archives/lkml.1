Return-Path: <linux-kernel-owner+w=401wt.eu-S1760444AbYBACry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760444AbYBACry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 21:47:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbYBACrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 21:47:45 -0500
Received: from relay2.sgi.com ([192.48.171.30]:49362 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752695AbYBACro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 21:47:44 -0500
Date: Thu, 31 Jan 2008 20:47:42 -0600
From: Robin Holt <holt@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Robin Holt <holt@sgi.com>, Andrea Arcangeli <andrea@qumranet.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 1/3] mmu_notifier: Core code
Message-ID: <20080201024742.GD26420@sgi.com>
References: <20080131045750.855008281@sgi.com> <20080131045812.553249048@sgi.com> <20080201023113.GB26420@sgi.com> <Pine.LNX.4.64.0801311838070.26594@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801311838070.26594@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 06:39:19PM -0800, Christoph Lameter wrote:
> On Thu, 31 Jan 2008, Robin Holt wrote:
> 
> > Jack has repeatedly pointed out needing an unregister outside the
> > mmap_sem.  I still don't see the benefit to not having the lock in the mm.
> 
> I never understood why this would be needed. ->release removes the 
> mmu_notifier right now.

Both xpmem and GRU have means of removing their context seperate from
process termination.  XPMEMs is by closing the fd, I believe GRU is
the same.  In the case of XPMEM, we are able to acquire the mmap_sem.
For GRU, I don't think it is possible, but I do not remember the exact
reason.

Thanks,
Robin
