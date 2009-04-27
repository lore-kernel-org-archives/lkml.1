Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbZD0ABT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbZD0ABT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 20:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbZD0ABE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 20:01:04 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:59111 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbZD0ABB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 20:01:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=By0In+LH5pBDsSVcvYgTb99JBOmuMmbaVmO0hNhfYAx8ShJw7yBjO7Q1YUB1N0LTAm
         UN2TB11gqqUTe8KgN9L9wqC/KBNsb6Ctl1GugsKm2PTMsfXS5X+YpRk3ghpHHwluX6co
         sAei39FcT0eIIBYKRJ4N3cKa/M81Ayhl/VEWA=
Message-ID: <49F4F5B1.4020201@gmail.com>
Date: Mon, 27 Apr 2009 02:00:49 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: "linux.kernel" <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
Subject: 2.6.30-rc3: iwlagn probe timeouts (regression)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In earlier 2.6.30 (rc1 and 2) kernel tests I suffered the "beacon loss,
sending probe request" problem, during which my connection would
intermittently fail and reconnect. With the latest git kernel which
seems to include a patch (ad935687dbe7307f5abd9e3f610a965a287324a9) for
at least some of this, my card (Intel 5300AGN REV=0x24) completely fails
to associate and I get:

Apr 27 01:32:36 linux-7vph kernel: Registered led device: iwl-phy0::radio
Apr 27 01:32:36 linux-7vph kernel: Registered led device: iwl-phy0::assoc
Apr 27 01:32:36 linux-7vph kernel: Registered led device: iwl-phy0::RX
Apr 27 01:32:36 linux-7vph kernel: Registered led device: iwl-phy0::TX
Apr 27 01:32:36 linux-7vph kernel: ADDRCONF(NETDEV_UP): wlan0: link is
not ready
Apr 27 01:32:40 linux-7vph sudo:   niella : TTY=pts/2 ; PWD=/home/niella
; USER=root ; COMMAND=/usr/bin/tail -f /var/log/messages
Apr 27 01:33:16 linux-7vph kernel: wlan0: direct probe to AP
00:1d:92:1d:1e:8e try 1
Apr 27 01:33:16 linux-7vph kernel: wlan0: direct probe to AP
00:1d:92:1d:1e:8e try 2
Apr 27 01:33:16 linux-7vph kernel: wlan0: direct probe to AP
00:1d:92:1d:1e:8e try 3
Apr 27 01:33:16 linux-7vph kernel: wlan0: direct probe to AP
00:1d:92:1d:1e:8e timed out
Apr 27 01:33:29 linux-7vph kernel: wlan0: direct probe to AP
00:1d:92:1d:1e:8e try 1
Apr 27 01:33:29 linux-7vph kernel: wlan0: direct probe to AP
00:1d:92:1d:1e:8e try 1
Apr 27 01:33:29 linux-7vph kernel: wlan0: direct probe to AP
00:1d:92:1d:1e:8e try 2
Apr 27 01:33:29 linux-7vph kernel: wlan0: direct probe to AP
00:1d:92:1d:1e:8e try 3
Apr 27 01:33:29 linux-7vph kernel: wlan0: direct probe to AP
00:1d:92:1d:1e:8e timed out
Apr 27 01:33:42 linux-7vph kernel: wlan0: direct probe to AP
00:1d:92:1d:1e:8e try 1
Apr 27 01:33:42 linux-7vph kernel: wlan0: direct probe to AP
00:1d:92:1d:1e:8e try 1
Apr 27 01:33:42 linux-7vph kernel: wlan0: direct probe to AP
00:1d:92:1d:1e:8e try 2
Apr 27 01:33:42 linux-7vph kernel: wlan0: direct probe to AP
00:1d:92:1d:1e:8e try 3
Apr 27 01:33:43 linux-7vph kernel: wlan0: direct probe to AP
00:1d:92:1d:1e:8e timed out

I do not have any similar problems with 2.6.29 or 2.6.28 at the exact
same physical location.

I can try to bisect in a day or two if need be.

Regards,
Niel
