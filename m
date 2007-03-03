Return-Path: <linux-kernel-owner+w=401wt.eu-S933134AbXCCWwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933134AbXCCWwb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 17:52:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933144AbXCCWwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 17:52:31 -0500
Received: from smtp.osdl.org ([65.172.181.24]:48542 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933134AbXCCWwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 17:52:30 -0500
Date: Sat, 3 Mar 2007 14:52:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: userspace pagecache management tool
Message-Id: <20070303145221.2a42cc0f.akpm@linux-foundation.org>
In-Reply-To: <45E9F5DA.2070708@redhat.com>
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>
	<45E9DD4A.2060806@redhat.com>
	<20070303131204.6706a95c.akpm@linux-foundation.org>
	<45E9E910.2070804@redhat.com>
	<20070303140744.b22699dd.akpm@linux-foundation.org>
	<45E9F5DA.2070708@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 Mar 2007 17:25:30 -0500 Rik van Riel <riel@redhat.com> wrote:

> backup program

A suitable policy for a backup program would probably be to invalidate any
output file(s) and to invalidate those pages of the input files which were
not in cache when the backup program first opened those files.  That way
the backup program will have no effect on the cache state, except for the
race situation where someone read an uncached file while the backup program
was reading from it too.

This can be added in an hour or two with no kernel changes (use mincore).

