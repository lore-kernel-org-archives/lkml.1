Return-Path: <linux-kernel-owner+w=401wt.eu-S1752229AbZDMR5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229AbZDMR5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 13:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbZDMR5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 13:57:21 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53771 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750983AbZDMR5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 13:57:20 -0400
Message-Id: <1239645439.14336.1310277599@webmail.messagingengine.com>
X-Sasl-Enc: Qn3Zfphj6Ikgoz+RAbi2pKGUNHxYxgY99ql/DxJrJv33 1239645439
From: "Mr Blogs" <mrblogs@ssl-mail.com>
To: linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
Subject: 2.6.27 - 2.6.29 upgrade.. RAID 0 CCISS now slower
Date: Mon, 13 Apr 2009 10:57:19 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 I am using Gentoo on a HP DL380 G3. Intel Xeon (P4) 3.06ghz processors,
with a HP COMPAQ CCISS ARRAY in RAID 0 mode (hardware, linux just sees
one single drive)

hdparm on 2.6.27 shows the speed at ~ 130mbs

After performing an upgrade of the kernel

hdparm on 2.6.29 shows the speed at ~ 30mbs (30-50mbs varies)

I looked at the DMESG comparisons,
and the only difference is that 2.6.29 mentions:
"IRQF_DISABLED is not guaranteed on shared IRQs"

Now I have looked for hours to see if it was a configuration issue, but
to no avail.

 Yes the 2.6.27 kernel was self built, and it works fine. The 2.6.29 was
 built using the .config file from the 2.6.27.

I compiled this kernel on two servers, both same spec (well, one has 4GB
ram other has 2GB ram), same setup - and both responded as above.

On the one, I recompiled the kernel to just use the new version (NO
config changes). The other I re-compiled using config changes (removing
things not relevant for the machine etc) - both end up having this
problem.

I have done a "diff" compare on the configs, but there is nothing I can
find that would explain this.

I know that this "IRQF_DISABLED" warning isn't present in 2.6.27 boots,
and that the CISS driver works full speed in that one.

I thought it was originally that I changed the IO Scheduling, but as i
said, on the one machine - all i did was copy the config file and
recompile.

Do you know of anything that could be causing this?

I checked proc/interrupts on both kernel versions, and IRQ 30 is
unshared (IO-APIC-FASTEOI cciss or something like that), i am just
unsure what is causing the issue.

Thankyou.
-- 
  Mr Blogs
  mrblogs@ssl-mail.com

-- 
http://www.fastmail.fm - The way an email service should be

