Return-Path: <linux-kernel-owner+w=401wt.eu-S1945910AbXCWOtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945910AbXCWOtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 10:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945901AbXCWOtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 10:49:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51692 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945911AbXCWOtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 10:49:14 -0400
Date: Fri, 23 Mar 2007 14:49:12 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>, Tomas M <tomas@slax.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] [bugfix] loop.c
Message-ID: <20070323144912.GB4095@ftp.linux.org.uk>
References: <4603DE86.1090009@slax.org> <20070323144109.GA15114@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070323144109.GA15114@infradead.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 02:41:09PM +0000, Christoph Hellwig wrote:
> The right thing to start with is to split the allocation up, and allocate
> each loop device by itself, like in the untested patch below:
> 
> After that you're not wasting memory for any off number of loop devices
> and can create as many as you have device numbers available:

NAK.  You _can't_ bail out in init after add_disk().  It might have been
opened already.
