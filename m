Return-Path: <linux-kernel-owner+w=401wt.eu-S932421AbYBUUBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421AbYBUUBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 15:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755625AbYBUUBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 15:01:20 -0500
Received: from qb-out-0506.google.com ([72.14.204.232]:1895 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425AbYBUUBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 15:01:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aa2rg8pKbqCN2zGebcBJJ87mtDVkRmF4xlIxDKdBu1JHTnugukxcmoFYk+i40rROIx6C0HVyEewDspaqnphmriza6RRVT0IwNAZWVZi7d3qwaKV42o3qArgd+odjP9NUcqMYNNGLvRpiS6JAPpU/IkKIdt7pRN7p7l+et4xSH1A=
Subject: Re: [PATCH] mac80211: check endianness/types in sparse runs
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sam Ravnborg <sam@ravnborg.org>, John Linville <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Stefano Brivio <stefano.brivio@polimi.it>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <1203597776.20331.5.camel@johannes.berg>
References: <1203503909.17534.14.camel@johannes.berg>
	 <20080220195913.GE21139@uranus.ravnborg.org>
	 <1203597776.20331.5.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 12:01:31 -0800
Message-Id: <1203624091.20345.63.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-21 at 13:42 +0100, Johannes Berg wrote:
> >> [patch doing CHECKFLAGS += -D__CHECK_ENDIAN__ in the
> >> net/mac80211/Makefile]
> 
> > I would prefer it to be kernel wide enabled.
> > Tried a defconfig build.
> 
> Hm. I tend to think there was a reason for this, since this is actually
> explicitly disabled by include/linux/types.h:
> 
> #ifdef __CHECKER__
> #define __bitwise__ __attribute__((bitwise))
> #else 
> #define __bitwise__
> #endif
> 
> #ifdef __CHECK_ENDIAN__
> #define __bitwise __bitwise__
> #else
> #define __bitwise
> #endif
> 

This seems somewhat suspect.

> I recently ran sparse on my config and was surprised by the number of
> warnings. Then again, something in mmzone.h or so generated billions of
> them...

Potentially expensive pointer subtraction 640:....

Patch in -mm.

> 
> In any case, I would love to have __CHECK_ENDIAN__ enabled by default at
> least on the wireless code (just caught another bug with it...)
> 

I'd love to have it too, but there are so many trivial warnings that
clutter up valid warnings that it is prohibitive.  I'm working on
reducing the noise level a bit for 2.6.26, we'll see about turning
it on then.

Harvey

