Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752705AbYLQV2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbYLQV2k (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 16:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbYLQV20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 16:28:26 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:58640 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237AbYLQV2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 16:28:25 -0500
Message-ID: <49496EDE.5080101@garzik.org>
Date: Wed, 17 Dec 2008 16:27:58 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Chris Mason <chris.mason@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, adilger@sun.com,
        sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Notes on support for multiple devices for a single filesystem
References: <1227183484.6161.17.camel@think.oraclecorp.com>	 <1228962896.21376.11.camel@think.oraclecorp.com>	 <20081211141436.030c2d65.sfr@canb.auug.org.au>	 <20081210200604.8e190b0d.akpm@linux-foundation.org>	 <1229006596.22236.46.camel@think.oraclecorp.com>	 <20081215210323.GB5000@webber.adilger.int>	 <20081217132343.GA14695@infradead.org>	 <20081217115325.3312858a.akpm@linux-foundation.org>	 <1229547485.27170.77.camel@think.oraclecorp.com> <ac3eb2510812171320i414d89d4x9840954275774d51@mail.gmail.com>
In-Reply-To: <ac3eb2510812171320i414d89d4x9840954275774d51@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> Features like the very nice and useful directory-based snapshots would
> also not be possible with simple block-based multi-devices, right?

Snapshotting via block device has always been an incredibly dumb hack, 
existing primarily because filesystem-based snapshots did not exist for 
the filesystem in question.

Snapshots are better at the filesystem level because the filesystem is 
the only entity that knows when the filesystem is quiescent and 
snapshot-able.

ISTR we had to add ->write_super_lockfs() to hack in support for LVM in 
this manner, rather than doing it the right way.

	Jeff


