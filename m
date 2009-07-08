Return-Path: <linux-kernel-owner+w=401wt.eu-S1758543AbZGHUDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543AbZGHUDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 16:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755265AbZGHUDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 16:03:31 -0400
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:39103 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754627AbZGHUDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 16:03:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=sihoIA7dzuYuzLrYVtGaLlj4KZca65OU62PAWqOEyoUGw767W1iwLtFwLlpqtcwn;
  h=Received:Message-Id:From:To:Content-Type:Content-Transfer-Encoding:Mime-Version:Subject:Date:X-Mailer:X-ELNK-Trace:X-Originating-IP;
Message-Id: <226B561B-ABBC-4CBC-BFFE-0BA32FC561EE@earthlink.net>
From: Mitchell Erblich <erblichs@earthlink.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Simple Code change suggestion : pdflush() : clean pages in 1/2 time
Date: Wed, 8 Jul 2009 13:03:28 -0700
X-Mailer: Apple Mail (2.930.3)
X-ELNK-Trace: 074f60c55517ea841aa676d7e74259b7b3291a7d08dfec79e893bd42393951482a5d2b32c55cd8aa350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 98.234.127.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Group,

	pdflush threads clean dirty pages.

	Under the past simple assumption that a greater number of
	  page daemon threads will have the TENDENCY to clean
	  the pages faster.

	  A simple change is to create 2x the number of threads
	  within the same timeframe as before.
	
	   Thus, in mm/pdflush.c _pdflush() thread creation is done
	    in 1/2 HZ. ( "/" or ">>" , compiler will optimize)
	    Above 1 sec omment should also be changed.

	   IMO, We could do in 1/4 or 1/8 HZ,  but load (backlog of dirty  
pages)
	   should then be tracked and watermarks set and determine whether
	  keep adding  additional threads allows us to clean the pages faster.
	  (Yes, did that / done that and the code is/was ... too complicated)

	  The 2nd part is to prevent thread creation / destruction thrashing,
	  keep around the extra threads to handle the bursts of frees so HZ
	  is still kept to limit exit rate.

	Mitchell Erblich
