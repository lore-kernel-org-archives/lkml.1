Return-Path: <linux-kernel-owner+w=401wt.eu-S1161064AbXBIAPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161064AbXBIAPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 19:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965730AbXBIAPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 19:15:31 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:33135 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965596AbXBIAPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 19:15:30 -0500
Date: Fri, 9 Feb 2007 01:14:38 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: linux-cifs-client@lists.samba.org
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steve French <smfrench@gmail.com>
Subject: [linux-cifs-client] Re: SMB support still missing?
Message-ID: <Pine.LNX.4.61.0702090101490.24888@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


I tried the various suggestions from the last mails, but nothing of 
that worked. --verbose did not return anything useful. It's the kernel 
module that returns -EHOSTDOWN.

...

Eventually I found out that this one works:

	mount.cifs //cl0/c /mnt -o servernetbiosname=CL0

So what did I change? Casing. Note that "CL0" is entirely uppercase. 
Although strange, it actually coincides with how LANMAN works. 
Everything is uppercased in lanman, hostnames, usernames, heck, even 
plaintext passwords (samba-smbd has a good time trying a ton of 
combinations in such setups).

No other options like sec=none or thelike were needed. Login as 
anonymous worked directly.


Please consider updating the cifs kernel module to account for the LM 
oddity of uppercasing things. (Then, smbfs can finally be ripped out I 
hope.)



Jan
-- 
ft: http://freshmeat.net/p/chaostables/
