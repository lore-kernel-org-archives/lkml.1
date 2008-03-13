Return-Path: <linux-kernel-owner+w=401wt.eu-S1758065AbYCMWXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065AbYCMWXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 18:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926AbYCMWXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 18:23:22 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:17352 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732AbYCMWXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 18:23:21 -0400
Message-ID: <47D9A8DF.30809@fr.ibm.com>
Date: Thu, 13 Mar 2008 23:21:19 +0100
From: Daniel Lezcano <dlezcano@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       pekkas@netcore.fi, yoshfuji@linux-ipv6.org
Subject: Re: [2.6.25-rc5-mm1] regression: cannot run Postfix sendmail command
 as non-root
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org> <47D98510.60801@imap.cc>
In-Reply-To: <47D98510.60801@imap.cc>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Schmidt wrote:
> Am 11.03.2008 09:14 schrieb Andrew Morton:
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc5/2.6.25-rc5-mm1/
> 
> I'm noticing a strange effect with this:
> 
> On my openSUSE 10.3 development machine with SUSEs default MTA
> Postfix installed, I occasionally send a pre-formatted mail by
> feeding it directly into "/usr/sbin/sendmail -t". If I try that
> while running a 2.6.25-rc5-mm1 kernel, I get:
> 
> ts@xenon:~/kernel> /usr/sbin/sendmail -t < patch-usb-reduce-syslog-clutter-v3
> postdrop: warning: can't open /proc/net/if_inet6 (Permission denied) - skipping IPv6 configuration
> postdrop: fatal: parameter inet_interfaces: no local interface found for ::1
> sendmail: warning: command "/usr/sbin/postdrop -r" exited with status 1
> sendmail: fatal: ts(1000): unable to execute /usr/sbin/postdrop -r: Success
> ts@xenon:~/kernel>
> 
> and unsurprisingly, the mail is not sent. If I do the same as root,
> everything works as usual, there is no console output from the
> sendmail command, and the mail goes out as it should. All other
> networking applications appear to be running normally.
> 
> On a 2.6.25-rc5 (non-mm) kernel I do not need to run the sendmail
> command as root. It works just as well if I run it as myself.
> 
> IPv6 is not in use on that machine. The Ethernet interface has
> just the link local IPv6 address. Possibly relevant information:
> 
> ts@xenon:~> /sbin/ifconfig -a
> eth0      Protokoll:Ethernet  Hardware Adresse 00:19:D1:03:D8:FF
>           inet Adresse:192.168.59.102  Bcast:192.168.59.255  Maske:255.255.255.0
>           inet6 Adresse: fe80::219:d1ff:fe03:d8ff/64 Gültigkeitsbereich:Verbindung
>           UP BROADCAST NOTRAILERS RUNNING MULTICAST  MTU:1500  Metric:1
>           RX packets:78 errors:0 dropped:0 overruns:0 frame:0
>           TX packets:145 errors:0 dropped:0 overruns:0 carrier:0
>           collisions:0 Sendewarteschlangenlänge:100
>           RX bytes:9547 (9.3 Kb)  TX bytes:17952 (17.5 Kb)
>           Speicher:92c00000-92c20000
> 
> lo        Protokoll:Lokale Schleife
>           inet Adresse:127.0.0.1  Maske:255.0.0.0
>           inet6 Adresse: ::1/128 Gültigkeitsbereich:Maschine
>           UP LOOPBACK RUNNING  MTU:16436  Metric:1
>           RX packets:2 errors:0 dropped:0 overruns:0 frame:0
>           TX packets:2 errors:0 dropped:0 overruns:0 carrier:0
>           collisions:0 Sendewarteschlangenlänge:0
>           RX bytes:100 (100.0 b)  TX bytes:100 (100.0 b)
> 
> ts@xenon:~/kernel> ls -l /proc/net/if_inet6
> -r--r--r-- 1 root root 0 13. Mär 19:26 /proc/net/if_inet6
> ts@xenon:~> cat /proc/net/if_inet6
> fe800000000000000219d1fffe03d8ff 02 40 20 80     eth0
> 00000000000000000000000000000001 01 80 10 80       lo
> ts@xenon:~> uname -a
> Linux xenon 2.6.25-rc5-mm1-testing #1 SMP PREEMPT Tue Mar 11 14:34:49 CET 2008 i686 i686 i386 GNU/Linux
> 
> As you see, I can cat /proc/net/if_inet6 as regular (non-root) user
> just fine, even though Postfix complains it cannot access it.
> The content of /proc/net/if_inet6 is identical if I cat it on
> kernel 2.6.25-rc5 mainline.
> 
> CCing a selection of IPv6 networking related maintainer addresses.
> If you need more information or want me to test something, let me
> know.

Hi Tilman,

Is it possible to have your config file used to compile the kernel ?
