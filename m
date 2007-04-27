Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbXD0Q6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbXD0Q6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 12:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbXD0Q6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 12:58:35 -0400
Received: from smtp-out.google.com ([216.239.33.17]:35194 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083AbXD0Q6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 12:58:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=ODAceC0e86ZhE0dW6xJrjIHWcCrsf7F1lVCVSpPD5NntMpkIVjODMNgFlAlvLerlN
	6tDYtIv7PcLIp6H8Vt9xw==
Message-ID: <cc96a5040704270958x8bbdb55m2fff1a4a5e1e621@mail.gmail.com>
Date: Fri, 27 Apr 2007 09:58:14 -0700
From: "Tim Hockin" <thockin@google.com>
To: "Andi Kleen" <ak@muc.de>
Subject: Re: [PATCH] x86_64: dynamic MCE poll interval
Cc: vojtech@suse.cz, linux-kernel@vger.kernel.org, akpm@google.com
In-Reply-To: <20070427090917.GA24922@muc.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cc96a5040704261802v2bcb3a59k9d44da8d615a6779@mail.gmail.com>
	 <20070427090917.GA24922@muc.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 Apr 2007 11:09:17 +0200, Andi Kleen <ak@muc.de> wrote:
> On Thu, Apr 26, 2007 at 06:02:52PM -0700, Tim Hockin wrote:
> > Description:
> >  This patch makes the MCE poller adjust the polling interval dynamically.
> >  If we find an MCE, poll 2x faster (down to 10 ms).  When we stop finding
> >  MCEs, poll 2x slower (up to check_interval seconds).  The check_interval
> >  tunable becomes the max polling interval.
>
> Can you please fix the documentation then?

Which documentation, specifically? :)

> > Result:
> >  If you start to take a lot of correctable errors (not exceptions), you
> >  log them faster and more accurately (less chance of overflowing the MCA
> >  registers).  If you don't take a lot of errors, you will see no change.
>
> Makes sense.
>
> AMD RevF can do this using the threshold interrupts too for DIMM errors
> too without any delays -- perhaps it would also make sense to configure
> this by default that it always triggers on all DIMM errors.
> Right now it is just an option in /sys

Can I look at this as a followon patch?  I have a number of mce
related patches in the pipeline, and I am trying to keep them small
for testing sanity - they are hard enough to test :)

> The printk should not happen too often. Can you add some hardcoded
> limit there than it doesn't happen more often than every hour or so
> (or perhaps use a exponential backoff here too?)
> It is only to tell users to check mcelog output.

Sure.  I'll fix it up and hit you again today.
