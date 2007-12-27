Return-Path: <linux-kernel-owner+w=401wt.eu-S1752734AbXL0Ly7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbXL0Ly7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 06:54:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbXL0Lyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 06:54:52 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:44102 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbXL0Lyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 06:54:51 -0500
Message-ID: <47739288.7000308@garzik.org>
Date: Thu, 27 Dec 2007 06:54:48 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: saeed bishara <saeed.bishara@gmail.com>
CC: linux-kernel@vger.kernel.org, NFS list <linux-nfs@vger.kernel.org>
Subject: Re: read-ahead in NFS server
References: <c70ff3ad0712260351i6583aa8dpbf16ed606a634b1f@mail.gmail.com>	 <47730F2F.3080900@garzik.org> <c70ff3ad0712270050u134616d1q459ed073c586dcec@mail.gmail.com>
In-Reply-To: <c70ff3ad0712270050u134616d1q459ed073c586dcec@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

saeed bishara wrote:
>> (linux-nfs added to cc)
>>
>> I cannot speak for the NFS server code specifically, but 32kb sounds
>> like a network read (or write) data size limit.
> yes
>> Are you using TCP?  Are you using NFSv4, or an older version?
> I'm using NFSv3/UDP.

IMO, you definitely want TCP and NFSv4.  Much better network behavior, 
with some of the silly UDP limits (plus greatly improved caching 
behavior, due to v4 delegations).


> I found that the actual requests size was 16KB, after doing some hacks
> in server&client I managed to make it 60KB, now I see better
> performance, and I see that the average request size is ~130KB which
> means that there is actually read-ahead. but why it's only 130KB? how
> can I make it larger?
> when I run local dd with bs=4K, I can see that the average IO size is
> more than 300KB.

Read-ahead is easier in NFSv4, because the client probably has the file 
delegated locally, and has far less need to constantly revalidate file 
mapping(s).

	Jeff



