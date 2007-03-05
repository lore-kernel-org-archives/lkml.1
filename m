Return-Path: <linux-kernel-owner+w=401wt.eu-S933133AbXCELFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133AbXCELFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 06:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933082AbXCELFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 06:05:31 -0500
Received: from mail.station1.mxsweep.com ([212.147.136.149]:3344 "EHLO
	SCMF01.mxsweep.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933133AbXCELFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 06:05:30 -0500
Message-ID: <45EBF8D3.1020609@draigBrady.com>
Date: Mon, 05 Mar 2007 11:02:43 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Thunderbird 1.5.0.8 (X11/20061116)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: userspace pagecache management tool
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>
In-Reply-To: <20070303122935.f1ab0067.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Mlf-Version: 5.0.2.8415
X-Mlf-UniqueId: o200703051108050216593
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> I've uploaded to http://userweb.kernel.org/~akpm/pagecache-management/ a
> little tool which permits the management of the pagecache usage of
> arbitrary applications.  Effectively it prevents the targetted application
> from using any pagecache at all.

Cool, Kinda like noca?
http://kernel.umbrella.ro/vm/
Though I could easily read your code,
but couldn't immediately figure out what noca was doing.

I used posix_fadvise in an app I did recently:
http://www.pixelbeat.org/programs/dvd-vr/
There is a stream_data() func there that does:

read(src)
write(dst)
posix_fadvise(src)
posix_fadvise(dst)

for performance I found I needed to do it in that order
so that any readahead done with the read(src)
was not thrown away by the posix_fadvise(src).
In addition to the order, one must be careful
to throw away only what you've actually written.

I'm not sure your lib gives enough control over this,
as you essentially do:

posix_fadvise(src)
read(src)
posix_fadvise(dst)
write(dst)

cheers,
Pádraig.
