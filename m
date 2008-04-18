Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbYDROUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbYDROUD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 10:20:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbYDROTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 10:19:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbYDROTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 10:19:50 -0400
Date: Fri, 18 Apr 2008 10:09:46 -0400
From: Josef Bacik <jbacik@redhat.com>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, jack@suse.cz,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
Subject: Re: [PATCH 0/4] jbd: possible filesystem corruption fixes
Message-ID: <20080418140946.GA26062@unused.rdu.redhat.com>
References: <48089B86.5020108@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48089B86.5020108@hitachi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 10:00:54PM +0900, Hidehiro Kawai wrote:
> Subject: [PATCH 0/4] jbd: possible filesystem corruption fixes
> 
> The current JBD is not sufficient for I/O error handling.  It can
> cause filesystem corruption.   An example scenario:
> 
> 1. fail to write a metadata buffer to block B in the journal
> 2. succeed to write the commit record
> 3. the system crashes, reboots and mount the filesystem
> 4. in the recovery phase, succeed to read data from block B
> 5. write back the read data to the filesystem, but it is a stale
>    metadata
> 6. lose some files and directories!
> 
> This scenario is a rare case, but it (temporal I/O error)
> can occur.  If we abort the journal between 1. and 2., this
> tragedy can be avoided.
> 
> This patch set fixes several error handling problems to protect
> from filesystem corruption caused by I/O errors.  It has been
> done only for JBD and ext3 parts.
>

There doesn't seem like much point in taking these patches as Jan is rewriting
the ordered mode path and most of these functions will be going away soon.
Those patches seem like they will be coming soon and will obsolete these.

Josef 
