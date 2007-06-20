Return-Path: <linux-kernel-owner+w=401wt.eu-S1762609AbXFTGDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762609AbXFTGDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 02:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757616AbXFTGDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 02:03:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48278 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757380AbXFTGDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 02:03:12 -0400
Subject: Re: [RFC PATCH 1/4] Union mount documentation.
From: Arjan van de Ven <arjan@infradead.org>
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070620055157.GC4267@in.ibm.com>
References: <20070620055050.GB4267@in.ibm.com>
	 <20070620055157.GC4267@in.ibm.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Tue, 19 Jun 2007 22:59:51 -0700
Message-Id: <1182319191.2700.9.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-20 at 11:21 +0530, Bharata B Rao wrote:
> From: Bharata B Rao <bharata@linux.vnet.ibm.com>
> Subject: Union mount documentation.
Hi,

first of all I'm happy to see that people are still working on unionfs;
I'd love to have functionality like this show up in Linux.

I'll not claim to have any VFS knowledge whatsoever, but I was just
wondering what happens in the following scenario:

FS A is mounted twice, in /mnt/A and /mnt/union

FS B is mounted twice, in /mnt/B and as topmost union mount
on /mnt/union

lets for simplicity say both filesystems are entirely empty

user does on FS A: 
mkdir  /mnt/A/somedir
touch /mnt/A/somedir/somefile

and then 2 things happen in parallel
1) touch /mnt/B/somefile
2) mv /mnt/union/somedir /mnt/union/somefile

since the underlying FS for 2) is FS A... how will this work out locking
wise? Will the VS lock the union directory only? Or will this operate
only on the underlying FS? How is dcache consistency guaranteed for
scenarios like this?


Greetings,
   Arjan van de Ven

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

