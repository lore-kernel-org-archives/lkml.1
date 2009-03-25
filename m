Return-Path: <linux-kernel-owner+w=401wt.eu-S1756696AbZCYBVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbZCYBVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 21:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbZCYBVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 21:21:05 -0400
Received: from relay2.sgi.com ([192.48.179.30]:33313 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754502AbZCYBVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 21:21:04 -0400
Date: Tue, 24 Mar 2009 20:21:01 -0500
From: Robin Holt <holt@sgi.com>
To: Chuck Lever <chuck.lever@oracle.com>, tony.luck@intel.com
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: kernel unaligned accesses on 2.6.29.
Message-ID: <20090325012101.GC8908@sgi.com>
References: <20090324172856.GA8908@sgi.com> <20090325011418.GB8908@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325011418.GB8908@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 08:14:18PM -0500, Robin Holt wrote:
> Had a few minutes to look around.
...
> This one is:
> 	u64 *p = (u64 *)&nsm->sm_priv.data;
> 	...
> 	*p = (unsigned long)nsm;
...
> >     e3d0:       0a 60 28 1c 8d 39       [MMI]       cmp4.eq p12,p13=10,r14;;
> >     e3d6:       00 a8 95 30 23 00                   st8 [r37]=r53
> 

Well, that was easy.  This is the store part of
	*p++ = timespec_to_ns(&ts);

Again, comes down to &nsm->sm_priv.data not being aligned.

Robin
