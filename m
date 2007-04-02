Return-Path: <linux-kernel-owner+w=401wt.eu-S934026AbXDBMrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934026AbXDBMrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 08:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934014AbXDBMrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 08:47:06 -0400
Received: from styx.suse.cz ([82.119.242.94]:40949 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934026AbXDBMrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 08:47:05 -0400
Date: Mon, 2 Apr 2007 14:54:16 +0200
From: Jan Kara <jack@suse.cz>
To: Tino Keitel <tino.keitel@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] UDF cleanup and fixes
Message-ID: <20070402125415.GJ3728@duck.suse.cz>
References: <20070306164447.GC3661@duck.suse.cz> <20070330045923.GA5528@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070330045923.GA5528@dose.home.local>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 30-03-07 06:59:23, Tino Keitel wrote:
> On Tue, Mar 06, 2007 at 17:44:47 +0100, Jan Kara wrote:
> >   Hello,
> > 
> >   the patches attached to six following emails implement some cleanup and
> > fixes in the UDF code. The main two fixes are:
> >   1) UDF now works correctly for files larger than 1GB.
> 
> Hi,
> 
> I tried 2.6.20 with your patches and got the following behaviour:
> 
> $ ls -la dvd.udf 
> -rw-r--r-- 1 root root 4699717632 Mar 29 15:36 dvd.udf
> $ mount -o loop -t udf dvd.udf /media/udf/
> $ df /media/udf/
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /home/storage/dvd.udf
>                        4588506 -8584746354 8589334860   -  /media/udf
>                                ^^^^^^^^^^^^^^^^^^^^^^
> $ ls -la /media/udf/
> total 4587521
> drwxr-xr-x 3 root root        144 Mar 29 15:36 .
> drwxr-xr-x 9 root root       1024 Mar 20 12:02 ..
> -rw-r--r-- 1 root root 4697620480 Mar 29 15:57 bk_usr.tar
> drwxr-xr-x 2 root root         40 Mar 29 15:36 lost+found
  Thanks for report. I'll have a look at it. I've tested my patches on a
64-bit machine and obviously some computation overflows on a 32-bit one...

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
