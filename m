Return-Path: <linux-kernel-owner+w=401wt.eu-S934462AbYCFPQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934462AbYCFPQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 10:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764547AbYCFPPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 10:15:51 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:51661 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761545AbYCFPPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 10:15:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=yFvFRc/N1Ou3ywQ0D9mLlsHQ4YuHDU5KACJO+k9DBtYOtRuhbgj/s+SeFUrzosiDffbl8E5FYB31CPX6FcGRmKtfEiLYJrESknPG0iW+MVnym7d0fV6LjqX2FQCUEVGkw/rYVz34Sdav8RmHiCyUG+rra8QxAzcoVnovRJGQMho=
Message-ID: <4d569c330803060715s53de08d1w7131b8ae930abd4f@mail.gmail.com>
Date: Thu, 6 Mar 2008 10:15:43 -0500
From: "Kevin Coffman" <kwc@citi.umich.edu>
To: "Nick Piggin" <npiggin@suse.de>
Subject: Re: [patch] iov_iter_advance fix
Cc: "Andrew Morton" <akpm@linux-foundation.org>, stable@kernel.org,
       "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kevin Coffman" <kwc@citi.umich.edu>
In-Reply-To: <20080306053950.GA28803@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080306053950.GA28803@wotan.suse.de>
X-Google-Sender-Auth: 697b747745c475e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Nick,

I've verified this fixes the problem I was seeing.

On Thu, Mar 6, 2008 at 12:39 AM, Nick Piggin <npiggin@suse.de> wrote:
>
>  iov_iter_advance skips over zero-length iovecs, however it does not properly
>  terminate at the end of the iovec array. Fix this by checking against
>  i->count before we skip a zero-length iov.
>
>  The bug was reproduced with a test program that continually randomly creates
>  iovs to writev. The fix was also verified with the same program and also it
>  could verify that the correct data was contained in the file after each
>  writev.
>
>  2.6.25 and 2.6.24.stable requires this fix.
>
>  Signed-off-by: Nick Piggin <npiggin@suse.de>
>  Cc: stable@kernel.org

Tested-by: Kevin Coffman <kwc@citi.umich.edu>
