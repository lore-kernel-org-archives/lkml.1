Return-Path: <linux-kernel-owner+w=401wt.eu-S1758032AbYCUCLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbYCUCLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 22:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbYCUCLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 22:11:03 -0400
Received: from mga10.intel.com ([192.55.52.92]:59462 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751178AbYCUCLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 22:11:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,534,1199692800"; 
   d="scan'208";a="537413951"
Subject: Re: [PATCH] Add definitions of USHRT_MAX
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <clameter@sgi.com>,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1206064278.26345.108.camel@localhost>
References: <1206063614.14496.72.camel@ymzhang>
	 <1206064278.26345.108.camel@localhost>
Content-Type: text/plain; charset=utf-8
Date: Fri, 21 Mar 2008 10:08:21 +0800
Message-Id: <1206065301.14496.77.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-20 at 18:51 -0700, Joe Perches wrote:
> On Fri, 2008-03-21 at 09:40 +0800, Zhang, Yanmin wrote:
> > Add definitions of USHRT_MAX and others into kernel. ipc uses it and
> > slub implementation might also use it.
> > +#define USHRT_MAX	((u16)(~0U))
> > +#define SHRT_MAX	((s16)(USHRT_MAX>>1))
> > +#define SHRT_MIN	(-SHRT_MAX - 1)
> 
> Perhaps it's better to use the most common kernel types?
ipc uses USHRT_MAX in a couple of files. Should we keep it consistent?

If ipc wouldn't use it, I would prefer your idea.

> Perhaps U16_MAX, S16_MAX and S16_MIN?
> 
> Don't you need to cast SHRT_MIN/S16_MIN too?
> #define S16_MIN ((s16)(-SHRT_MAX - 1))
No. I simulate INT_MIN. I also tested it by defining a var and didn't get
compilation warning.


