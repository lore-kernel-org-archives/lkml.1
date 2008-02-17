Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbYBQC4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbYBQC4T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 21:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbYBQC4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 21:56:12 -0500
Received: from iabervon.org ([66.92.72.58]:55966 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753865AbYBQC4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 21:56:11 -0500
Date: Sat, 16 Feb 2008 21:56:09 -0500 (EST)
From: Daniel Barkalow <barkalow@iabervon.org>
To: linux-kernel@vger.kernel.org
Subject: [REGRESSION 2.6.23] no vga console and no messages
Message-ID: <alpine.LNX.1.00.0802162042130.6093@iabervon.org>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some reason I can't see and don't know how to debug, in 2.6.23 on my 
server I don't get the vga console, but only get the dummy console.

I also noticed that the documentation is wrong and the Kconfig file is 
confused; it's impossible to not have DUMMY_CONSOLE set, because at least 
one of PROM_CONSOLE and VGA_CONSOLE must not be y. Normally (maybe only 
due to the fact that "dummycon" sorts before "promcon", "sticon", and 
"vgacon"), it actually only stays active if your real console doesn't also 
get initialized. This isn't my problem, AFAICT (my kernel panics if I 
disable DUMMY_CONSOLE, presumably for lack of any console at all); it's 
just misleading.

I'm not seeing anything in dmesg to indicate why VGA+ isn't getting 
registered successfully, or anything to suggest it is trying to be, nor do 
I see anything in a 2.6.22 boot about why that seems to work. Any 
suggestions on further things to try?

I haven't tested anything newer than 2.6.23.x, but I looked through the 
git history and didn't find anything that looked relevant, or even anyone 
who might know about it.

	-Daniel
*This .sig left intentionally blank*
