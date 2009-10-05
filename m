Return-Path: <linux-kernel-owner+w=401wt.eu-S1751751AbZJEEzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751AbZJEEzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 00:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbZJEEzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 00:55:01 -0400
Received: from smtp120.sbc.mail.re3.yahoo.com ([66.196.96.93]:36093 "HELO
	smtp120.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750788AbZJEEzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 00:55:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=oMY2zJPB1SpBtr9Km4GWEmiX6xtQIzquM0ab6a9P9Y4kdo6FQfMB/tcE0wp4oOAwqsF/uNTQslF+ptXb1dnMCpSNW08pjCnIgZtImmeZ+zMS2AU6Ktz9sRk+bkA9ZBfT760JMoAf5+rS6PAU04Ygy1LEmmK93T6yrqsEy8GeU/Y=  ;
X-YMail-OSG: AOCFmkwVM1kgcGIM97ztQMovxmVR71O8cLFXGfyoDWjIyoj8i31BXBuX6aa_LaRMpz9xhVL0JZf2hQxKf3RXpwCsaRpOIcqj.HHdoowInXbPbd8v9VRBljzPskF7ZZ6QP1ZIBXUx05AaDgt6Zhzg_5xNLkPqMr2A5zIUPqf.bVMMt4xAMZneIVrzDPuw4Cpccf1pyRGDvujsWHZF1PAcDajFk6vp07uf0WG8z.ke1z7iisi1uzSZEdOC9pfv8DIZfBk1BDzmx09bCCS_zCFxc.ft64b8z2fqROujtHuwZVIeZJ3wGQhfc9qf_a2XkAX1fbbH64oR9OuRYWS1yqwV_VeM8d5JlG5SuAU-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4AC97C18.4060601@sbcglobal.net>
Date: Sun, 04 Oct 2009 23:54:48 -0500
From: Jayson King <jaysonk@sbcglobal.net>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: kernel@kolivas.org, LKML <linux-kernel@vger.kernel.org>
Subject: SOLVED [Was: backporting BFS to 2.6.27]
References: <4AC6638E.3020803@sbcglobal.net>
In-Reply-To: <4AC6638E.3020803@sbcglobal.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jayson King wrote:
> The kernel compiles, but it panics:
> 
> Kernel alive
> Kernel really alive
> PANIC: early exception 0e rip 10:ffffffff810ad10b error 0 cr2 18.
> 
> There's no stack trace but that address is in __kmalloc.

I enabled earlyprintk=vga in boot options and got a stack trace, which 
pointed to a kmalloc call in sched_init. It turns out that this is a 
no-no in 2.6.27 as page_alloc is not set up. Replacing the call with 
alloc_bootmem instead allows the kernel to boot.

I will wrap up a new patch and post it in a bit.

Jayson

