Return-Path: <linux-kernel-owner+w=401wt.eu-S932694AbXAaDvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694AbXAaDvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 22:51:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932783AbXAaDvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 22:51:39 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:53426 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932694AbXAaDvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 22:51:37 -0500
In-Reply-To: <200701301337.48435.tuxiko@free.fr>
To: Eric Lacombe <tuxiko@free.fr>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.19.2: Freeze with CIFS mount
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0 HF144 February 01, 2006
Message-ID: <OFC7B98576.0C582E30-ON87257274.0014583D-86257274.00153815@us.ibm.com>
From: Steven French <sfrench@us.ibm.com>
Date: Tue, 30 Jan 2007 21:51:35 -0600
X-MIMETrack: Serialize by Router on D03NM123/03/M/IBM(Release 7.0.2HF32 | October 17, 2006) at
 01/30/2007 20:51:35,
	Serialize complete at 01/30/2007 20:51:35
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The cifs entries in the dmesg log do not indicate any errors, much less 
show the cause of this
particular problem.

The repeated entry:
        CIFS VFS: Send error in SETFSUnixInfo = -5
is expected on connection to certain older versions of Samba servers (or 
other servers that 
only partially support the current CIFS Unix Extensions).  It is harmless.

It would be useful to know (e.g. if it is possible to trace the network 
traffic on the server side on your NAS box) whether
any network traffic from the client is being sent when (or just before) 
the hang occurs.

It is possible that the restarting of the NAS box allows reconnection of 
the smb/cifs session to proceed
which presumably could be hanging or looping in the network adapter 
driver, the tcp stack or cifs on
the client, but it is hard to tell without more information.   I don't 
know much about either of the
GigE drivers loaded on your system to determine if there is an easy way to 
tell their state.

There are various ways to analyze system hangs including (at least in some 
cases) getting a system dump which
can be used to isolate the failing location - hopefully 



linux-kernel-owner@vger.kernel.org wrote on 01/30/2007 06:37:48 AM:

> Hello,
> 
> I report a problem that occurs on a Core2 system (x86_64 used) with a 
Linux 
> 2.6.19.2, when i use a NAS : Maxtor Shared Storage II 320Go (Linux 
2.6.12 
> inside).
> 
> In fact, this NAS can be web-configured to sleep after 30 min. Also,i 
mount a 
> partition of this device through this kind of entry inside the fstab :
> 
> ------------
> //192.168.1.60/Archive   /home/tuxico/NAS/Archive   cifs 
> noauto,users,iocharset=iso8859-1,noperm,nosetuids,noacl,sfu,
> file_mode=0600,dir_mode=0755,uid=tuxico,gid=users,
> credentials=/root/.credentials 
> 0 0
> ------------
> 
> Under those circumstances, the Core2 system which is connected to it, 
freeze 
> sometimes completely (mouse, keyboard are frozen, no connection possible 
from 
> an external system - sshd not respond).
> 
> This occurs regularly (within 3-4 days) and it seems that the problem 
results 
> from the awakening of the NAS device.
> 
> Indeed I have disable the sleep feature of the device (via its web 
control 
> panel), then i was unable to trigger the problem for at least 7 days of 
> uptime of the Core2 system.
> 
> I join the .config, the result of lspci, and the CIFS logs that have 
been 
> written to /var/log/messages (i don't know if there are relevant or not 
but 
> in the doubt...).
> 
> Thanks in advance for the help.
> 
> Best regards,
> 
>    Eric
> [attachment "lspci" deleted by Steven French/Austin/IBM] [attachment
> "dotconfig" deleted by Steven French/Austin/IBM] [attachment 
> "cifslog" deleted by Steven French/Austin/IBM] 

Steve French
Senior Software Engineer
Linux Technology Center - IBM Austin
phone: 512-838-2294
email: sfrench at-sign us dot ibm dot com

