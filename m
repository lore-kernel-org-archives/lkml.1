Return-Path: <linux-kernel-owner+w=401wt.eu-S933144AbXCELMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933144AbXCELMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 06:12:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933068AbXCELMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 06:12:23 -0500
Received: from smtp.osdl.org ([65.172.181.24]:41620 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933165AbXCELMW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 06:12:22 -0500
Date: Mon, 5 Mar 2007 03:12:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?B?UOFkcmFpZw==?= Brady <P@draigBrady.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: userspace pagecache management tool
Message-Id: <20070305031205.61590e55.akpm@linux-foundation.org>
In-Reply-To: <45EBF8D3.1020609@draigBrady.com>
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>
	<45EBF8D3.1020609@draigBrady.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Mar 2007 11:02:43 +0000 Pádraig Brady <P@draigBrady.com> wrote:

> Andrew Morton wrote:
> > I've uploaded to http://userweb.kernel.org/~akpm/pagecache-management/ a
> > little tool which permits the management of the pagecache usage of
> > arbitrary applications.  Effectively it prevents the targetted application
> > from using any pagecache at all.
> 
> Cool, Kinda like noca?
> http://kernel.umbrella.ro/vm/

yup, same concept.

> Though I could easily read your code,
> but couldn't immediately figure out what noca was doing.
> 
> I used posix_fadvise in an app I did recently:
> http://www.pixelbeat.org/programs/dvd-vr/
> There is a stream_data() func there that does:
> 
> read(src)
> write(dst)
> posix_fadvise(src)
> posix_fadvise(dst)
> 
> for performance I found I needed to do it in that order
> so that any readahead done with the read(src)
> was not thrown away by the posix_fadvise(src).
> In addition to the order, one must be careful
> to throw away only what you've actually written.
> 
> I'm not sure your lib gives enough control over this,
> as you essentially do:
> 
> posix_fadvise(src)
> read(src)
> posix_fadvise(dst)
> write(dst)

That could be so - it's just a demo.  But readahead should be OK - I only
invalidate from start-of-file up to current-offset-minus-pagesize.  So the
cache at and ahead of the linear reader is undisturbed.


