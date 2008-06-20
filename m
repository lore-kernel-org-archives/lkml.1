Return-Path: <linux-kernel-owner+w=401wt.eu-S1757925AbYFTPPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925AbYFTPPz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 11:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756557AbYFTPPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 11:15:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:7457 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788AbYFTPPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 11:15:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=CsZ4g9Id+UMteWlzaenuNfMo/r5UE9klruRODUCYHreb8vvOdkjP3IokdpPrisVDh8
         /dJz9pAoa3ODV10RaaMpSapmo1JF27UMpwtQqcsmSQVqcCfimfVKaPqIZYUcCfz5CKee
         Dz3uQOTcyr1pmeN3eJc5lAYSl2St8JxAKPIUA=
Message-ID: <19f34abd0806200815t49b59df9sd9567b52482eaee3@mail.gmail.com>
Date: Fri, 20 Jun 2008 17:15:43 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before mounting root
Cc: "Matthew Wilcox" <matthew@wil.cx>,
       "Pekka J Enberg" <penberg@cs.helsinki.fi>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org, dsd@gentoo.org,
       mdharm-usb@one-eyed-alien.net, linux-usb@vger.kernel.org,
       vegardno@ifi.uio.no, James.Bottomley@hansenpartnership.com,
       linux-scsi@vger.kernel.org, "Greg KH" <greg@kroah.com>
In-Reply-To: <Pine.LNX.4.44L0.0806191735570.2229-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080619182310.GA30833@parisc-linux.org>
	 <Pine.LNX.4.44L0.0806191735570.2229-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 19, 2008 at 11:39 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 19 Jun 2008, Matthew Wilcox wrote:
>
>> This discussion seemed to die off ... did anything ever come of it?
>
> As I recall, it died because the whole notion was very poorly defined
> to begin with.  The idea was to stop waiting when all the SCSI buses
> had been scanned -- but there's no way to know when that occurs because
> new buses can be added at any time.

Can you please explain why this is?

We only want to scan buses that are present when the system is
started. If we reach the point where all USB ports/devices/whatever
have been enumerated, all SCSI buses scanned, and all partition tables
loaded, what more is there to wait for?

I can't understand that this is fundamentally a hardware problem. I
understand that there might be a problem with the patch that was
proposed a the beginning of the thread, but is this really a truly
unsolvable problem? Please correct me if I am wrong -- the problem
here is that Pekka's newly introduced nr_root_scans can drop to 0
before everything has been enumerated at least once. This is because
scsi_scan_host() forks a new thread which is what's actually doing the
scanning. Can't we just stick a begin_root_scan() before forking, and
drop it inside the thread, just like we do with the
usb_stor_scan_thread? If the thread is actually a loop, the first
iteration should be enough, right?

I'm grateful for any explanations that will help my poor head understand... :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
