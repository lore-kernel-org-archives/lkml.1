Return-Path: <linux-kernel-owner+w=401wt.eu-S1757946AbYAQUyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946AbYAQUyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 15:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbYAQUyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 15:54:01 -0500
Received: from nz-out-0506.google.com ([64.233.162.230]:31335 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbYAQUyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 15:54:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=c0demOWO31OulSLF49dAN2JQ2wZMFLppUrymY84vgeHRUFZfPh/iYsGs3nmnKJcrJ561cndp6amRwJrBdSzu2lHRbBD4hJteLexs52NcWk1HGRbrVtB1Ko90Z5ZI1mrN0JHILwcdfYPwEk/t9XzN1NRg1dKCh9n/AY+bHaSv+OU=
Message-ID: <23986fd90801171253o56f3dbcbqe44d9f29e719cba1@mail.gmail.com>
Date: Thu, 17 Jan 2008 12:53:58 -0800
From: "Patrick J. LoPresti" <lopresti@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Fast network file copy; "recvfile()" ?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I need to copy large (> 100GB) files between machines on a fast
network.  Both machines have reasonably fast disk subsystems, with
read/write performance benchmarked at > 800 MB/sec. Using 10GigE cards
and the usual tweaks to tcp_rmem etc., I am getting single-stream TCP
throughput better than 600 MB/sec.

My question is how best to move the actual file.  NFS writes appear to
max out at a little over 100 MB/sec on this configuration.  FTP and
rcp give me around 250 MB/sec.  Thus I am planning to write custom
code to send and receive the file.

For sending, I believe my best options are:

1) O_DIRECT read() + send()
2) mmap() + madvise(WILLNEED) + send()
3) fadvise(WILLNEED) + sendfile()

I am leaning towards (3), since I gather that sendfile() is supposed
to be pretty fast.

My question is what to do on the receiving end.  In short, if I want
the equivalent of a "recvfile()" to go with sendfile(), what is my
best bet on Linux?

I will probably try recv() + O_DIRECT write(), but I am curious if
there are other approaches I should try.

Thanks!

 - Pat
