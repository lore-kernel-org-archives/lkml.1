Return-Path: <linux-kernel-owner+w=401wt.eu-S1759361AbYHaM2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759361AbYHaM2Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 08:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758380AbYHaM2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 08:28:15 -0400
Received: from emulex.emulex.com ([138.239.112.1]:42949 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757865AbYHaM2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 08:28:14 -0400
Message-ID: <48BA8E3F.9080205@emulex.com>
Date: Sun, 31 Aug 2008 08:27:43 -0400
From: James Smart <James.Smart@Emulex.Com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Simon Arlott <simon@fire.lp0.eu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi/sd: Fix size output in MB
References: <48B9546B.4010004@simon.arlott.org.uk> <1220117091.3615.3.camel@localhost.localdomain> <20080830174516.GD1239@parisc-linux.org> <48B9B552.8060406@simon.arlott.org.uk> <20080830215714.GE1239@parisc-linux.org>
In-Reply-To: <20080830215714.GE1239@parisc-linux.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Aug 2008 12:27:47.0714 (UTC) FILETIME=[FA15D620:01C90B64]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> Reasonable minds can certainly disagree on this one.  I respectfully
> submit that reporting a 97415MB capacity is less useful than reporting a
> 97GB capacity.  If you look at drive advertisements, they sell 1TB,
> 1.5TB, 80GB, 750GB, 360GB, ... we should be trying to match that.  I'm a
> little dubious about trying to match the 1.5TB; I think 1500GB is close
> enough, but a 50GB drive shouldn't be reported as 50000MB.  IMO, anyway.

Since when did techies start paying attention to marketing statements ?

We should be doing what's natural and *consistent*, which is typically 
dealing with power-of-2. Saying it's one thing at one level, and when 
the natural use (how many 512 byte sectors get added up later) changes 
that number in a different level, you've created even more confusion. 
There's no consistency.

As far as user concern - they've seen this discrepancy in the PC/Windows 
world for years now...  Why should we be taking on the task to solve or 
answer it now ?  Throw in different overheads for filesystem metadata 
loss, volume manager metadata, raid level loss, etc - you'll never be 
able to explain it all to the user.  And personally, I'd rather have 
natural numbers so that if I do understand the uses, I can do 
calculations without doing number-base conversions.

-- james s


