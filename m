Return-Path: <linux-kernel-owner+w=401wt.eu-S967598AbXG3Ua0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967598AbXG3Ua0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 16:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965885AbXG3UaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 16:30:12 -0400
Received: from web52009.mail.re2.yahoo.com ([206.190.48.58]:42408 "HELO
	web52009.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965329AbXG3UaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 16:30:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=bBnr9cv9qI+i0g861+ZJxDI4j333PDhPpD8284jmJxlEA/QhXvJrRmIk4ZTvxKeJPqWPOGO8mB/01aSgPspS6jVlD/fSplwDT03lBcSPeRHiW1nby2q2VgMpfUuTw2crsdFOdCqPckrtZUmpW+sngBYIgSOkCPFqA0RK+GeMpng=;
X-YMail-OSG: ICHJUrAVM1nMXN8G5P_J5dKdnRmd7IsQp3BYVB5myfKv4Y630ySCAq6HqpFR8zH5uASWuYzE3ndTGAIuPRMVUiaT9Ttfubl4ygs1gB5bRioMRhn0hSeJOOpoiBRHpw--
Date: Mon, 30 Jul 2007 13:30:10 -0700 (PDT)
From: "Hendrik ." <chasake@yahoo.com>
Subject: Re: Reading a bad sector does not report failure as 'read error' but hangs PC with 'Machine Check Exception'
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <324190.80672.qm@web52009.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After even more tests I found out the following:

- Running 'dd_rescue /dev/sda1 /dev/zero' on the
on-board Silicon Image Inc. SiI 3114 controller
handles the bad sector just fine and does not give a
MCE. This is on the same motherboard that does give
the MCE error on the Nvidia port.

The following SATA controllers are in that machine:
* IDE interface: nVidia Corporation CK804 Serial ATA
Controller (rev f3)
* RAID bus controller: Silicon Image, Inc. SiI 3114
[SATALink/SATARaid] Serial ATA Controller (rev 02)

- Running the dd_rescue command om another PC with a
different type of motherboard (M2NPV-VM) also with a
Nvidia Nforce 4 (altough different) chipset work fine
and reports the bad sector like the SiL 3114
controller on the other PC.

This PC has the following lspci listing for SATA
controller:
* IDE interface: nVidia Corporation MCP51 Serial ATA
Controller (rev a1)

So I think there is a problem with this specific CK804
ATA controller causing the MCE... Any clues?



       
____________________________________________________________________________________
Be a better Heartthrob. Get better relationship answers from someone who knows. Yahoo! Answers - Check it out. 
http://answers.yahoo.com/dir/?link=list&sid=396545433
