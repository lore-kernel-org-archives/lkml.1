Return-Path: <linux-kernel-owner+w=401wt.eu-S1755258AbZJ2QVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbZJ2QVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 12:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754769AbZJ2QVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 12:21:41 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:45280 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbZJ2QVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 12:21:41 -0400
Date: Thu, 29 Oct 2009 10:21:45 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Tejun Heo <teheo@suse.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH 2/3] Sysfs: Allow directories to be populated
	dynamically
Message-ID: <20091029162145.GM10555@parisc-linux.org>
References: <20091020054740.GC29158@parisc-linux.org> <20091020055021.GE29158@parisc-linux.org> <4AE9C0B0.3030304@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE9C0B0.3030304@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 05:20:00PM +0100, Tejun Heo wrote:
> This will increase the size of struct sysfs_dirent by three pointers
> which is considerable.  Bloating the size of sysfs_dirent can waste
> large amount of memory on machines with a lot of disks.

No it won't.  It's in a union with sysfs_inode_attrs which contains a
struct iattr, which is at least 52 bytes.

> The implementation looks quite scary to me.  Is this the only way to
> do this?  It it because trying to create individual entries for msix
> will end up creating too many sysfs entries?  If so, how many are we
> talking about?

While that's the original motivation, shrinking the amount of memory
taken by sysfs overall is a worthwhile achievement, don't you think?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
