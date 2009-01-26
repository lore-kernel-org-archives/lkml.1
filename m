Return-Path: <linux-kernel-owner+w=401wt.eu-S1752723AbZAZMPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbZAZMPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 07:15:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbZAZMPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 07:15:38 -0500
Received: from lucidpixels.com ([75.144.35.66]:48494 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbZAZMPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 07:15:37 -0500
Date: Mon, 26 Jan 2009 07:15:36 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Anton Petrusevich <casus@casus.us>
cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: WD IDNF error
In-Reply-To: <200901261305.09024.casus@casus.us>
Message-ID: <alpine.DEB.1.10.0901260708570.7084@p34.internal.lan>
References: <200901261305.09024.casus@casus.us>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 26 Jan 2009, Anton Petrusevich wrote:

> Hello,
>
>
> Google shows me you had a similar problem. I have a WDC WD3000HLFS-01G6U0 in
> one my server and this drive is used for oracle database, and it's already
> second time when I get error like this:
>
> Jan 26 11:13:31 rc03 kernel: [5131931.511985] ata2.00: status: { DRDY ERR }
> Jan 26 11:13:31 rc03 kernel: [5131931.511985] ata2.00: error: { IDNF }
>
> Several months ago when it happend first time I extensively checked the drive
> after reboot and it worked flawlessly, but database was corrupted. This time
> I just rebooted the server and overwrote one control file and everything goes
> normal. This error is actually bothers me as I don't actually like to restore
> database from backup which can be sometimes a little bit outdated.
>
> So, have you find a solution? My kernel is 2.6.26-1-amd64,  I read about NCQ,
> I see:
> Jan 26 14:24:16 rc03 kernel: [    3.759922] ata2.00: ATA-8: WDC
> WD3000HLFS-01G6U0, 04.04V01, max UDMA/133
> Jan 26 14:24:16 rc03 kernel: [    3.759995] ata2.00: 586072368 sectors, multi
> 16: LBA48 NCQ (depth 0/32)
>
> So, NCQ is already disabled.
> -- 
> Anton Petrusevich
>

Please see:
http://forums.storagereview.net/index.php?showtopic=27303&hl=premature

Other users are also reporting this, the fix for me was to replace my 
drives with WD RE3s.  After 9-10 RMAs and no fix, it is some bug in the 
kernel or drive firmware, after 6-12mos of RMA and corrupted files, broken 
raids and weeks of lost time dealing with this problem, I removed all my 
WD Velociraptors from production, replaced with WD RE3 and have not 
had a problem since.

Turning off NCQ fixes the problem with Raptor's and Velociraptors too, 
where NCQ doesn't work well with Linux for these particular drives; 
however, the DRDY ERR and IDNF errors-- there's something wrong with the 
Velociraptors in Linux, I'd suggest subscribing to that forum and adding 
your notes there, that is where I have been tracking the issue primarily.

I have cc'd linux-kernel and linux-ide here for further suggestions, 
unfortunately however, I do not know of anyone who works at WD who 
participates on these lists so I am not sure how to get the problem 
escalated. When I tried to open cases with WD about the problem, their 
solution was (again) to replace all the HDDs, etc.  As far as I am 
concerned the WD Velociraptor is defective, at least in Linux (both 
GLFS/HLFS) versions that I used and the 9-10 RMAs as well, I think there 
needs to be more bug reports etc and tracking on this issue, otherwise, it 
will probably never be solved.  However, if you have important data, I'd 
recommend not storing it on a VR unless you have it backed up elsewhere, 
and verify the backups regularly.

Justin.
