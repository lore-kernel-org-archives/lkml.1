Return-Path: <linux-kernel-owner+w=401wt.eu-S965142AbXBSWpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965142AbXBSWpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 17:45:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965143AbXBSWpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 17:45:34 -0500
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:47505 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965142AbXBSWpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 17:45:34 -0500
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <5414CB1F-F665-4B8B-8C46-8805F1CC7774@kernel.crashing.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: serial 8250, sysrq, and break
Date: Mon, 19 Feb 2007 16:42:41 -0600
To: rmk+serial@arm.linux.org.uk
X-Mailer: Apple Mail (2.752.2)
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to figure out if an issue I'm having with sysrq (more  
likely with receiving a BREAK) is a HW issue or software.

If I have a lot of spew in the kernel (like a printk in receive_chars 
()) sysrq seems to work properly, in that the character sent after  
the break is properly received.  However, if I don't have any spew  
the character after the break than I get the wrong character:

[   22.607920] SysRq : in __sysrq_get_key_op key:255
[   34.856712] SysRq : in __sysrq_get_key_op key:255
[   44.823519] SysRq : in __sysrq_get_key_op key:252
[   51.306161] SysRq : in __sysrq_get_key_op key:240
[   60.947047] SysRq : in __sysrq_get_key_op key:252
[   65.942674] SysRq : in __sysrq_get_key_op key:128
[  102.251461] SysRq : in __sysrq_get_key_op key:254

It seems like hw is treating part of the break as a valid received  
character.  But, wanted to see if there were any ideas before I  
consider this a HW issue.

- k
