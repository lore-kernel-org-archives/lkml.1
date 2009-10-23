Return-Path: <linux-kernel-owner+w=401wt.eu-S1752892AbZJWUBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbZJWUBG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 16:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbZJWUBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 16:01:05 -0400
Received: from smtp-out113.alice.it ([85.37.17.113]:2843 "EHLO
	smtp-out113.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbZJWUBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 16:01:05 -0400
Message-ID: <4AE20B6F.4060606@ntd.homelinux.org>
Date: Fri, 23 Oct 2009 22:00:47 +0200
From: NiTRo <nitroml@ntd.homelinux.org>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: cve@mitre.org
Subject: SECURITY PROBLEM: filesystem permiossion bypass on FD already opened
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Oct 2009 20:00:47.0652 (UTC) FILETIME=[8342BE40:01CA541B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi to all,
    Sorry for my bad english.
    Just discovered this security problem on my Suse 11 (Linux xxxx
2.6.25.18-0.2-pae #1 SMP 2008-10-21 16:30:26 +0200 i686 i686 i386
GNU/Linux) and my Slackware 10.1.0 (Linux xxxx 2.4.29-ow1 #1 Wed Feb 2
00:05:42 CET 2005 i586 unknown unknown GNU/Linux) with OpenWall patch.
If a FD is opened on a allowed file and then the permission is changed
the file is still redeable starting from the already read position to
the EOF.

This is the scenario:

<root> creates a file /tmp/aaaa with 666 permission an with the "test"
string inside it
        xxx:/tmp # echo test > /tmp/aaaa
        xxx:/tmp # chmod 666 /tmp/aaaa
<sb> opens this file hooking it in a shell as FD number 3
        sb@xxx:~> bash 3< /tmp/aaaa
<sb> read and prints it
        sb@xxx:~> read a <&3
        sb@xxx:~> echo $a
        test
        sb@xxx:~>
...anythig as expected...
<root> changes the permissions on file to 600 and changes its content
into "test o.o I cannot believe it..."
        xxx:/tmp # chmod 600 /tmp/aaaa
        xxx:/tmp # echo "test o.o I cannot believe it..." > /tmp/aaaa
<sb> continue to try reading the file
        sb@xxx:~> read a <&3
        sb@xxx:~> echo $a
        o.o I cannot believe it...
        sb@test:~>
... and this is not expected...

Writing control seems to be working fine... "bash: echo: write error:
Bad file descriptor"

Hope this can help...

Thanks to all
Alessandro Soraruf
