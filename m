Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbYH1SH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbYH1SH0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 14:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754544AbYH1SHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 14:07:14 -0400
Received: from duster.selinc.com ([12.156.93.38]:49171 "EHLO duster.selinc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503AbYH1SHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 14:07:13 -0400
X-Greylist: delayed 1116 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Aug 2008 14:07:12 EDT
X-ASG-Debug-ID: 1219945713-2c03004e0000-xx1T2L
X-Barracuda-URL: http://spamfilter.ad.selinc.com:80/cgi-bin/mark.cgi
X-ASG-Whitelist: Client
In-Reply-To: <48B5CC98.9000904@gmx.net>
To: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Cc: Bruce Leonard <brucle@earthlink.net>, Jamie Lokier <jamie@shareable.org>,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       linux-mtd-bounces@lists.infradead.org
X-ASG-Orig-Subj: Re: [PATCH 2/2] Add support for > 2GiB MTD devices
Subject: Re: [PATCH 2/2] Add support for > 2GiB MTD devices
MIME-Version: 1.0
X-KeepSent: F4CB8B0C:41A8912A-882574B3:00613BB8;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 7.0.3 September 26, 2007
Message-ID: <OFF4CB8B0C.41A8912A-ON882574B3.00613BB8-882574B3.0061CE65@selinc.com>
From: Bruce_Leonard@selinc.com
Date: Thu, 28 Aug 2008 10:48:32 -0700
X-MIMETrack: Serialize by Router on Higinbotham/SEL(Release 8.0.1|February 07, 2008) at
 08/28/2008 10:48:33 AM,
	Serialize complete at 08/28/2008 10:48:33 AM
Content-Type: text/plain; charset="US-ASCII"
X-Barracuda-Connect: higinbotham.ad.selinc.com[10.100.0.53]
X-Barracuda-Start-Time: 1219945713
X-Barracuda-Virus-Scanned: by Barracuda Spam Firewall at selinc.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-mtd-bounces@lists.infradead.org wrote on 08/27/2008 02:52:24 PM:

> On 27.08.2008 20:51, Jamie Lokier wrote:
> > Bruce_Leonard@selinc.com wrote:
> > 
> >> I'm still reluctant to change size to a 64-bit value.  There's a 
vague 
> >> recolection of early conversations on the list that there would be 
little 
> >> acceptance for that.  And that probably has to do with the ongoing 
> >> conversation about ABI changes.  What I could do to eliminate the 
> >> multiplication is introduce the same concept that the NAND layer 
uses, 
> >> shift values.  After all, erasesize should always be a power of 2, 
making 
> >> that a power of 2 multiplication which can be done via shifts.  By 
> >> changing erasesize to erasesize_shift, I'd get something like this:
> >>
> >> return a->num_eraseblocks == 0 ? a->size : a->num_eraseblocks << 
> >> a->erasesize_shift
> >>
> >> How would that suit you?
> >> 
> >
> > Are you sure it's always going to be a power of 2?
> >
> > What if someone targets a board with 3 chips wired to shared address
> > and parallel data buses?
> >
> > Or if someone makes a weird chip?  Or if you can format it in
> > different ways according to desired ECC level (like you can with CDs)?
> > 
> 
> IIRC I saw a datasheet for such a chip (selectable erasesize with
> non-power-of-2 default) some weeks ago and it had entered production a
> few months ago. The erasesize was alwas a multiple of 16, though. Sorry
> for not remembering more details.
> 
> Regards,
> Carl-Daniel
> 

Well in that case I don't see that there's much option other than a 
multiplication.  If there were an odd number of eraseblocks (i.e., 3 
chips) you could still do the shifting operations.  But if someone has 
come up with a flash part that has a non-power of two sector/erasesize, 
then there's no way to do it by shift.  I supose I could just change 
erasesize to size64, make it a 64-bit type and do this:

return a->num_eraseblocks == 0 ? a->size : a->size64

Doesn't seem quite as elegant, but it is simpler.  What ever I do, I can't 
change the meaning or type of size.  That's an kernel <=> userspace ABI 
change, and we know what happens when I try to do that ;).

Bruce

------------------------------------------------

This e-mail may contain SEL confidential information.  The opinions
expressed are not necessarily those of SEL.  Any unauthorized disclosure,
distribution or other use is prohibited.  If you received this e-mail in
error, please notify the sender, permanently delete it, and destroy any
printout.

Thank you.

------------------------------------------------
