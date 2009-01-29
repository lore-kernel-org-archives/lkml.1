Return-Path: <linux-kernel-owner+w=401wt.eu-S1758762AbZA2Pot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762AbZA2Pot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 10:44:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbZA2Pol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 10:44:41 -0500
Received: from lirone.symas.net ([64.71.152.235]:57958 "EHLO lirone.symas.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117AbZA2Pok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 10:44:40 -0500
X-Greylist: delayed 2201 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Jan 2009 10:44:40 EST
Message-ID: <4981C648.3000108@symas.com>
Date: Thu, 29 Jan 2009 07:07:52 -0800
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; rv:1.9.2a1pre) Gecko/20081227 SeaMonkey/2.0a1pre Firefox/3.0.3
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: epoll optimizations
References: <Pine.LNX.4.64.0703061628470.3661@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0703061628470.3661@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Something I tripped over recently, that might be nice to change... HANGUP 
events are always reported, and apparently can't be turned off. In 
level-triggered mode, if your event loop treats Hangups as lower priority than 
read/write events, an outstanding Hangup will continue to be signaled every 
time you call epoll_wait() until it's finally disposed of. It would be nice if 
Hangups were always oneshot events, regardless of whether the FD was 
configured level, edge, or oneshot. Certainly we know that the *cause* of a 
Hangup can only happen once on any descriptor, so it makes no sense for it to 
be reported more than once.

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
