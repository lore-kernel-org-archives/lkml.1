Return-Path: <linux-kernel-owner+w=401wt.eu-S932574AbZJ3QFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574AbZJ3QFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 12:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932569AbZJ3QFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 12:05:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41403 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932511AbZJ3QFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 12:05:32 -0400
Message-ID: <4AEB0F0C.2040106@suse.de>
Date: Fri, 30 Oct 2009 17:06:36 +0100
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH 2/3] Sysfs: Allow directories to be populated	dynamically
References: <20091020054740.GC29158@parisc-linux.org> <20091020055021.GE29158@parisc-linux.org> <4AE9C0B0.3030304@suse.de> <20091029162145.GM10555@parisc-linux.org> <4AE9C29E.6090706@suse.de> <20091029192414.GN10555@parisc-linux.org> <4AEABD32.8010509@suse.de> <20091030111452.GP10555@parisc-linux.org>
In-Reply-To: <20091030111452.GP10555@parisc-linux.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Matthew Wilcox wrote:
>> In this particular case, the trade off is actually much worse because
>> sysfs_dirent is being increased but the only one which is seeing any
>> kind of memory usage drop is the new msi-x code.  Given that there can
>> be only a handful of msi-x controllers even in a fairly large system,
>> I don't think memory usage will be reduced in any meaningful way even
>> on affected systems and if you think about large systems with
>> thousands and tens of thousands block devices, the bloat in
>> sysfs_dirent will waste a lot of memory.
> 
> Every attribute sees a drop in memory usage.  I think I saw about 30%
> fewer dirents created on boot with this laptop.  Why not try this patch
> on one of your machines and see the difference?

Heh... Sorry, I'm still travelling so testing is a bit difficult but
even if you reduce the number of dirents by 30% if you add three
pointers worth of memory to each sysfs_dirent, I don't think it will
amount to any meaningful amount of memory usage drop and given that
sysfs_dirent can be reduced further in size with some tricks, I think
that would be the better way to reduce memory footprint.

Thanks.

-- 
tejun
