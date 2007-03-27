Return-Path: <linux-kernel-owner+w=401wt.eu-S934200AbXC0TYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934200AbXC0TYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 15:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934205AbXC0TYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 15:24:55 -0400
Received: from science.horizon.com ([192.35.100.1]:13022 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934200AbXC0TYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 15:24:54 -0400
Date: 27 Mar 2007 15:24:52 -0400
Message-ID: <20070327192452.26486.qmail@science.horizon.com>
From: linux@horizon.com
To: linux@horizon.com, miklos@szeredi.hu
Subject: Re: [patch resend v4] update ctime and mtime for mmaped write
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org
In-Reply-To: <E1HWGpj-0004Yb-00@dorka.pomaz.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> * MS_ASYNC does not start I/O (it used to, up to 2.5.67).

Yes, I noticed.  See
http://www.ussg.iu.edu/hypermail/linux/kernel/0602.1/0450.html
for a bug report on the subject February 2006.

That's why this application is still running on 2.4.

As I mentioned at the time, the SUS says:
(http://opengroup.org/onlinepubs/007908799/xsh/msync.html)
"When MS_ASYNC is specified, msync() returns immediately once all the
write operations are initiated or queued for servicing."

You can argue that putting it on the dirty list constitutes "queued for
servicing", but the intent seems pretty clear to me: MS_ASYNC is supposed
to start the I/O.  Although strict standards-ese parsing says that
either branch of an or is acceptable, it is a common English language
convention that the first alternative is preferred and the second
is a fallback.

It makes sense in this case: start the write or, if that's not possible
(the disk is already busy), queue it for service as soon as the disk
is available.

They perhaps didn't mandate it this strictly, but that's clearly the
intent.
