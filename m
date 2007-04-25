Return-Path: <linux-kernel-owner+w=401wt.eu-S2992599AbXDYKrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992599AbXDYKrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 06:47:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992609AbXDYKrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 06:47:06 -0400
Received: from vsmtp1.tin.it ([212.216.176.141]:59744 "EHLO vsmtp1.tin.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992589AbXDYKrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 06:47:05 -0400
X-Greylist: delayed 348 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Apr 2007 06:47:05 EDT
Message-ID: <462F3E87.BAA51761@tin.it>
Date: Wed, 25 Apr 2007 11:41:59 +0000
From: "A.D.F." <adefacc@tin.it>
Reply-To: adefacc@tin.it
Organization: Private
X-Mailer: Mozilla 4.8 [en] (X11; U; Linux 2.2.26 i686)
X-Accept-Language: en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: sendfile to nonblocking socket
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Answer to Alex Vorona (I'm not subscribed to linux kernel list so CC me).

Serious answers to an almost troll question (no offence here :-).

1) The possibility that sendfiles blocks,
   when it has to wait for disk reads / pages,
   has been repeatedly mentioned (and thus known) for ages by everybody
   (including Linus) since kernel 2.2.x;
   if you search the archives (mailing lists, etc.)
   or just google "sendfile blocking" you'll find a lot of stuff about this
issue.

2) A possible answer, to your implicit request to add real asynchronous
support
   to sendfile, is to wait for the general asynchronous support for all
blocking
   syscalls (search the kernel archives in the last 3 months).

3) The simplest solution (that works with every OS) is to just pass
   a small (*) amount of data to each sendfile() call,
   (*) i.e. between 64 KB (very slow disk with DMA disabled)
       and 1024 KB (very fast disk).
 
   Of course, if files to be sent are not in page cache and
   there are more than 10 - 100 parallel downloads of different files,
   you'll see noticeable latencies (because of disk seeks, etc.);
   in any case you may want to add a parameter to this nginx thing
   to let the tuning of chunk size.

4) As it has already been mentioned by others, there are many good solutions
   that can be used right now to allow the required scalability target:
    - using threads;
    - using asynchronous I/O;
    - etc.

5) If you want to use some other Web Server that just works,
   look for the alternatives (including lighttpd or even Apache).

-- 
Nick Name:     A.D.F.
E-Mail:        <adefacc () tin ! it>
--
