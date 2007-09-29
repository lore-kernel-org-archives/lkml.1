Return-Path: <linux-kernel-owner+w=401wt.eu-S1757622AbXI2SiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622AbXI2SiB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 14:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756359AbXI2Shw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 14:37:52 -0400
Received: from lucidpixels.com ([75.144.35.66]:50123 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754311AbXI2Shv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 14:37:51 -0400
Date: Sat, 29 Sep 2007 14:37:50 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
cc: samba@lists.samba.org, submit@bugs.debian.org
Subject: 2.6.22/realtek bug in hardware, any kernel work-around?
In-Reply-To: <Pine.LNX.4.64.0709291349160.5726@p34.internal.lan>
Message-ID: <Pine.LNX.4.64.0709291434530.8080@p34.internal.lan>
References: <Pine.LNX.4.64.0709291349160.5726@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Package: samba
Version: 3.0.26a-1
>
> Kernel: 2.6.22
>
> samba 3.0.26a-1 performance < 900 KiB/s, but FTP = 30-90 MiB/s
>
> Let me start out by saing this is an oddball problem:
>
> SAMBA:
> LINUX -> WINDOWS = < 900 KiB/s (varies between 100 - 900 KiB/s)
> WINDOWS -> LINUX = 30-90 MiB/s (always)
>
> FTP:
> Either direction, 30-90 MiB/s (always)
>
> I do not see any nasty errors in the logs even with verbose = 5.
>
> Any ideas here? I am not using any special options.
>
> # cat /etc/samba/smb.conf
>
> [global]
>        log level = 5
>        workgroup = WORKGROUP
>        server string = %h - Pentium IV 3.4GHZ
>        security = user
>        encrypt passwords = true
>
> [user]
>  comment         = user
>  path            = /home/user
>  writable        = yes
>  valid users     = user
>  create mask     = 644
>
> --
>
> Here, FTP for pulling files from Linux.
>
> ftp> mget *
> 200 TYPE is now 8-bit binary
> 200 PORT command successful
> 150-Connecting to port 1255
> 150 715924.0 kbytes to download
> 226-File successfully transferred
> 226 13.687 seconds (measured here), 51.08 Mbytes per second
> ftp: 733106176 bytes received in 13.69Seconds 53562.23Kbytes/sec.
> 200 PORT command successful
> 150-Connecting to port 1256
> 150 716272.0 kbytes to download
> 226-File successfully transferred
> 226 13.032 seconds (measured here), 53.67 Mbytes per second
> ftp: 733462528 bytes received in 13.05Seconds 56216.95Kbytes/sec.
> 200 PORT command successful
> 150-Connecting to port 1257
> 150 713200.0 kbytes to download
> 226-File successfully transferred
> 226 12.869 seconds (measured here), 54.12 Mbytes per second
> ftp: 730316800 bytes received in 12.88Seconds 56723.63Kbytes/sec.
>
> Here, FTP for pushing files to Linux.
>
> ftp> mput 1 2 3
> 200 PORT command successful
> 150 Connecting to port 1263
> 226-File successfully transferred
> 226 12.802 seconds (measured here), 54.61 Mbytes per second
> ftp: 733106176 bytes sent in 12.80Seconds 57287.35Kbytes/sec.
> 200 PORT command successful
> 150 Connecting to port 1264
> 226-File successfully transferred
> 226 12.949 seconds (measured here), 54.02 Mbytes per second
> ftp: 733462528 bytes sent in 12.95Seconds 56624.92Kbytes/sec.
> 200 PORT command successful
> 150 Connecting to port 1265
> 226-File successfully transferred
> 226 15.400 seconds (measured here), 45.23 Mbytes per second
> ftp: 730316800 bytes sent in 15.38Seconds 47500.28Kbytes/sec.
>
> But (all I can offer is packet dumps/traces or bandwidth measurements):
>
> Incoming:                               Outgoing:
> Curr: 0.00 MByte/s                      Curr: 0.07 MByte/s
> Avg: 0.00 MByte/s                       Avg: 0.07 MByte/s
> Min: 0.00 MByte/s                       Min: 0.07 MByte/s
> Max: 0.00 MByte/s                       Max: 0.07 MByte/s
> Ttl: 1898.08 MByte                      Ttl: 2954.92 MByte
>
> LOCAL <-> REMOTE                                          TXBPS   RXBPS 
> TOTALBPS
> (IP)              PORT  PROTO  (IP)              PORT       TX      RX 
> TOTAL
> linuxbox <-> p4w.internal.lan          546k/s 4.74k/s 551k/s
> 192.168.0.1     445    TCP  192.168.0.2    1259    6.88m    106k  6.99m
>
> Why do I get such poor performance when trying to retrieve a file off the 
> Linux box?  This is a very strange problem.
>
> Linux:
>
> $ netstat -i
> Kernel Interface table
> Iface   MTU Met   RX-OK RX-ERR RX-DRP RX-OVR    TX-OK TX-ERR TX-DRP TX-OVR 
> Flg
> eth0   1500 0  14049682      0      0      0 11354070      0      0      0 
> BMRU
> lo    16436 0     45335      0      0      0    45335      0      0      0 
> LRU
>
> Windows:
>
> netstat -s
>
> IPv4 Statistics
>
>  Packets Received                   = 5053597
>  Received Header Errors             = 0
>  Received Address Errors            = 19
>  Datagrams Forwarded                = 0
>  Unknown Protocols Received         = 0
>  Received Packets Discarded         = 2
>  Received Packets Delivered         = 5053595
>  Output Requests                    = 3655144
>  Routing Discards                   = 0
>  Discarded Output Packets           = 0
>  Output Packet No Route             = 0
>  Reassembly Required                = 0
>  Reassembly Successful              = 0
>  Reassembly Failures                = 0
>  Datagrams Successfully Fragmented  = 0
>  Datagrams Failing Fragmentation    = 3
>  Fragments Created                  = 0
>
> ICMPv4 Statistics
>
>                            Received    Sent
>  Messages                  47          24
>  Errors                    0           0
>  Destination Unreachable   25          2
>  Time Exceeded             0           0
>  Parameter Problems        0           0
>  Source Quenches           0           0
>  Redirects                 0           0
>  Echos                     0           22
>  Echo Replies              22          0
>  Timestamps                0           0
>  Timestamp Replies         0           0
>  Address Masks             0           0
>  Address Mask Replies      0           0
>
> TCP Statistics for IPv4
>
>  Active Opens                        = 204
>  Passive Opens                       = 14
>  Failed Connection Attempts          = 16
>  Reset Connections                   = 59
>  Current Connections                 = 3
>  Segments Received                   = 5051709
>  Segments Sent                       = 3654327
>  Segments Retransmitted              = 76
>
> UDP Statistics for IPv4
>
>  Datagrams Received    = 1826
>  No Ports              = 58
>  Receive Errors        = 3
>  Datagrams Sent        = 716
>
>
> Justin.
>
> -- 
> To unsubscribe from this list go to the following URL and read the
> instructions:  https://lists.samba.org/mailman/listinfo/samba
>

Looks like it is hardware related after all:

http://forums.gentoo.org/viewtopic-p-2820556.html
http://ubuntuforums.org/showthread.php?t=531505
http://www.fedoraforum.org/forum/showthread.php?p=452451

One poster wrote "I got similar problems:"

http://forums.gentoo.org/viewtopic-t-570392.html
http://forums.gentoo.org/viewtopic-t-389449-postdays-0-postorder-asc-start-25.html?sid=4251f92bbc6db32fd200c4ea0ea9c9be

I found out that poor smb performance is related to a broken udp-perfomance of the 8169 NIC in outgoing udp.
But, only in Gb Mode of the 8169 NIC, with 100Mbps it is ok.

http://forums.gentoo.org/viewtopic-t-570392.html

I have:
03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 01)
04:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 01)

That must be the issue, time to buy an Intel PCI-e NIC if I want better 
performance with samba in Linux.

I do have another one of these motherboards (ABIT AW9D-MAX) running XP and 
it does not seem to suffer from this problem, I guess the [proprietary? 
Realtek driver does not suffer from this bug]?

Justin.


