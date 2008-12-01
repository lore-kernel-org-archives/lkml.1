Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbYLATbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbYLATbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 14:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbYLATbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 14:31:36 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58415 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbYLATbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 14:31:35 -0500
To: bharata@linux.vnet.ibm.com
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org, jblunck@suse.de,
       dlezcano@fr.ibm.com, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk
In-reply-to: <20081201075953.GE3388@in.ibm.com> (message from Bharata B Rao on
	Mon, 1 Dec 2008 13:29:53 +0530)
Subject: Re: [rfc git patch] union directory
References: <E1L616K-0005v3-Uc@pomaz-ex.szeredi.hu> <20081128161921.GA3843@in.ibm.com> <E1L6Skx-0007uK-3H@pomaz-ex.szeredi.hu> <20081201043509.GA3388@in.ibm.com> <20081201075953.GE3388@in.ibm.com>
Message-Id: <E1L7EUL-0003ej-Su@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 01 Dec 2008 20:31:21 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2008, Bharata B Rao wrote:
> On Mon, Dec 01, 2008 at 10:05:09AM +0530, Bharata B Rao wrote:
> > On Sat, Nov 29, 2008 at 05:33:19PM +0100, Miklos Szeredi wrote:
> > > On Fri, 28 Nov 2008, Bharata B Rao wrote:
> > > 
> > > The plan is to get a simple kernel implementation first which caches
> > > the directory in 'struct file'.
> > 
> > FYI, I did this for a version of Union Mount.
> > (http://lkml.org/lkml/2007/6/20/21) I was maintaining the readdir cache in
> > struct file and the cache was persistant across readdir calls.
> > 
> > Do you have anything different in mind ?

Thanks for the pointer.  Yes something like that.

> 
> The version pointed to by me above had the entire cache stored
> in the struct file of the topmost directory. I guess your plan
> is to cache them per branch and combine them during
> readdir()/getdents() ?

No, the plan is to cache it in the struct file of the topmost
directory.  This should also solve the lseek() issue.

The only concern is that this caching behavior can waste unswappable
kernel memory.  But unless some malicious application actually wants
to exploit this, I don't think it will be a big issue in practice.

Miklos
