Return-Path: <linux-kernel-owner+w=401wt.eu-S1753826AbYKHVAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbYKHVAV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 16:00:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbYKHVAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 16:00:06 -0500
Received: from main.gmane.org ([80.91.229.2]:44074 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbYKHVAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 16:00:05 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: 2.6.28-rc3 (x86_64) on current Fedora 9 (i386)
Date: Sat, 08 Nov 2008 14:48:46 -0600
Message-ID: <4915FB2E.7020206@shaw.ca>
References: <1226157728.6060.7.camel@dhcppc0>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
In-Reply-To: <1226157728.6060.7.camel@dhcppc0>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Meyer wrote:
> Hi,
> 
> Cross compiled with gcc-4.2.4.
> 
> nm-applet seems to constantly fail to connect my wlan:
> 
> [  415.702723] rndis_wlan 1-6.3:1.0: rndis media connect
> [  415.731909] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [  415.732700] wpa_supplicant[3416]: segfault at fff40000 ip 000000004f612fd6 sp 00000000fff3c108 error 4 in libc-2.8.so[4f59c000+163000]
> [  415.749491] rndis_wlan 1-6.3:1.0: rndis media disconnect
> [  426.664267] wlan0: no IPv6 routers present
> [  431.701722] rndis_wlan 1-6.3:1.0: rndis media connect
> [  431.726008] wpa_supplicant[4055]: segfault at ffcc9000 ip 000000004f612fd6 sp 00000000ffcc6698 error 4 in libc-2.8.so[4f59c000+163000]
> [  431.740094] rndis_wlan 1-6.3:1.0: rndis media disconnect
> [  437.705723] rndis_wlan 1-6.3:1.0: rndis media connect
> [  437.735135] wpa_supplicant[4160]: segfault at ffd88000 ip 000000004f612fd6 sp 00000000ffd83b98 error 4 in libc-2.8.so[4f59c000+163000]
> [  437.754987] rndis_wlan 1-6.3:1.0: rndis media disconnect
> [  443.705723] rndis_wlan 1-6.3:1.0: rndis media connect
> [  443.735113] wpa_supplicant[4167]: segfault at fffa7000 ip 000000004f612fd6 sp 00000000fffa4978 error 4 in libc-2.8.so[4f59c000+163000]
> [  443.751981] rndis_wlan 1-6.3:1.0: rndis media disconnect
> [  459.705722] rndis_wlan 1-6.3:1.0: rndis media connect
> [  459.736240] wpa_supplicant[4173]: segfault at ffe7d000 ip 000000004f612fd6 sp 00000000ffe7a048 error 4 in libc-2.8.so[4f59c000+163000]
> [  459.750979] rndis_wlan 1-6.3:1.0: rndis media disconnect
> 
> The same kernel not cross compiled (with the supplied Fedora gcc) works correctly with the nm-applet...
> 
> Kernel or user land bug?
> 
> Also I get this strange error messages:
> [   23.767645] ioctl32(rhgb:2177): Unknown cmd fd(13) cmd(0000530b){t:'S';sz:0} arg(4eed91aa) on /dev/pts/0
> [   23.767652] ioctl32(rhgb:2177): Unknown cmd fd(13) cmd(0000530b){t:'S';sz:0} arg(4eed91af) on /dev/pts/0
> [   23.767657] ioctl32(rhgb:2177): Unknown cmd fd(13) cmd(0000530b){t:'S';sz:0} arg(4eed91b6) on /dev/pts/0
> 
> [   46.273767] ioctl32(hald-probe-stor:2750): Unknown cmd fd(4) cmd(00005320){t:'S';sz:0} arg(00000004) on /dev/sr0
> 
> [  525.336420] ioctl32(gnome-terminal:4419): Unknown cmd fd(20) cmd(0000530b){t:'S';sz:0} arg(4eed91aa) on /dev/pts/1
> [  525.336427] ioctl32(gnome-terminal:4419): Unknown cmd fd(20) cmd(0000530b){t:'S';sz:0} arg(4eed91af) on /dev/pts/1
> [  525.336432] ioctl32(gnome-terminal:4419): Unknown cmd fd(20) cmd(0000530b){t:'S';sz:0} arg(4eed91b6) on /dev/pts/1
> 
> Should I care about these messages?

Those ones are 32-bit processes doing ioctls which don't have 
compat_ioctl handling in the kernel, which would be needed for them to 
work on a 64-bit kernel.

