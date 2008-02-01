Return-Path: <linux-kernel-owner+w=401wt.eu-S1761362AbYBATRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761362AbYBATRb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 14:17:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758943AbYBATRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 14:17:11 -0500
Received: from relay1.sgi.com ([192.48.171.29]:58811 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754714AbYBATRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 14:17:09 -0500
Date: Fri, 1 Feb 2008 11:17:08 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Robin Holt <holt@sgi.com>
cc: Andrea Arcangeli <andrea@qumranet.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: Extending mmu_notifiers to handle __xip_unmap in a sleepable
 context?
In-Reply-To: <20080201115841.GM26420@sgi.com>
Message-ID: <Pine.LNX.4.64.0802011115180.18163@schroedinger.engr.sgi.com>
References: <20080201050439.009441434@sgi.com> <20080201115841.GM26420@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2008, Robin Holt wrote:

> Currently, it is calling mmu_notifier _begin and _end under the
> i_mmap_lock.  I _THINK_ the following will make it so we could support
> __xip_unmap (although I don't recall ever seeing that done on ia64 and
> don't even know what the circumstances are for its use).

Its called under lock yes.

The problem with this fix is that we currently have the requirement that 
the rmap invalidate_all call requires the pagelock to be held. That is not 
the case here. So I used _begin/_end to skirt the issue.

If you do not need the Pagelock to be held (it holds off modifications on 
the page!) then we are fine.

