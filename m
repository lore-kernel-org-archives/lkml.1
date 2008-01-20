Return-Path: <linux-kernel-owner+w=401wt.eu-S1759241AbYATFz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241AbYATFz1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 00:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbYATFzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 00:55:20 -0500
Received: from [82.147.214.189] ([82.147.214.189]:37741 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751957AbYATFzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 00:55:20 -0500
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Jan 2008 00:55:18 EST
From: Al Boldi <a1426z@gawab.com>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: konqueror deadlocks on 2.6.22
Date: Sun, 20 Jan 2008 08:41:56 +0300
User-Agent: KMail/1.5
References: <200801192114.41427.a1426z@gawab.com> <1200802290.4166.2.camel@homer.simson.net>
In-Reply-To: <1200802290.4166.2.camel@homer.simson.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801200831.04964.a1426z@gawab.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> On Sat, 2008-01-19 at 21:14 +0300, Al Boldi wrote:
> > I was just attacked by some deadlock issue involving sqlite3 and
> > konqueror. While sqlite3 continues to slowly fill a 7M-record db in
> > transaction mode, konqueror hangs for a few minutes, then continues only
> > to hang again and again.
> >
> > Looks like an fs/blockIO issue involving fsync.
> >
> > As a workaround, is there a way to make fsync soft?
>
> Do you have the fs mounted data=writeback?  A while back, I ran into
> starvation on the order of minutes with my old/full ext2 fs until
> mounting data=writeback.

You are absolutely right.  With data=writeback the hangs completely 
disappear, and sqlite3 insert performance increases 10x fold.

Now data=writeback is known to be faster than data=ordered, but a 10x fold 
increase probably points to some sync contention within the data=ordered 
logic.  Any ideas how this could be fixed?


Thanks a lot!

BTW Mike: Your server bounces my messages.

--
Al


