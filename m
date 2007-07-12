Return-Path: <linux-kernel-owner+w=401wt.eu-S1760152AbXGLSVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152AbXGLSVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 14:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754834AbXGLSVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 14:21:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923AbXGLSVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 14:21:31 -0400
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, nagar@watson.ibm.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Optimize struct task_delay_info
References: <1184138034.3068.51.camel@ymzhang>
	<p73d4yzyvkw.fsf@bingen.suse.de> <1184229443.3068.55.camel@ymzhang>
From: fche@redhat.com (Frank Ch. Eigler)
Date: 12 Jul 2007 14:21:17 -0400
In-Reply-To: <1184229443.3068.55.camel@ymzhang>
Message-ID: <y0mzm21eb4y.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.0808 (Gnus v5.8.8) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Zhang, Yanmin" <yanmin_zhang@linux.intel.com> writes:

> [...]
> > > 2) Delete lock. [..]
> > > In addition, the result is for performance data collection, so it's
> > > unnecessary to add such lock.
> > Not sure that's a good idea. People expect their performance counts
> > to be accurate too. [...]
> [...]
> 2) If the reader could get the correct data when the process updates
> the data. It might be an issue. But the issue is not
> important. Mostly, the application tool reads the data in an
> interval.

Can you elaborate on that some more?  Is it OK for the sample
monitoring program to return inconsistent data sometimes?  Is there
reason to believe that this sample user-space program will remain the
sole consumer of this data?  Might a seqlock be appropriate here?

- FChE
