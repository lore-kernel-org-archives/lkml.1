Return-Path: <linux-kernel-owner+w=401wt.eu-S1758072AbYEHXum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072AbYEHXum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 19:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbYEHXue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 19:50:34 -0400
Received: from ozlabs.org ([203.10.76.45]:55085 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbYEHXuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 19:50:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18467.37312.772564.163109@cargo.ozlabs.ibm.com>
Date: Fri, 9 May 2008 09:50:24 +1000
From: Paul Mackerras <paulus@samba.org>
To: Greg KH <greg@kroah.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, benh@kernel.crashing.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, tony@bakeyournoodle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Silence 'ignoring return value' warnings in
	drivers/video/aty/radeon_base.c
In-Reply-To: <20080508220348.GD7705@kroah.com>
References: <20080506143936.6357e578.akpm@linux-foundation.org>
	<20080506.144301.233784820.davem@davemloft.net>
	<1210121683.21644.194.camel@pasglop>
	<20080506182006.4b4a3968.akpm@linux-foundation.org>
	<1210134804.21644.202.camel@pasglop>
	<20080507102310.57b4ccfb@gondolin.boeblingen.de.ibm.com>
	<1210196621.1421.5.camel@pasglop>
	<20080508093421.31cd735b@gondolin.boeblingen.de.ibm.com>
	<1210232984.1421.47.camel@pasglop>
	<20080508103621.69bc47cf@gondolin.boeblingen.de.ibm.com>
	<20080508220348.GD7705@kroah.com>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH writes:

> > I hear you :) I found it useful, but it seems we should get rid of it
> > for _create_file() now.
> 
> Why?  You point out it found some real bugs, should we just assume that
> no new bugs of this same problem will happen again in the future?

Because it causes warnings for the callers which don't really care
whether the file gets created or not, and getting rid of those
warnings adds unnecessary bloat.

I think the best solution is to make a new sysfs_maybe_create_file()
which isn't marked must_check, and then move suitable callers (such as
radeonfb) over to that.  That will make it obvious in the callers that
the file creation isn't guaranteed.

Paul.
