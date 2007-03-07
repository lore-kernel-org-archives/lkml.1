Return-Path: <linux-kernel-owner+w=401wt.eu-S1751669AbXCGLl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669AbXCGLl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 06:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbXCGLl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 06:41:59 -0500
Received: from mail.station1.mxsweep.com ([212.147.136.149]:1797 "EHLO
	blue.mxsweep.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751669AbXCGLl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 06:41:58 -0500
Message-ID: <45EEA456.9020907@draigBrady.com>
Date: Wed, 07 Mar 2007 11:39:02 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Thunderbird 1.5.0.8 (X11/20061116)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: bert hubert <bert.hubert@netherlabs.nl>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: userspace pagecache management tool
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>	<45E9DD4A.2060806@redhat.com>	<20070303131204.6706a95c.akpm@linux-foundation.org>	<45E9E910.2070804@redhat.com>	<20070303214108.GA28961@outpost.ds9a.nl>	<20070303141448.1ed70e6d.akpm@linux-foundation.org>	<45E9F454.2080600@redhat.com>	<20070303142609.d3bc9cc3.akpm@linux-foundation.org>	<20070303230155.GA475@outpost.ds9a.nl>	<20070303154541.70aed9df.akpm@linux-foundation.org>	<45ED5A49.1010702@draigBrady.com> <20070306134046.5be821f5.akpm@linux-foundation.org>
In-Reply-To: <20070306134046.5be821f5.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Mlf-Version: 5.0.2.8415
X-Mlf-UniqueId: o200703071144330035558
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 06 Mar 2007 12:10:49 +0000
> P__draig Brady <P@draigBrady.com> wrote:
>> Perhaps one could possibly just evict pages with _mapcount==0 ?
> 
> That is the present fadvise(FADV_DONTNEED) behaviour.

Ah right. It doesn't invalidate page_mapped() pages.
If that means it doesn't invalidate pages previously cached
by other processes, then great.

However I think what I meant though was fadvise(FADV_DONTNEED)
should only invalidate pages where page_count()<=1

>From include/linux/mm.h

" For pages belonging to inodes, the page_count() is the number of
  attaches, plus 1 if `private' contains something, plus one for
  the page cache itself."

cheers,
Pádraig.

