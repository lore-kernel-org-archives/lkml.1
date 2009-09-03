Return-Path: <linux-kernel-owner+w=401wt.eu-S1756181AbZICTFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbZICTFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 15:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756174AbZICTFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 15:05:03 -0400
Received: from lo.gmane.org ([80.91.229.12]:32855 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756170AbZICTFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 15:05:02 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Eric Blake <ebb9@byu.net>
Subject: Re: make getdents/readdir POSIX compliant wrt mount-point =?utf-8?b?CWRpcmVudC5kX2lubw==?=
Date: Thu, 3 Sep 2009 14:50:52 +0000 (UTC)
Message-ID: <loom.20090903T164650-995@post.gmane.org>
References: <87y6oyhkz8.fsf@meyering.net> <20090901201943.GB6996@mit.edu> <a36005b50909011503y73efdf56yabc4d981db2989bc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 128.170.36.102 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2 (.NET CLR 3.5.30729))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper <drepper <at> gmail.com> writes:

> I guess that this is really a difficult way to solve.  I wouldn't want
> to pay for something which is hardly ever really used.
> 
> But there are programs out there which would like to use the inode
> uniqueness.  Therefore the next best thing to do is perhaps to return
> a flag in the getdents information (in d_type, perhaps) to indicate
> that this is a mount point and/or that there are multiple ways to
> access the file in question.  Then programs which can use the inode
> information can be watching for this flag and enter the slow path only
> if it's set.

An alternative to a flag in d_type might be setting d_ino to a sentinel value
(there is plenty of existing code that refuses to use a readdir entry with d_ino
of 0, so it would have to be something else; but maybe -1 would work).  But I
definitely like your idea of making it obvious to the application (whether by
d_ino or d_type) when it is necessary to use lstat to validate the inode number,
and promising that if the flag is not set then d_ino is correct.

-- 
Eric Blake


