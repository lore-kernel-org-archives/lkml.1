Return-Path: <linux-kernel-owner+w=401wt.eu-S1754006AbYLZWUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbYLZWUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 17:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbYLZWUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 17:20:06 -0500
Received: from main.gmane.org ([80.91.229.2]:43194 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbYLZWUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 17:20:05 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: RFC: detection of silent corruption via ATA long sector reads
Date: Fri, 26 Dec 2008 16:15:51 -0600
Message-ID: <49555797.3080009@shaw.ca>
References: <87f94c370812261344s3f70de25r4d132101d2247e00@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: linux-raid@vger.kernel.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
In-Reply-To: <87f94c370812261344s3f70de25r4d132101d2247e00@mail.gmail.com>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Freemyer wrote:
> All,
> 
> On the mdraid list, there was a recent thread about using raid
> functionality to detect / repair silent corruption.
> 
> The issues brought up were that a lot of silent data corruption occurs
> when cables, controllers, power supplies, ram, cache, etc. goes bad.
> 
> It made me think about another option for detecting silent corruption
> I have not seen discussed, but maybe I missed it.
> 
> Aiui, the ATA spec allows for the reading of a long sector as well as
> the normal 512 byte sector.  When you get a long sector you also get
> the CRC (or whatever checksum data there is on the disk that allows
> the drive itself to detect media errors).
> 
> I don't have any idea how easy or hard it would be to do, but I would
> like to see the entire block subsystem enhanced to optionally allow
> long sector reads to be used in a "paranoid" fashion.
> 
> Effectively it would be:
> 
> 1) Read long sector from drive:  verify CRC in kernel.  This tests
> most everything on the i/o path.
> 
> 2) maintain CRC type information in block subsystem.  Verify no
> corruption just before handing off to userspace.  This would
> potentially identify CPU/cache/RAM failures.

Even if the drive supports those commands the problem is the CRC/ECC 
data is in a vendor-specific format, so it couldn't be processed 
generically.

