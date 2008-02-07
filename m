Return-Path: <linux-kernel-owner+w=401wt.eu-S1759983AbYBGGju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983AbYBGGju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 01:39:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820AbYBGGjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 01:39:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33290 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940AbYBGGjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 01:39:40 -0500
Date: Wed, 6 Feb 2008 22:44:07 -0800
From: Greg KH <gregkh@suse.de>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: Re: partition sysfs OOPS in current GIT
Message-ID: <20080207064407.GA22963@suse.de>
References: <20080207000959.GA16601@suse.de> <20080206.200618.11213859.davem@davemloft.net> <20080207054738.GB20902@suse.de> <20080206.220544.238067538.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080206.220544.238067538.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 10:05:44PM -0800, David Miller wrote:
> From: Greg KH <gregkh@suse.de>
> Date: Wed, 6 Feb 2008 21:47:38 -0800
> 
> > On Wed, Feb 06, 2008 at 08:06:18PM -0800, David Miller wrote:
> > > I redid the bisect to make sure it absolutely was that specific
> > > changeset, and it is.
> > 
> > Thanks for doing that, I'll let you know when I have a patch to test.
> 
> I found the problem, it's the "whole_disk" partition attribute.
> 
> Look in fs/partitions/check.c:add_partition() where it tests the
> ADDPART_FLAG_WHOLEDISK flag.

So, if you just comment out that whole "if (flags &
ADDPART_FLAG_WHOLEDISK)" chunk, does the oops go away?  I think that is
the real solution here as I don't see what this attribute is supposed to
be showing.

thanks,

greg k-h
