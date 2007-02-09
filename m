Return-Path: <linux-kernel-owner+w=401wt.eu-S1945960AbXBIA6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945960AbXBIA6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 19:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945965AbXBIA6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 19:58:18 -0500
Received: from rwcrmhc13.comcast.net ([216.148.227.153]:64446 "EHLO
	rwcrmhc13.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945960AbXBIA6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 19:58:17 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Feb 2007 19:58:17 EST
Message-ID: <45CBC5F0.7080907@ubiqx.mn.org>
Date: Thu, 08 Feb 2007 18:53:04 -0600
From: "Christopher R. Hertel" <crh@ubiqx.mn.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Steve French <smfrench@gmail.com>, linux-cifs-client@lists.samba.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-cifs-client] Re: SMB support still missing?
References: <Pine.LNX.4.61.0702090101490.24888@yvahk01.tjqt.qr>	<45CBC072.90102@ubiqx.mn.org> <Pine.LNX.4.61.0702090130440.8587@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0702090130440.8587@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Feb 8 2007 18:29, Christopher R. Hertel wrote:
>> Jan Engelhardt wrote:
>>
>> It does seem to me that it is some sort of name resolution issue, but it may
>> have more to do with the multi-homed nature of your setup.
>>
>> Did you try:
>>
>>  mount.cifs //CL0/c /mnt
> 
> Yes, that one _fails_ with "mount error 112 = Host is down" (though tcpdump
> _does_ show that cifs connects to port 139 and then disconnects using FIN)

It would be interesting to see that capture.

- The client is clearly finding the server (via NBT lookup or DNS
  lookup--doesn't matter, it's being found).

- The client is creating the TCP connection.

- The server (W9x) is closing the connection.  Why?

  + The most likely reason is 0x82: Called Name Not Present

That's my guess, anyway.  My bet is that W9x is being picky about the case
of the CALLED NAME.

It would not surprise me that the NBT name resolution code *does* convert
the case as part of the NBT encoding (that weird string that reads
EDEMDACACACACACACACACACACACACACA).  It would also not surprise me if the NBT
Session Request code *doesn't* convert the case.  The Session Request uses
the un-encoded string (in this case, "cl0").

The Windows 9x implementation of the NBT layer tends to be much more
"correct" than the NT family and its descendants.  As a result, W9x is
pickier about things like exact matches to the CALLED NAME.

That's all a guess, mind you, but it's something more to go on.

Again, the capture would hold the answer.

Chris -)-----

--
"Implementing CIFS - the Common Internet FileSystem" ISBN: 013047116X
Samba Team -- http://www.samba.org/     -)-----   Christopher R. Hertel
jCIFS Team -- http://jcifs.samba.org/   -)-----   ubiqx development, uninq.
ubiqx Team -- http://www.ubiqx.org/     -)-----   crh@ubiqx.mn.org
OnLineBook -- http://ubiqx.org/cifs/    -)-----   crh@ubiqx.org
