Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396AbZKCOrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbZKCOrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 09:47:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbZKCOrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 09:47:06 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:59552 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbZKCOrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 09:47:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/27] BKL: Push down BKL from do_new_mount() to the filesystems get_sb/fill_super operation
Date: Tue, 3 Nov 2009 15:46:40 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Jan Blunck <jblunck@suse.de>, linux-fsdevel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>,
       "Linux-Kernel Mailinglist" <linux-kernel@vger.kernel.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de> <20091103102509.GL21750@bolzano.suse.de> <20091103143333.GA2740@infradead.org>
In-Reply-To: <20091103143333.GA2740@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911031546.40603.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+Duw8rcYcb4JfWALyYg0sxdH9x9VOcL1533p/
 o1Kts+0klDwxhWXhjAnyw0/N1Wytoj186ZaKHEnaz/0kwqlWeY
 RirPz5M/CdoaGSovgrDBw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 November 2009, Christoph Hellwig wrote:
> On Tue, Nov 03, 2009 at 11:25:09AM +0100, Jan Blunck wrote:
> >
> > My plan was to remove the BKL in the obvious cases in the followup patches
> > that are also included in the series. So should I just merge the obvious stuff
> > into one patch? Christian Borntraeger was actually requesting the opposite. He
> > wants to be able to bisect it to the patch that is removing the BKL. That
> > would be much simple with many small patches I think.
> 
> Yes, but for most filesystems the BKL never made sense.  Anywhere where
> it's non-obvious (or the maintainer wants it) make it a separate patch,
> but don't bother for things like xfs or btrfs.
> 

In order to maintain bisectability, you could first add the explicit BKL
in the file systems where it may be needed and then remove it from the
common code in the final patch, listing all file systems by category
(doesn't need BKL, holds BKL itself) that you looked at.

Shorter series, but same results because of the recursive nature of
the BKL.

	Arnd <><
