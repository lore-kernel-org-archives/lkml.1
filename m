Return-Path: <linux-kernel-owner+w=401wt.eu-S968388AbXEHQYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968388AbXEHQYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 12:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935013AbXEHQYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 12:24:19 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:41468 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935009AbXEHQYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 12:24:15 -0400
Date: Tue, 8 May 2007 20:17:03 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>,
       Andrew Morton <akpm@osdl.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/2] LogFS proper
Message-ID: <20070508161703.GA18035@2ka.mipt.ru>
References: <20070507215913.GA15054@lazybastard.org> <20070507220036.GB15054@lazybastard.org> <1178608950.3042.273.camel@localhost.localdomain> <Pine.LNX.4.61.0705081439270.17280@yvahk01.tjqt.qr> <1178639681.3042.334.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1178639681.3042.334.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Tue, 08 May 2007 20:17:10 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 05:54:41PM +0200, Thomas Gleixner (tglx@linutronix.de) wrote:
> On Tue, 2007-05-08 at 14:46 +0200, Jan Engelhardt wrote:
> > >> +static int __logfs_readdir(struct file *file, void *buf, filldir_t filldir)
> > >> +{
> > >> +		err = read_dir(dir, &dd, pos);
> > >> +		if (err == -EOF)
> > >> +			break;
> > >
> > >	-EOF results in a return code 0 ?
> > 
> > Results in a return code -256.
> 
> Really ? It breaks out of the loop and returns 0 !

Likely it was done with intention - readdir returns 0 on EOF and NULL
direntry, in Jörn's code subsequent readdir call will return EOF 
again and filldir callback will not be called, so NULL will be 
returned to userspace.

-- 
	Evgeniy Polyakov
