Return-Path: <linux-kernel-owner+w=401wt.eu-S938924AbXFHRe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938924AbXFHRe7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 13:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030694AbXFHReP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 13:34:15 -0400
Received: from relais.videotron.ca ([24.201.245.36]:33937 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760218AbXFHReO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 13:34:14 -0400
Date: Fri, 08 Jun 2007 13:34:16 -0400
From: Mike Schmidt <mike@intello.com>
Subject: 2.6 kernel: Cannot make multiple dummy network interfaces
To: linux-kernel@vger.kernel.org
Message-id: <46699318.3060209@intello.com>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_Y8vwUUQLK9Mm3LYstNLwEw)"
X-Greylist: Sender succeeded SMTP AUTH authentication,
 not delayed by milter-greylist-3.0 (deepspace.sepia.com [205.236.40.42]); Fri,
 08 Jun 2007 13:29:31 -0400 (EDT)
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Boundary_(ID_Y8vwUUQLK9Mm3LYstNLwEw)
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT



(please cc me directly with any responses - I am not (yet) a member of 
this mailing list.

*2.6 kernel: Cannot make multiple dummy network interfaces*
------------------------------------------------------------------------
I'm trying to set up a number of dummy interfaces but FC6 (Centos4, even 
RHEL4) won't make more than 1. a modprobe -c lists two default dummy 
interfaces, dumm0 and dummy1, just as it did even back to rh8. On my 
rh8/rh9 systems, there is no problem, I can generate as many dummy n as 
I want by adding alias and options lines in modules.conf. On 
FC6/Centos/RHEL (I assume as of kernel 2.6, but I don't have any early 
FC systems running) I can only create 1 dummy. I am trying to build a 
network simulator for testing purposes - a bridge with 100+ network 
interfaces. They have to be dummy (not just an alias) because they need 
separate MAC addresses.  I have tried the same thing on Knoppix, running 
2.6.17, with the same results. Centos4 and RHEL4 use kernel 2.6.9

On FC6: (kernel 2.6.20)
 >modprobe -c | grep dummy:
alias dummy0 dummy
alias dummy1 dummy
install dummy0 /sbin/modprobe -o dummy0 --ignore-install dummy
install dummy1 /sbin/modprobe -o dummy1 --ignore-install dummy

 >ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue
link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast 
qlen 1000
link/ether 00:18:8b:e6:c3:82 brd ff:ff:ff:ff:ff:ff
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast 
qlen 1000
link/ether 00:0e:2e:b1:20:e6 brd ff:ff:ff:ff:ff:ff

 >modprobe dummy0
 >modprobe dummy1

 >ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue
link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast 
qlen 1000
link/ether 00:18:8b:e6:c3:82 brd ff:ff:ff:ff:ff:ff
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast 
qlen 1000
link/ether 00:0e:2e:b1:20:e6 brd ff:ff:ff:ff:ff:ff
4: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop
link/ether aa:96:c7:d9:40:eb brd ff:ff:ff:ff:ff:ff

This same thing give me two dummy interfaces in rh8. I have no 
difficulty making 100 or more dummy interfaces in rh8. (running 2.4.31). 
Note that I have not made any changes to the modprobe configuration 
here. Normally I would have at least 100 aliases - dummy0-dummy99.

On all 2.6 kernels I have checked, the kernel config has CONFIG_DUMMY=m. 
However, the modprobe configuration for 2.4 kernels is different (uses 
option instead of install statements in modules.conf).
Is there something going on that prevents me from loading multiple 
copies of the dummy driver? Is there anything I can do about this?

Thanks very much. There is very little information about this kind of 
thing available. I'm afraid I'm stuck between a rock and a hard place - 
I need 2.6 for some new device drivers not available in 2.4, and I need 
2.54 for my dummy net devices....

Again, I thank anyone who can help me.

Mike


--Boundary_(ID_Y8vwUUQLK9Mm3LYstNLwEw)
Content-type: text/x-vcard; charset=utf-8; name=mike.vcf
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=mike.vcf

begin:vcard
fn:Mike Schmidt
n:Schmidt;Mike
org:Intello Technologies Inc. 
adr;quoted-printable;quoted-printable:;;580 1=C3=A8re Rue;Saint-Jean-sur-Richelieu;Qu=C3=A9;J2X 3B4;Canada
email;internet:mike@intello.com
title:Vice-President
tel;work:450-358-2266 x223
tel;cell:514-835-9497
x-mozilla-html:FALSE
url:http://www.intello.com
version:2.1
end:vcard


--Boundary_(ID_Y8vwUUQLK9Mm3LYstNLwEw)--
