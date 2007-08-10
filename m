Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbXHJVUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbXHJVUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 17:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbXHJVUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 17:20:10 -0400
Received: from pat.uio.no ([129.240.10.15]:39773 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934702AbXHJVUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 17:20:07 -0400
Subject: Re: nfs - duplicate directory entries
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Vladimir Volovich <vvv@vsu.ru>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <873ayrgkx9.fsf@vvv.vsu.ru>
References: <87fy2rgpqs.fsf@vvv.vsu.ru>
	 <1186778529.6642.52.camel@heimdal.trondhjem.org>
	 <873ayrgkx9.fsf@vvv.vsu.ru>
Content-Type: text/plain
Date: Fri, 10 Aug 2007 17:20:02 -0400
Message-Id: <1186780802.6642.78.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.103)
X-UiO-Scanned: 3250203BB17070FB3669F649B2B98BE3BBF39A7B
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 89 total 3192000 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-08-11 at 01:05 +0400, Vladimir Volovich wrote:
> "TM" == Trond Myklebust writes:
> 
>  >> i.e. the current directory contains sub-directory 112920 twice,
>  >> sub-directory 112921 twice, etc. - and the inode numbers are the
>  >> same.
> 
>  TM> That can happen if the NFS server doesn't send unique cookies.
> 
> i have 2 questions:
> 
> 1) how to debug this, to confirm that this is caused by NFS server not
>    sending unique cookies? (to try to report to the "vendor" of the
>    NFS server)

You would have to use something like 'wireshark' or 'ethereal' to look
at the actual cookies returned by the server in reply to client READDIR
requests.

> 2) does it make sence to try to gracefully work-around this problem on
>    the linux side? or would it significantly complicate things?

Assuming that it is indeed the non-unique cookie problem:

Firstly, it is my policy never to fix NFS server bugs inside the NFS
client.

Secondly, it is in any case impossible to work around this sort of thing
reliably. The cookie is used by the client in the case where you have a
large directory that requires several READDIR rpc calls. It acts in much
the same way telldir()/seekdir() does: the server supplies the cookie in
a previous READDIR call, then upon the next call to READDIR, the client
uses the cookie to tells the server to first seekdir() to the location
that was last read, and then to resume from there.

Trond

