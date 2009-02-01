Return-Path: <linux-kernel-owner+w=401wt.eu-S1752345AbZBAQdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbZBAQdJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 11:33:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbZBAQc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 11:32:56 -0500
Received: from verein.lst.de ([213.95.11.210]:49172 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162AbZBAQc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 11:32:56 -0500
Date: Sun, 1 Feb 2009 17:32:34 +0100
From: Christoph Hellwig <hch@lst.de>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, hpa@zytor.com, hch@lst.de,
       serue@us.ibm.com, "David C. Hansen" <haveblue@us.ibm.com>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org,
       sukadev@us.ibm.com
Subject: Re: [RFC][PATCH] simple_set_mnt() should return void
Message-ID: <20090201163234.GC3416@lst.de>
References: <20090129063001.GA22898@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129063001.GA22898@us.ibm.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 10:30:01PM -0800, Sukadev Bhattiprolu wrote:
> 
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Date: Wed, 28 Jan 2009 17:11:13 -0800
> Subject: [RFC][PATCH] simple_set_mnt() should return void
> 
> simple_set_mnt() is defined to return int but always returns 0.
> Callers assume simple_set_mnt() never fails and don't properly
> cleanup if it were to _ever_ fail. For instance, get_sb_single()
> and get_sb_nodev() should:
> 
>         up_write(sb->s_unmount);
>         deactivate_super(sb);
> 
> if simple_set_mnt() fails.
> 
> Since simple_set_mnt() never fails, would be cleaner if it did
> not return anything.

Makes sense to me.  Feel free to resend once you did an allmodconfig
or similar build.

