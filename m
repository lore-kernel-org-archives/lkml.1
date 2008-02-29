Return-Path: <linux-kernel-owner+w=401wt.eu-S1760284AbYB2Qa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760284AbYB2Qa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 11:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932612AbYB2QaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 11:30:14 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:41524 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932568AbYB2QaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 11:30:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=XAEF9HEqAq73YoAJU7MpG/nMfRQR3KjiTw4SzZDIMR8gzzc8PlKTivYtNFahUby43mmf4HHihr3Kao1hXf4wJ1CVsFWwS3yKSFNBdkNmWk2DQgHYyEIiaVoYLt4/mB0UUyOxlnBtHsspiM90bKBLP7m1um6PezZDVJQTnbz9C1c=
Message-ID: <cfd18e0f0802290830y46d1b029hdcbbe2070f8d3773@mail.gmail.com>
Date: Fri, 29 Feb 2008 17:30:12 +0100
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Passing epoll file descriptors across Unix domain sockets
Cc: lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davide,

After all of the recent discussions about epoll, I've been reviewing
other parts of the epoll.7 man page.  In that page there is the
following:

       Q5  Can  I  send  the  epoll  file descriptor over a Unix
           domain socket to another process?

       A5  No.

This does not seem accurate.  I can understand that it makes no sense
to pass a an epoll file descriptor over a Unix domain socket, because
the receiving process does not have the file descriptors that are in
the epoll set.

However, it is indeed possible (no errors result) to pass an epoll fd
over a Unix doman socket using SCM_RIGHTS.  (I have just now tested
this.)

Can you clarify?  I suspect the text should really read:

       Q5  Can  I  send  an  epoll  file  descriptor over a Unix
           domain socket to another process?

       A5  Yes, but it does not make sense to do this, since the
           receiving  process  would not have copies of the file
           descriptors in the epoll set.

Does that seem okay?

Cheers,

Michael

-- 
Michael Kerrisk
Maintainer of the Linux man-pages project
http://www.kernel.org/doc/man-pages/
Want to report a man-pages bug?  Look here:
http://www.kernel.org/doc/man-pages/reporting_bugs.html
