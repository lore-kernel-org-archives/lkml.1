Return-Path: <linux-kernel-owner+w=401wt.eu-S1750849AbXBCRxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750849AbXBCRxl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 12:53:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750875AbXBCRxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 12:53:40 -0500
Received: from lazybastard.de ([212.112.238.170]:40156 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbXBCRxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 12:53:40 -0500
Date: Sat, 3 Feb 2007 17:49:47 +0000
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>
Subject: Re: [patch 1/9] fs: libfs buffered write leak fix
Message-ID: <20070203174947.GA2656@lazybastard.org>
References: <20070129081905.23584.97878.sendpatchset@linux.site> <20070129081914.23584.23886.sendpatchset@linux.site> <20070202155236.dae54aa2.akpm@linux-foundation.org> <20070203013316.GB27300@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070203013316.GB27300@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 February 2007 02:33:16 +0100, Nick Piggin wrote:
> 
> If doing a partial-write, simply clear the whole page and set it uptodate
> (don't need to get too tricky).

That sounds just like a bug I recently fixed in logfs.  prepare_write()
would clear the page, commit_write() would write the whole page.  Bug
can be reproduced with a simple testcate:

echo -n foo > foo
echo -n bar >> foo
cat foo

With the bug, the second write will replace "foo" with "\0\0\0" and
cat will return "bar".  Doing a read instead of clearing the page will
return "foobar", as would be expected.

Can you hit the same bug with your patch or did I miss something?

Jörn

-- 
When people work hard for you for a pat on the back, you've got
to give them that pat.
-- Robert Heinlein
