Return-Path: <linux-kernel-owner+w=401wt.eu-S1765530AbXEYUhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765530AbXEYUhh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 16:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756346AbXEYUha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 16:37:30 -0400
Received: from mail.gmx.net ([213.165.64.20]:41576 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756023AbXEYUh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 16:37:29 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1/GFEBd0u3GpFrzRvchh0PtXb9Xrhj4cSeClPpYVQ
	bNVuGKuMbaOuKs
Date: Fri, 25 May 2007 22:37:30 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: double exclamation (!!) suckage in the kernel
Message-ID: <20070525203730.GA5974@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Satyam Sharma <satyam.sharma@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <a781481a0705251323s6b5c8014t48e8d2ad63e8434a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a781481a0705251323s6b5c8014t48e8d2ad63e8434a@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.05.26 01:53:59 +0530, Satyam Sharma wrote:
> Hello,
> 
> Grepping through the sources I found 500+ occurrences of double
> exclamation marks before identifier names (such as !!x -- I took care
> to ignore occurrences of !! inside comment blocks, because there
> are plenty of that sort too).
> 
> !! are to be found even in the definitions of common macros such as
> likely() and unlikely(), which hundreds of eyes must have seen over
> the last year or so ...
> 
> Are all these occurrences merely the debris of
> s/something/!notsomething/g kind of patches or is there some
> dark, unknown C / gcc wizardry I have absolutely no clue of?

It avoids useless warnings. If you have a pointer and want to store if
it is NULL/non-NULL in an integer variables, you have to use !x or !!x.
Just using x will result in a warning that you convert a pointer to an
integer without a cast.

Given this example:

int main()
{
	int ret;
	void *foo;

	ret = foo;
	ret = !!foo;

	return 0;
}

gcc will emit this warning:
ttt.c:6: warning: assignment makes integer from pointer without a cast

HTH
Björn
