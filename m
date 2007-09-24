Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441AbXIXHy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbXIXHy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 03:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbXIXHyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 03:54:19 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:23514 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbXIXHyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 03:54:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Dt3eLyg2q4ZEaYWHzS9M4JM/BHNI+C2/Ghq0Typd11jEvz5LU4hlMPY78ltstBpn73cRiK1wabH4SDIhTSOZXCvm5i5zN4GSDYTXU/qjUUwg+T2B9xIHvg8jlW12PPfYyjOWCqZBoB7ZJdQDGh9k73+cHFxGooWMcugsCWfbNao=
Message-ID: <9b0752e70709240054t7b21928eh3b4215f39cd328a5@mail.gmail.com>
Date: Mon, 24 Sep 2007 09:54:17 +0200
From: "Johan Walles" <johan.walles@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: "cat /proc/20502/wchan" vs strace vs man page
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Try this:
1. At one prompt, do "cat".
Now, switch to another prompt and...
2. Do "pstree -p|grep cat" to find out the PID of your cat command.  I
get 20502.
3. Do "cat /proc/20502/wchan".  I get "0" here.
4. Do "strace -p 20502".  I get "read(0,  <unfinished ...>" here.

So wchan says cat is waiting for "0".  Strace says cat is waiting for
read (which sounds much more probable to me).

Is "0" the correct contents of /proc/20502/wchan?  I expected it to
say something about "read".

According to "man proc", wchan "is the "channel" in which the process
is waiting.  It is the address of a system call".  "0" doesn't seem to
fit that description.  Is "0" or the man page wrong?

I'm on Ubuntu 7.04 Feisty, i686, have manpages "2.39-1", kernel "Linux
version 2.6.20-16-generic (root@terranova) (gcc version 4.1.2 (Ubuntu
4.1.2-0ubuntu4)) #2 SMP Fri Aug 31 00:55:27 UTC 2007".

I'm not subscribed to the list, please CC me on replies.

  Cheers //Johan
