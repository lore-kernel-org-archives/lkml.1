Return-Path: <linux-kernel-owner+w=401wt.eu-S1030297AbXDWXzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030297AbXDWXzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 19:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030307AbXDWXzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 19:55:16 -0400
Received: from terminus.zytor.com ([192.83.249.54]:51319 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030297AbXDWXzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 19:55:14 -0400
Message-ID: <462D46DF.4090802@zytor.com>
Date: Mon, 23 Apr 2007 16:53:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Eric Hopper <hopper@omnifarious.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Question about Reiser4
References: <462C2E5B.1080008@redhat.com> <Pine.LNX.4.64.0704230353000.25153@server.thyself> <462C4858.3050006@redhat.com> <Pine.LNX.4.64.0704230555020.25153@server.thyself> <462C4D32.4000909@redhat.com> <Pine.LNX.4.64.0704230611430.25153@server.thyself> <462C5034.9090403@redhat.com> <Pine.LNX.4.64.0704230640540.25153@server.thyself> <20070423010445.454eda63.akpm@linux-foundation.org> <20070423135216.GA2744@omnifarious.org> <20070423225640.GA1663@thunk.org>
In-Reply-To: <20070423225640.GA1663@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> 
> One of the big problems of using a filesystem as a DB is the system
> call overheads.  If you use huge numbers of tiny files, then each
> attempt read an atom of information from the DB takes three system
> calls --- an open(), read(), and close(), with all of the overheads in
> terms of dentry and inode cache.
> 

Now, to be fair, there are probably a number of cases where 
open/lseek/readv/close and open/lseek/writev/close would be worth doing 
as a single system call.  The big problem as far as I can see involves 
EINTR handling; such a system call has serious restartability implications.

Of course, there are Ingo's syslets...

	-hpa
