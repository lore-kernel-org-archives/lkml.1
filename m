Return-Path: <linux-kernel-owner+w=401wt.eu-S1759305AbZAMNZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305AbZAMNZE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:25:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756803AbZAMNYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:24:50 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:42296 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756324AbZAMNYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:24:49 -0500
Message-ID: <496C9617.80701@garzik.org>
Date: Tue, 13 Jan 2009 08:24:39 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Benny Halevy <bhalevy@panasas.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       open-osd development <osd-dev@open-osd.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Matthew Wilcox <matthew@wil.cx>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Avishay Traeger <avishay@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [osd-dev] [PATCH 7/9] exofs: mkexofs
References: <4947BFAA.4030208@panasas.com>	<4947CA5C.50104@panasas.com>	<20081229121423.efde9d06.akpm@linux-foundation.org>	<495B8D90.1090004@panasas.com>	<1230739053.3408.74.camel@localhost.localdomain>	<4960D3CA.2000202@panasas.com>	<1231783926.3256.29.camel@localhost.localdomain>	<496B989F.7050907@garzik.org>	<1231790190.15161.29.camel@localhost.localdomain>	<496BA671.3070900@garzik.org> <1231802758.27151.18.camel@localhost.localdomain> <496C9109.5040803@panasas.com>
In-Reply-To: <496C9109.5040803@panasas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benny Halevy wrote:
> IMO the main advantage of moving block allocation down to the OSD target
> is more apparent with distributed file systems a-la pNFS over objects
> where paralleling that task is a key for scalable performance.
> 
> The thing is that the target needs to implement its own mapping from
> object logical offsets into disk blocks and this is usually done
> using some kind of a (possibly trimmed down) local file system.
> Therefore the I/O performance of a single OSD is likely to be similar
> to a single file server's.

Well, modern SATA devices are already mini-filesystems internally, when 
you consider logical block remapping etc.

And the claim by drive research guys at the filesystem/storage summit 
was that OSD offered the potential to better optimize storage based on 
access/usage patterns.

(of course, whether or not reality bears out this guess is another question)


> I can understand representing a single object as a block device (although I
> think that using a file for that should be good enough and easier) but
> why representing the whole OSD as a block device?  The OSD holds partitions
> and objects each with attributes and OSD security related support.  Hence
> representing that in a namespace using a filesystem seems straight forward.

I am actually considering writing a simple "osdblk" driver, that would 
represent a single object as a block device.

This would NOT replace exofs or other OSD filesystems, but it would be 
nice to have, and it will give me more experience with OSDs.

	Jeff


