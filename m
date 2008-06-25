Return-Path: <linux-kernel-owner+w=401wt.eu-S1758880AbYFYTlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880AbYFYTlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 15:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbYFYTlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 15:41:44 -0400
Received: from n65a.bullet.mail.sp1.yahoo.com ([98.136.45.12]:39598 "HELO
	n65a.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753552AbYFYTln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 15:41:43 -0400
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Jun 2008 15:41:43 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 48855.32600.bm@omp207.mail.sp1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=ZWpr2KXrI8AyZLtRRIwZ29wIRF0uRGp1nDuy8DYmcAFwiEqNhflTNvzYa7CMMexGPmXVJ0JzwXiUQq0slOhQCvhuDuEAJ6iWuXy6zpgOxyXxYDW1Kk2nwyvPMVMDQlq0hevXTJHhmi/n6cQol+IM/PdoNSyQZUPkRBuDheWjWyc=;
X-Mailer: YahooMailWebService/0.7.199
Date: Wed, 25 Jun 2008 12:35:52 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
Reply-To: free_beer_for_all@yahoo.com
Subject: Re: [PATCH] UTC timestamp option for FAT filesystems
To: Joe Peterson <joe@skyrush.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <48625953.2070101@skyrush.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <943360.32984.qm@web46103.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Wed, 6/25/08, Joe Peterson <joe@skyrush.com> wrote:

> > In addition, may I request that not only the option
> `-o utc,...' be
> > accepted, but also as an alternate, the string
> `gmt', not because it's
> 
> I do understand what you are saying, however I would
> suggest not making
> "gmt" a synonym for the following reasons:

Fair enough, I won't press the matter.  I'm just one of those old
f*rts who still remembers the american WWV talking clock and how
unnerving it was after years to be hearing ``Coordinated Universal
Time'' so I deserve to wither and drop off the vine.  Also, in case
of all my consumer equipment, I think 100% of it refers to GMT+2
(in my present time zone), so I wonder if in different languages,
there's a preference for casual use of the phrase GMT (a quick
look in my dictionary shows an entry for GMT, nothing for UTC,
but then, it has no entry for `operating system' or its translated
equivalent.

Wait, I said I wouldn't press the matter.

Anyway, I'm doing a quick diff against my code.  (Mine also
contains no documentation either, which is why I didn't post my
hacks a couple days earlier.)  I see some things that are likely
irrelevant; however, here's something missing -- WARNING, line
numbers are based on hacked 2.6.24-ish code; later kernels I've
built so far have been without these hacks -- PLEASE REVIEW AND
IF APPLICABLE, APPLY BY HAND


--- /mnt/usr/local/src/linux-2.6.24/fs/fat/inode.c-DIST 2008-01-30 10:59:19.000000000 +0100
+++ /mnt/usr/local/src/linux-2.6.24/fs/fat/inode.c      2008-04-13 07:09:10.000000000 +0200
@@ -826,6 +829,9 @@ static int fat_show_options(struct seq_f
                seq_puts(m, ",showexec");
        if (opts->sys_immutable)
                seq_puts(m, ",sys_immutable");
+/* XXX HACK */
+       if (opts->utc)
+               seq_puts(m, ",utc");
        if (!isvfat) {
                if (opts->dotsOK)
                        seq_puts(m, ",dotsOK=yes");


The above will result in something like
/dev/sdc1 on /opt type vfat (ro,utc,dmask=222,fmask=133,shortname=win95)
(sorry if your code has this and I overlooked it)

Apart from this, if your diffs compile and work, it looks like only
trivial coding style differences between ours (thus yours are better).


thanks,
barry bouwsma


      

