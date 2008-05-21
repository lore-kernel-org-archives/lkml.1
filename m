Return-Path: <linux-kernel-owner+w=401wt.eu-S934272AbYEUAvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934272AbYEUAvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757777AbYEUAvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:51:33 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:8713 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019AbYEUAvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:51:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=geugy68V7uRUV+bdO77KJU3F0VCq3i2sfHJ/BrISWhFjziTyRdn8AddVib5CYE03B4oOuD2b0/I3GpwRvhLwHJO1cg6gtvpXpgU41Z438O7dY6IYmGBFLGNq0V+yVeUveEYmKl87uHqsHQZC6rHYkmCVba3v9wvpWXXadHJcyCc=
Subject: Re: [PATCH] or51132.c: unaligned
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Al Viro <viro@ftp.linux.org.uk>, mchehab@infradead.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       David Miller <davem@davemloft.net>
In-Reply-To: <20080521004548.GD28946@ZenIV.linux.org.uk>
References: <E1JycGV-0004yJ-SP@ZenIV.linux.org.uk>
	 <1211330472.5915.228.camel@brick>
	 <20080521004548.GD28946@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Tue, 20 May 2008 17:51:28 -0700
Message-Id: <1211331088.5915.241.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-21 at 01:45 +0100, Al Viro wrote:
> On Tue, May 20, 2008 at 05:41:12PM -0700, Harvey Harrison wrote:
> 
> > > +	return buf[0] | (buf[1] << 8);
> > 
> > return get_unaligned_le16(buf);
> 
> And the point of that would be?

Other than using the available helper, none.

> 
> > > +	firmwareAsize = le32_to_cpu(*((__le32*)fw->data));
> > 
> > ???firmwareAsize = le32_to_cpup((__le32 *)fw->data);
> 
> ... and the point of that would be?  FWIW, I really don't like the ...p()
> forms - they are hard to distinguish from normal ones visually and any
> possible performance benefit is too small for most of the uses.  IOW,
> it's mostly redundant API.

I sent a patchset getting rid of the p variants earlier today, Dave
Miller made a good point that some arches have well optimized versions
of these as they have specific machine instructions they can use.

Agreed that I don't much like them either, was thinking of adding a
u32 get_le32(__le32 *ptr) type api and get rid of the le32_to_cpup
api.

Cheers,

Harvey


