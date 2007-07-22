Return-Path: <linux-kernel-owner+w=401wt.eu-S1765849AbXGVJy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765849AbXGVJy6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 05:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758284AbXGVJyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 05:54:49 -0400
Received: from mail.syneticon.net ([213.239.212.131]:38709 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757273AbXGVJys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 05:54:48 -0400
Message-ID: <46A3295D.8050908@wpkg.org>
Date: Sun, 22 Jul 2007 11:54:37 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Cc: jengelh@computergmbh.de
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote

> On Jul 22 2007 00:43, Lars Ellenberg wrote:

>>Think of it as RAID1 over TCP.
> 
> And what does it do better than raid1-over-NBD? (Which is already N-disk,
> and, logically, seems to support cluster filesystems)

I don't know about DRDB, but NBD doesn't handle network disconnections 
at all (well, almost).

So basically, disconnect a NBD-connected system for a while (switch, 
cabling problem, operator error etc.), and you need lots of effort, 
perhaps restarts, to get the things to a functioning state (devices 
offlined, kicked out etc.).

I wouldn't call such raid-over-NBD setup reliable.


A better question would be: what does it do better than raid1-over-iSCSI?

iSCSI can recover from disconnections very well when configured 
properly; but when a disconnection is in place, most of the system will 
just "hang/freeze" (that is, from the user perspective - the system will 
be waiting for the I/O to complete, until the systems are connected again).


A brief reading of "official DRBD FAQ" didn't give me an answer to that 
problem.


-- 
Tomasz Chmielewski
http://wpkg.org
