Return-Path: <linux-kernel-owner+w=401wt.eu-S1758099AbXIFQB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbXIFQB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 12:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756260AbXIFQBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 12:01:20 -0400
Received: from sperry-02.control.lth.se ([130.235.83.189]:59279 "EHLO
	sperry-02.control.lth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142AbXIFQBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 12:01:19 -0400
X-Greylist: delayed 785 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Sep 2007 12:01:19 EDT
Message-ID: <46E02137.8030600@control.lth.se>
Date: Thu, 06 Sep 2007 17:48:07 +0200
From: Anders Blomdell <anders.blomdell@control.lth.se>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Stray nulls when reading from AF_UNIX sockets
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With recent kernels (2.6.22.x), we are experiencing that random null characters
are read by  our mySQL server (i.e. the number of bytes read by the server is
larger than the number of bytes written). I'm currently investigating the
problem (that occurs every 1-35 hours on a loaded system). A current suspect is
the following code in  net/unix/af_unix.c:

  static int unix_stream_recvmsg(struct kiocb *iocb, struct socket *sock,
                                 struct msghdr *msg, size_t size,
                                 int flags)
  {
    ...
    return copied ? : err;
  }

Shouldn't this read:

    return copied ? copied : err;

Or am I missing something?

Please CC me personally.

Regards

Anders Blomdell


-- 
Anders Blomdell                  Email: anders.blomdell@control.lth.se
Department of Automatic Control
Lund University                  Phone:    +46 46 222 4625
P.O. Box 118                     Fax:      +46 46 138118
SE-221 00 Lund, Sweden
