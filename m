Return-Path: <linux-kernel-owner+w=401wt.eu-S1758643AbZCaMwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643AbZCaMwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 08:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757949AbZCaMwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 08:52:31 -0400
Received: from france.micfo.com ([92.48.68.3]:57376 "EHLO france.micfo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756556AbZCaMwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 08:52:30 -0400
From: Alberto Gonzalez <info@gnebu.es>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: Ext4 and the "30 second window of death"
Date: Tue, 31 Mar 2009 14:52:05 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.28-ARCH; KDE/4.2.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200903291224.21380.info@gnebu.es> <20090331122540.GB13356@mit.edu>
In-Reply-To: <20090331122540.GB13356@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903311452.05210.info@gnebu.es>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - france.micfo.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - gnebu.es
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 March 2009 14:25:40 Theodore Tso wrote:
> On Sun, Mar 29, 2009 at 12:24:21PM +0200, Alberto Gonzalez wrote:
> > Hi,
> >
> > - I use Ext4 as my filesystem (default in next Fedora release).
>
> Fedora will have the patches so that applications that do
> replace-via-truncate (a bad idea, these applications are buggy, and
> will lose data sometimes even with ext3), or replace-via-rename
> without the fsync(), will force the blocks out to disk with the
> commit.
>
> > - Let's say I've been working on my book for the last 14 months and I've
> > written about 400 pages on an ODF file.
>
> Openoffice, being a portable application, that has to work on other
> operating systems and filesystems (for example, like Solaris's UFS),
> does do open/write/close/fsync/rename.  So you're safe if you're using
> OpenOffice (and emacs, and vim).

Ah, good to know, that's quite a relief for normal users like me who were 
getting lost with this discussion. But one other doubt:

You've proposed that in laptop mode, fsync's should be held until next write 
cycle (say every 30 seconds) so that the disk is not spun up unnecessarily, 
wasting battery and shortening it's lifespan too. I absolutely agree with 
this, and as a trade-off I'm ok with losing my last paragraph even if I did hit 
Ctrl+S to save it a few seconds before a crash. But again, with Ext4 will I 
just lose that last paragraph or the whole book in this case?

Thanks,
Alberto.

> Best regards,
>
> 					- Ted

