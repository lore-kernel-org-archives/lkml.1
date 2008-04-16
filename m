Return-Path: <linux-kernel-owner+w=401wt.eu-S1758762AbYDPTFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762AbYDPTFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 15:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbYDPTFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 15:05:34 -0400
Received: from hu-out-0506.google.com ([72.14.214.234]:22589 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbYDPTFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 15:05:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=sEXcohk0Y5FYzUt/2k/YW9FyGGThKgZfiHzZGC0LncK3f5D0Nyp4RsNGNfKy8Xx73lFflAlBRwpcQxB0+YxyhHcBLnnLhsaSjRudVfBhgki1eRRdU1i3iT2xsf5YD0Po8iFBEqfdgHRLcfat+0t7cEjXlF5XE8/99Cu3/0UVSGs=
Date: Wed, 16 Apr 2008 23:00:57 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com,
       viro@zeniv.linux.org.uk
Subject: Re: Current git tree broke busybox start-stop-daemon
Message-ID: <20080416190057.GA4666@martell.zuzino.mipt.ru>
References: <1208366702.5911.119.camel@gentoo-jocke.transmode.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208366702.5911.119.camel@gentoo-jocke.transmode.se>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 07:25:02PM +0200, Joakim Tjernlund wrote:
> open("/proc/1/stat", O_RDONLY|O_LARGEFILE) = 4
> _llseek(4, 0, 0xbfb94898, SEEK_END)     = -1 EINVAL (Invalid argument)

> So it appears that lseek is no longer allowed for /proc/1/stat
> Bug or feature?
> start-stop-daemon works fine in 2.6.23

That's what happens when switching ->llseek method from NULL
(effectively, default_llseek), to seq_lseek (which rejects SEEK_END).

commit be614086a4aff163d5aa0dc160638d1193b59cde
commit ee992744ea53db0a90c986fd0a70fbbf91e7f8bd

Al, do you remember why SEEK_END was omitted back then?

