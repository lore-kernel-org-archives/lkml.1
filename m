Return-Path: <linux-kernel-owner+w=401wt.eu-S1760238AbYCCAea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760238AbYCCAea (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 19:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755574AbYCCAeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 19:34:21 -0500
Received: from aun.it.uu.se ([130.238.12.36]:36595 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755363AbYCCAeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 19:34:21 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18379.18297.838050.536473@harpo.it.uu.se>
Date: Mon, 3 Mar 2008 01:34:01 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, htejun@gmail.com,
       jens.axboe@oracle.com
Subject: Re: [BUG] 2.6.25-rc2-git3 broke cdrecord
In-Reply-To: <20080302233415.GA6258@Pilar>
References: <200803022053.m22KrP2Y023591@harpo.it.uu.se>
	<20080302233415.GA6258@Pilar>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carlos R. Mafra writes:
 > 
 > On Sun  2.Mar'08 at 21:53:25 +0100, Mikael Pettersson wrote:
 > > On my main workstation (Intel P965 chipset, ICH8 SATA driven by ahci,
 > > Samsung/Toshiba SH-203P SATA DVD writer, FC5 user-space), cdrecord
 > > stopped working on the 2.6.25-rc3 kernel, with the complaint:
 > > 
 > > Warning: controller returns zero sized CD capabilities page.
 > > Warning: controller returns wrong page 0 for CD capabilities page (2A).
 > > 
 > > There's nothing in dmesg to suggest that the kernel has experienced
 > > some problem.
 > > 
 > > 2.6.25-rc2-git2 was the last working kernel, 2.6.25-rc2-git3 up to
 > > today's 2.6.25-rc3-git3 are all non-working.
 > > 
 > > I've narrowed the cause down to these two commits in 2.6.25-rc2-git3:
 > > 
 > > 40b01b9bbdf51ae543a04744283bf2d56c4a6afa
 > > block: update bio according to DMA alignment padding
 > > 
 > > 6b00769fe1502b4ad97bb327ef7ac971b208bfb5
 > > block: add request->raw_data_len
 > > 
 > > Four or so subsequent commits depend on the second of these, so it's
 > > easier to test them by applying them to -git2 than to revert them.
 > > 
 > > Also, these two need to be treated as a unit. With only the first
 > > applied, I get a massive delay as init tries to start udev, and then
 > > if I try cdrecord it hangs in an unkillable state.
 > > 
 > > I've put some information in
 > > <http://user.it.uu.se/~mikpe/linux/bug-2.6.25-rc3-cdrecord/>:
 > > - the kernel's .config
 > > - cdrecord -VV dev=/dev/scd0 blank=fast output for 2.6.25-rc2-git2 and -git3
 > > - strace -v logs for the above cdrecord runs
 > 
 > I will try to help by pointing you to the patch here: 
 > http://lkml.org/lkml/2008/2/28/76
 > 
 > It seems your problem is similar to the one Mike Galbraith reported.

That patch does seem to fix the problem. Thanks.
