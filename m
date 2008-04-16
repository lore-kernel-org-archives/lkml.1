Return-Path: <linux-kernel-owner+w=401wt.eu-S1764048AbYDPTe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764048AbYDPTe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 15:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbYDPTeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 15:34:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44710 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbYDPTeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 15:34:21 -0400
Date: Wed, 16 Apr 2008 20:34:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Joakim Tjernlund <joakim.tjernlund@transmode.se>,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: Current git tree broke busybox start-stop-daemon
Message-ID: <20080416193417.GD27459@ZenIV.linux.org.uk>
References: <1208366702.5911.119.camel@gentoo-jocke.transmode.se> <20080416190057.GA4666@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080416190057.GA4666@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 11:00:57PM +0400, Alexey Dobriyan wrote:
> On Wed, Apr 16, 2008 at 07:25:02PM +0200, Joakim Tjernlund wrote:
> > open("/proc/1/stat", O_RDONLY|O_LARGEFILE) = 4
> > _llseek(4, 0, 0xbfb94898, SEEK_END)     = -1 EINVAL (Invalid argument)
> 
> > So it appears that lseek is no longer allowed for /proc/1/stat
> > Bug or feature?
> > start-stop-daemon works fine in 2.6.23
> 
> That's what happens when switching ->llseek method from NULL
> (effectively, default_llseek), to seq_lseek (which rejects SEEK_END).
> 
> commit be614086a4aff163d5aa0dc160638d1193b59cde
> commit ee992744ea53db0a90c986fd0a70fbbf91e7f8bd
> 
> Al, do you remember why SEEK_END was omitted back then?

Because there's no sane way to implement it?  Note that original cheerfully
did nothing, since it had zero ->i_size for that file.  Which makes program
in question very odd - what behaviour does it rely upon?
