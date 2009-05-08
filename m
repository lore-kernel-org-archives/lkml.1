Return-Path: <linux-kernel-owner+w=401wt.eu-S1757102AbZEHPq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102AbZEHPq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 11:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762778AbZEHPqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 11:46:00 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60774 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763297AbZEHPp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 11:45:59 -0400
Subject: Re: [PATCH 2/2] SLUB: Use GFP_PANIC for early-boot allocations
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, akpm@linux-foundation.org,
       gorcunov@openvz.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie,
       riel@redhat.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       rientjes@google.com
In-Reply-To: <1241797364.6311.2914.camel@laptop>
References: <1241795429.28600.61.camel@penberg-laptop>
	 <alpine.DEB.1.10.0905081127240.26361@qirst.com>
	 <1241797017.28600.63.camel@penberg-laptop>
	 <1241797364.6311.2914.camel@laptop>
Date: Fri, 08 May 2009 18:45:58 +0300
Message-Id: <1241797558.28600.68.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Fri, 2009-05-08 at 11:28 -0400, Christoph Lameter wrote:
> > > On Fri, 8 May 2009, Pekka Enberg wrote:
> > > 
> > > > This patch converts SLUB early-boot code to use GFP_PANIC instead of explicit
> > > > BUG_ON() calls.
> > > 
> > > Yirks this is not only early boot code. create_unique_id may be executed
> > > whenever a slab is created.

On Fri, 2009-05-08 at 18:36 +0300, Pekka Enberg wrote:
> > Argh. We should do -ENOMEM there then. I'll drop that hunk.

On Fri, 2009-05-08 at 17:42 +0200, Peter Zijlstra wrote:
> BUG_ON((gfp & __GFP_PANIC) && (system_state != STATE_BOOTING));

There's no technical reason not to use GFP_PANIC when system_state !=
STATE_BOOTING so I don't think it's needed. It's just that GFP_PANIC
(and BUG_ON) is IMHO too harsh for create_unique_id().

			Pekka

