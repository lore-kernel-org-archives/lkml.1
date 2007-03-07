Return-Path: <linux-kernel-owner+w=401wt.eu-S1422991AbXCGSu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422991AbXCGSu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 13:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422987AbXCGSu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 13:50:58 -0500
Received: from smtp.osdl.org ([65.172.181.24]:49031 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965462AbXCGSuz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 13:50:55 -0500
Date: Wed, 7 Mar 2007 10:50:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?B?UOFkcmFpZw==?= Brady <P@draigBrady.com>
Cc: bert hubert <bert.hubert@netherlabs.nl>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: userspace pagecache management tool
Message-Id: <20070307105035.5f5b31d4.akpm@linux-foundation.org>
In-Reply-To: <45EEA456.9020907@draigBrady.com>
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>
	<45E9DD4A.2060806@redhat.com>
	<20070303131204.6706a95c.akpm@linux-foundation.org>
	<45E9E910.2070804@redhat.com>
	<20070303214108.GA28961@outpost.ds9a.nl>
	<20070303141448.1ed70e6d.akpm@linux-foundation.org>
	<45E9F454.2080600@redhat.com>
	<20070303142609.d3bc9cc3.akpm@linux-foundation.org>
	<20070303230155.GA475@outpost.ds9a.nl>
	<20070303154541.70aed9df.akpm@linux-foundation.org>
	<45ED5A49.1010702@draigBrady.com>
	<20070306134046.5be821f5.akpm@linux-foundation.org>
	<45EEA456.9020907@draigBrady.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Mar 2007 11:39:02 +0000 Pádraig Brady <P@draigBrady.com> wrote:

> Andrew Morton wrote:
> > On Tue, 06 Mar 2007 12:10:49 +0000
> > P__draig Brady <P@draigBrady.com> wrote:
> >> Perhaps one could possibly just evict pages with _mapcount==0 ?
> > 
> > That is the present fadvise(FADV_DONTNEED) behaviour.
> 
> Ah right. It doesn't invalidate page_mapped() pages.

yup

> If that means it doesn't invalidate pages previously cached
> by other processes, then great.

It will do that.  This is why I point out that this userspace tool
could (easily) be enhanced to not invalidate pages which were
in pagecache prior to their being read by the managed application.
