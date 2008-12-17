Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752864AbYLQVaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbYLQVaq (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 16:30:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbYLQVaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 16:30:18 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:38946 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbYLQVaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 16:30:14 -0500
Message-ID: <49496F58.4030003@garzik.org>
Date: Wed, 17 Dec 2008 16:30:00 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Andreas Dilger <adilger@sun.com>
CC: Chris Mason <chris.mason@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: Notes on support for multiple devices for a single filesystem
References: <1227183484.6161.17.camel@think.oraclecorp.com> <1228962896.21376.11.camel@think.oraclecorp.com> <20081211141436.030c2d65.sfr@canb.auug.org.au> <20081210200604.8e190b0d.akpm@linux-foundation.org> <1229006596.22236.46.camel@think.oraclecorp.com> <20081215210323.GB5000@webber.adilger.int> <20081217132343.GA14695@infradead.org> <20081217115325.3312858a.akpm@linux-foundation.org> <1229547485.27170.77.camel@think.oraclecorp.com> <20081217212409.GB5000@webber.adilger.int>
In-Reply-To: <20081217212409.GB5000@webber.adilger.int>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Dilger wrote:
> I can't speak for btrfs, but I don't think multiple device access from
> the filesystem is a "layering violation" as some people comment.  It is
> just a different type of layering.  With ZFS there is a distinct layer
> that is handling the allocation, redundancy, and transactions (SPA, DMU)
> that is exporting an object interface, and the filesystem (ZPL, or future
> versions of Lustre) is built on top of that object interface.


Furthermore...  think about object-based storage filesystems.  They will 
need to directly issue SCSI commands to storage devices.  Call it a 
layering violation if you will, but you simply cannot even pretend that 
an OSD is a linear block device for the purposes of our existing block 
layer.

	Jeff



