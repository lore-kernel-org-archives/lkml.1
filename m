Return-Path: <linux-kernel-owner+w=401wt.eu-S1755381AbYC3VM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbYC3VM7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 17:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbYC3VMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 17:12:52 -0400
Received: from compunauta.com ([69.36.170.169]:47174 "EHLO compunauta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188AbYC3VMv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 17:12:51 -0400
From: Gustavo Guillermo =?iso-8859-1?q?P=E9rez?= 
	<gustavo@compunauta.com>
Organization: www.compunauta.com
To: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: tulip driver receive but not send 2.6.25-rc6-git7
Date: Sun, 30 Mar 2008 15:10:24 -0600
User-Agent: KMail/1.9.7
References: <200803281828.39948.gustavo@compunauta.com> <47ED9CB4.7010603@garzik.org>
In-Reply-To: <47ED9CB4.7010603@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803301510.24472.gustavo@compunauta.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Viernes, 28 de Marzo de 2008, escribió:
> Gustavo Guillermo Pérez wrote:
> > I'm putting all wires on the same swirch for testing.
> > eth0 is a sis embedded card (good one).
> > dealing with dhcp I see that request arrives to the board but the offers
> > never appears on client. system clean no iptables rules, just dhcpd.
> >
> > I'm gonna try with rc7-git4 and 2.6.24
>
> Please do.
>
> Also, try the 'dmfe' driver, as it was written specifically for these
> chips.
So, with dmfe driver went fine [rc7-g4] same with tulip nothing
uLinuxIV ~ # rmmod tulip
uLinuxIV ~ # modprobe dmfe
uLinuxIV ~ # dmesg | tail -n 3
dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
eth1: Davicom DM9102 at pci0000:00:09.0, 00:60:6e:70:1f:b1, irq 17.
eth2: Davicom DM9102 at pci0000:00:0a.0, 00:60:6e:70:1f:d5, irq 18.
uLinuxIV ~ # ifconfig eth0 192.168.1.1
uLinuxIV ~ # ping -c 1 192.168.1.2
PING 192.168.1.2 (192.168.1.2) 56(84) bytes of data.
64 bytes from 192.168.1.2: icmp_seq=1 ttl=64 time=0.176 ms

--- 192.168.1.2 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.176/0.176/0.176/0.000 ms
uLinuxIV ~ # ifconfig eth0 down
uLinuxIV ~ # ifconfig eth1 192.168.1.1
uLinuxIV ~ # ping -c 1 192.168.1.2
PING 192.168.1.2 (192.168.1.2) 56(84) bytes of data.
64 bytes from 192.168.1.2: icmp_seq=1 ttl=64 time=0.176 ms

--- 192.168.1.2 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.176/0.176/0.176/0.000 ms
uLinuxIV ~ # ifconfig eth1 down
uLinuxIV ~ # ifconfig eth2 192.168.1.1
uLinuxIV ~ # ping -c 1 192.168.1.2
PING 192.168.1.2 (192.168.1.2) 56(84) bytes of data.
64 bytes from 192.168.1.2: icmp_seq=1 ttl=64 time=0.176 ms

--- 192.168.1.2 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.176/0.176/0.176/0.000 ms


I'll gonna try now with 2.6.24.4 

> 	Jeff
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Gustavo Guillermo Pérez
Compunauta uLinux
www.compunauta.com
