Return-Path: <linux-kernel-owner+w=401wt.eu-S1756216AbZCAFr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbZCAFr6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 00:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbZCAFrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 00:47:51 -0500
Received: from c60.cesmail.net ([216.154.195.49]:23219 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280AbZCAFru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 00:47:50 -0500
Subject: Re: [Orinoco-users] linux-firmware binary corruption with gitweb
From: Pavel Roskin <proski@gnu.org>
To: Dave <kilroyd@googlemail.com>
Cc: linux-kernel@vger.kernel.org, orinoco-users@lists.sourceforge.net,
       dwmw2@infradead.org
In-Reply-To: <49A98F6A.50702@gmail.com>
References: <49A98F6A.50702@gmail.com>
Content-Type: text/plain
Date: Sun, 01 Mar 2009 00:47:47 -0500
Message-Id: <1235886467.3195.15.camel@mj>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-02-28 at 19:24 +0000, Dave wrote:
> I'm aware of at least a couple users of orinoco who have picked up
> corrupt firmware# from the linux-firmware tree*.
> 
> I've verified that the firmware in the repository itself is correct.
> 
> It appears that downloading the file using the blob/raw links from
> gitweb causes the corruption (0xc3 everywhere). At least it does with
> firefox.

I can confirm the problem with Firefox 3.0.6.  But it's not "0xc3
everywhere".  The corrupted file is a result of recoding from iso-8859-1
to utf-8.  The correct agere_sta_fw.bin is 65046 bytes long.  The
corrupted agere_sta_fw.bin is 89729 bytes long.

There is a way to recode the original binary with GNU recode:
recode utf8..iso8859-1 agere_sta_fw.bin

wget 1.11.4 also gets a corrupted file 89729 bytes long.

$ wget "http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=blob;f=agere_sta_fw.bin;h=bae000f5a7162f5a5b052a2f5b78016e95f825c5;hb=d4cfa9f14c55e9d62f053a542fac21744f22546b"
--2009-03-01 00:42:38--  http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=blob;f=agere_sta_fw.bin;h=bae000f5a7162f5a5b052a2f5b78016e95f825c5;hb=d4cfa9f14c55e9d62f053a542fac21744f22546b
Resolving git.kernel.org... 204.152.191.40, 149.20.20.136
Connecting to git.kernel.org|204.152.191.40|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: unspecified [application/octet-stream]
Saving to: `index.html?p=linux%2Fkernel%2Fgit%2Fdwmw2%2Flinux-firmware.git;a=blob;f=agere_sta_fw.bin;h=bae000f5a7162f5a5b052a2f5b78016e95f825c5;hb=d4cfa9f14c55e9d62f053a542fac21744f22546b'

    [  <=>                                                  ] 89,729       237K/s   in 0.4s    

2009-03-01 00:42:39 (237 KB/s) - `index.html?p=linux%2Fkernel%2Fgit%2Fdwmw2%2Flinux-firmware.git;a=blob;f=agere_sta_fw.bin;h=bae000f5a7162f5a5b052a2f5b78016e95f825c5;hb=d4cfa9f14c55e9d62f053a542fac21744f22546b' saved [89729]

curl 7.18.2 also get the corrupted file:

  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 89729    0 89729    0     0   111k      0 --:--:-- --:--:-- --:--:--  191k

My strong impression is that the recoding takes place on the server.  I
think the bug should be reported to the gitweb maintainers unless it a
local breakage on the kernel.org site.

-- 
Regards,
Pavel Roskin
