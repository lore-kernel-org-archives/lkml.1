Return-Path: <linux-kernel-owner+w=401wt.eu-S933269AbYBNAOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933269AbYBNAOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 19:14:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760816AbYBNANy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 19:13:54 -0500
Received: from outbound-mail-24.bluehost.com ([69.89.21.19]:34421 "HELO
	outbound-mail-24.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760411AbYBNANx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 19:13:53 -0500
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Kanoj Sarcar <kanojsarcar@yahoo.com>
Subject: Re: Demand paging for memory regions
Date: Wed, 13 Feb 2008 15:48:49 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Christoph Lameter <clameter@sgi.com>,
       Christian Bell <christian.bell@qlogic.com>,
       Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
       Rik van Riel <riel@redhat.com>, Andrea Arcangeli <andrea@qumranet.com>,
       a.p.zijlstra@chello.nl, izike@qumranet.com,
       Roland Dreier <rdreier@cisco.com>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Robin Holt <holt@sgi.com>,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net, Dave Airlie <airlied@linux.ie>
References: <866658.37093.qm@web32510.mail.mud.yahoo.com>
In-Reply-To: <866658.37093.qm@web32510.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802131548.50016.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 13, 2008 3:43 pm Kanoj Sarcar wrote:
> Oh ok, yes, I did see the discussion on this; sorry I
> missed it. I do see what notifiers bring to the table
> now (without endorsing it :-)).
>
> An orthogonal question is this: is IB/rdma the only
> "culprit" that elevates page refcounts? Are there no
> other subsystems which do a similar thing?
>
> The example I am thinking about is rawio (Oracle's
> mlock'ed SHM regions are handed to rawio, isn't it?).
> My understanding of how rawio works in Linux is quite
> dated though ...

We're doing something similar in the DRM these days...  We need big chunks of 
memory to be pinned so that the GPU can operate on them, but when the 
operation completes we can allow them to be swappable again.  I think with 
the current implementation, allocations are always pinned, but we'll 
definitely want to change that soon.

Dave?

Jesse
