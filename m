Return-Path: <linux-kernel-owner+w=401wt.eu-S1756963AbYCCAE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963AbYCCAE4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 19:04:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbYCCAEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 19:04:15 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56691 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751033AbYCCAEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 19:04:14 -0500
Subject: Re: [BUG] 2.6.25-rc2-git3 broke cdrecord
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-kernel@vger.kernel.org, htejun@gmail.com, jens.axboe@oracle.com,
       linux-ide <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <200803022053.m22KrP2Y023591@harpo.it.uu.se>
References: <200803022053.m22KrP2Y023591@harpo.it.uu.se>
Content-Type: text/plain
Date: Sun, 02 Mar 2008 18:04:09 -0600
Message-Id: <1204502650.3069.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[scsi and ide list cc's added]

On Sun, 2008-03-02 at 21:53 +0100, Mikael Pettersson wrote:
> On my main workstation (Intel P965 chipset, ICH8 SATA driven by ahci,
> Samsung/Toshiba SH-203P SATA DVD writer, FC5 user-space), cdrecord
> stopped working on the 2.6.25-rc3 kernel, with the complaint:
> 
> Warning: controller returns zero sized CD capabilities page.
> Warning: controller returns wrong page 0 for CD capabilities page (2A).
> 
> There's nothing in dmesg to suggest that the kernel has experienced
> some problem.
> 
> 2.6.25-rc2-git2 was the last working kernel, 2.6.25-rc2-git3 up to
> today's 2.6.25-rc3-git3 are all non-working.
> 
> I've narrowed the cause down to these two commits in 2.6.25-rc2-git3:
> 
> 40b01b9bbdf51ae543a04744283bf2d56c4a6afa
> block: update bio according to DMA alignment padding
> 
> 6b00769fe1502b4ad97bb327ef7ac971b208bfb5
> block: add request->raw_data_len
> 
> Four or so subsequent commits depend on the second of these, so it's
> easier to test them by applying them to -git2 than to revert them.
> 
> Also, these two need to be treated as a unit. With only the first
> applied, I get a massive delay as init tries to start udev, and then
> if I try cdrecord it hangs in an unkillable state.
> 
> I've put some information in
> <http://user.it.uu.se/~mikpe/linux/bug-2.6.25-rc3-cdrecord/>:
> - the kernel's .config
> - cdrecord -VV dev=/dev/scd0 blank=fast output for 2.6.25-rc2-git2 and -git3
> - strace -v logs for the above cdrecord runs

I think this is another manifestation of this problem:

http://marc.info/?t=120358360500002

The fix for which is being actively discussed here:

http://marc.info/?t=120418867400002

James


