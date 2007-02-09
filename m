Return-Path: <linux-kernel-owner+w=401wt.eu-S965741AbXBIA3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965741AbXBIA3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 19:29:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965746AbXBIA3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 19:29:52 -0500
Received: from alnrmhc11.comcast.net ([204.127.225.91]:48767 "EHLO
	alnrmhc11.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965741AbXBIA3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 19:29:51 -0500
Message-ID: <45CBC072.90102@ubiqx.mn.org>
Date: Thu, 08 Feb 2007 18:29:38 -0600
From: "Christopher R. Hertel" <crh@ubiqx.mn.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: linux-cifs-client@lists.samba.org, Steve French <smfrench@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-cifs-client] Re: SMB support still missing?
References: <Pine.LNX.4.61.0702090101490.24888@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0702090101490.24888@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> Hi,
> 
> 
> I tried the various suggestions from the last mails, but nothing of 
> that worked. --verbose did not return anything useful. It's the kernel 
> module that returns -EHOSTDOWN.
> 
> ...
> 
> Eventually I found out that this one works:
> 
> 	mount.cifs //cl0/c /mnt -o servernetbiosname=CL0
> 
> So what did I change? Casing. Note that "CL0" is entirely uppercase. 
> Although strange, it actually coincides with how LANMAN works. 
> Everything is uppercased in lanman, hostnames, usernames, heck, even 
> plaintext passwords (samba-smbd has a good time trying a ton of 
> combinations in such setups).
> 
> No other options like sec=none or thelike were needed. Login as 
> anonymous worked directly.
> 
> 
> Please consider updating the cifs kernel module to account for the LM 
> oddity of uppercasing things. (Then, smbfs can finally be ripped out I 
> hope.)

...assuming that's really the problem.

It does seem to me that it is some sort of name resolution issue, but it may
have more to do with the multi-homed nature of your setup.

Did you try:

  mount.cifs //CL0/c /mnt

?

If mount.cifs is not converting the case, that should fix the problem.

Curious to know...

Chris -)-----


-- 
"Implementing CIFS - the Common Internet FileSystem" ISBN: 013047116X
Samba Team -- http://www.samba.org/     -)-----   Christopher R. Hertel
jCIFS Team -- http://jcifs.samba.org/   -)-----   ubiqx development, uninq.
ubiqx Team -- http://www.ubiqx.org/     -)-----   crh@ubiqx.mn.org
OnLineBook -- http://ubiqx.org/cifs/    -)-----   crh@ubiqx.org
