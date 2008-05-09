Return-Path: <linux-kernel-owner+w=401wt.eu-S1763878AbYEIAC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763878AbYEIAC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 20:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750906AbYEIACs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 20:02:48 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:56195 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbYEIACq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 20:02:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hWhCGCJo1tTj8EhC/7TVDQ3CCmFAR8VW2PM/5Q3/lzwWT+ERGkXDYSO0+L6n7OvN6ggBrlrGyFCemqXGeiKFUhczhSwJKQdbFOg91IFL6HQXp+AfQHmmufrf4WSs+D7rtlq6fIjE1i3eagf8UlF3W9bo9y08KjBB4l+8O2zc+k8=
Subject: Re: [PATCH] Silence 'ignoring return value' warnings in
	drivers/video/aty/radeon_base.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Greg KH <greg@kroah.com>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       benh@kernel.crashing.org, Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, tony@bakeyournoodle.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <18467.37312.772564.163109@cargo.ozlabs.ibm.com>
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
	 <18467.37312.772564.163109@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Thu, 08 May 2008 17:02:44 -0700
Message-Id: <1210291364.19279.62.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-09 at 09:50 +1000, Paul Mackerras wrote:
> Greg KH writes:
> 
> > > I hear you :) I found it useful, but it seems we should get rid of it
> > > for _create_file() now.
> > 
> > Why?  You point out it found some real bugs, should we just assume that
> > no new bugs of this same problem will happen again in the future?
> 
> Because it causes warnings for the callers which don't really care
> whether the file gets created or not, and getting rid of those
> warnings adds unnecessary bloat.
> 
> I think the best solution is to make a new sysfs_maybe_create_file()
> which isn't marked must_check, and then move suitable callers (such as
> radeonfb) over to that.  That will make it obvious in the callers that
> the file creation isn't guaranteed.

Or just a a flag parameter to the existing one that says whether failure
is allowed or not.  In a case that fails, a WARN_ON can be printed from
the common create_file rather than putting printks all over the kernel.

This would also document which files are necessary vs. optional.

Harvey

