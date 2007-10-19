Return-Path: <linux-kernel-owner+w=401wt.eu-S936571AbXJSUZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936571AbXJSUZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 16:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761357AbXJSUZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 16:25:13 -0400
Received: from mailfe13.tele2.at ([212.247.155.135]:36669 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936497AbXJSUZK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 16:25:10 -0400
X-Greylist: delayed 3603 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Oct 2007 16:25:09 EDT
X-Cloudmark-Score: 0.000000 []
Date: Fri, 19 Oct 2007 21:29:18 +0200
To: linux-kernel@vger.kernel.org
Subject: "CIFS VFS: server not responding" with some client/server combinations
From: "Wiesner Thomas" <thomas@bau-konform.at>
Content-Type: text/plain; charset=US-ASCII;
	format=flowed	delsp=yes
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Message-ID: <op.t0glq4vz88izfi@barton2>
User-Agent: Opera Mail/9.24 (Win32)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have the following, very strange problem, which I'll try to describe now.

I've already sent this to the samba mailing list (about a week ago),
but haven't got a reply. As it might be kernel related and others
may be affected too, I decided to send it to this list, too.

A Samba server running Debian Etch with latest updates.

Different clients one running Etch with latest updates, too. The other one  
runs
either Ubuntu (don't know which version because it's not my installation,  
but quite recent) or
the older Debian 3 but with a recent vanilla kernel (either 2.6.20.1 or  
2.6.22.10).

Ok. If I mount a share from the server via cifs on either ubuntu or debian  
3.0 and do a simple
	find /sharemount
everything seems to be okay, at first. after some lines (didn't count  
them, but the amount seems
to vary from try to try and with some I mean maybe some 100) it starts to  
stuck. Sometimes for 1 second
sometimes more and quite often I get "CIFS VFS: server not responding".
together with "CIFS VFS: No response for cmd 50 mid xxx" The xxx number  
seems to vary.

The problem seems to be triggered by any operation which touches lots of  
files quickly. E.g.
by copying source file directories onto or from it or simply by find.

Copying single larger files (I generated a 100MB file with dd) don't seems  
to hurt.

Interestinly -- this is where the really strange part comes -- it seems to  
work on the client which
has debian Etch installed.

I've tried the following combinations

System                                | Success?
--------------------------------------+---------
Ubuntu with vmlinuz-2.6.20-16-generic | NO
on Client 1                           |
--------------------------------------+---------
Debian 3.0 2.6.20.1 Client 1          | NO
--------------------------------------+---------
Debian 3.0 2.6.22.10 Client 1         | NO
--------------------------------------+---------
Debian 4.0 with 2.6.18-5-486 2        | YES (Why?)
--------------------------------------+---------
Debian 3.0 (don't remember the kernel | NO
but something > 2.6.10) on Client 3   |

Well. You see, I've tried lots of combinations. I don't know what's  
different with Etch on the client,
but either the problem is very widespread across various kernel versions  
or the problem is server related.

The server side output in the logfile is the following:

[2007/10/12 21:03:41, 1] smbd/service.c:close_cnum(1150)
   192.168.0.9 (192.168.0.9) closed connection to service test
[2007/10/12 21:03:41, 1] smbd/service.c:make_connection_snum(950)
   192.168.0.9 (192.168.0.9) connect to service test initially as user  
foobar (uid=10000, gid=10000) (pid 16721)

I tried to increase the loglevel to 5 but the logfile gets flooded with  
other messages so I won't post
it here (Very long!). But I can put it onto my webspace and post an URL if  
you think it helps.

Before I forget:
Samba Version 3.0.24 on the server, according to smbd -V.
As mount helper I use mount.cifs, compiled from samba-3.0.26a.

The fstab lines used to mount the shares look like that:
//192.168.0.12/gstorage /cifs/gstorage/     cifs     
noauto,credentials=/root/gstorage.cred  0       0

Additionally, I can't reproduce the problem with a Win2k client by e.g.  
using the search utility, like on Linux.

Very interesting is the following: If I experience a hang and produce some  
other network traffic on this client
by either pinging another host or typing something into an ssh session it  
continues immediately.
(E.g. if ping sends out some packets every second, the output will  
continue once a second.)
Note that I've tried this only at one client/kernel, don't know if the  
others behave the same way

If I should report this to the kernel mailing list, let me know, but you  
might know better where it belongs.

     mfg Wiesner

PS: Please CC me, as I'm not on the list.
