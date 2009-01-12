Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbZALTBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbZALTBn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 14:01:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbZALTBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 14:01:35 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:49592 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbZALTBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 14:01:34 -0500
Date: Mon, 12 Jan 2009 13:00:46 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, travis@sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, steiner@sgi.com,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: regarding the x86_64 zero-based percpu patches
In-Reply-To: <m1mydwxvtx.fsf@frodo.ebiederm.org>
Message-ID: <Pine.LNX.4.64.0901121258480.3101@quilx.com>
References: <49649814.4040005@kernel.org> <20090107120225.GA30651@elte.hu>
 <49649C65.6000706@kernel.org> <200901101716.04220.rusty@rustcorp.com.au>
 <Pine.LNX.4.64.0901121120280.30369@quilx.com> <m1mydwxvtx.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jan 2009, Eric W. Biederman wrote:

> > There are 2M TLB entries on x86_64. If we really get into a high usage
> > scenario then the 2M entry makes sense. Average server memory sizes likely
> > already are way beyond 10G per box. The higher that goes the more
> > reasonable the 2M TLB entry will be.
>
> 2M of per cpu data doesn't make sense, and likely indicates a design
> flaw somewhere.  It just doesn't make sense to have large amounts of
> data allocated per cpu.

Some data is not small. MIB data is allocated per cpu etc etc

> What would be better is simply to:
> - Require a lock to access another cpus per cpu data.
> - Do large page allocations for the per cpu data.
>
> At which point we could grow the per cpu data by simply reallocating it on
> each cpu and updating the register that holds the base pointer.

If per cpu data areas have no fixed address then you cannot use list
operations on per cpu data nor can the address of per cpu variables be
stored anywhere.

But maybe that is okay?

