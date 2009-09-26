Return-Path: <linux-kernel-owner+w=401wt.eu-S1752607AbZIZSyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbZIZSyU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 14:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbZIZSyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 14:54:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:36387 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbZIZSyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 14:54:18 -0400
Date: Sat, 26 Sep 2009 20:49:51 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, mingo@elte.hu
Subject: [PATCH 0/9] Series to make copy_from_user to a stack slot provable
 right
Message-ID: <20090926204951.424e567e@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 0/9] Series to make copy_from_user to a stack slot provable right

This series contains a series of patches that, when applied, make every
copy_from_user() in a make allyesconfig to a (direct) stack slot
provable-by-gcc to have a correct size.

This is useful because if we fix all of these, we can make the non-provable
case an error, as an indication of a possible security hole.

Now the series has 4 types of patches
1) changes where the original code really was missing checks
2) changes where the checks were coded so complex and games were played with
   types, that I (and the compiler) couldn't be sure if it was correct or
   not
3) changes where we're hitting a small gcc missing optimization, but where
   a simplification of the code allows gcc to prove things anyway.
   (http://gcc.gnu.org/bugzilla/show_bug.cgi?id=41477 is filed for this)
4) a case in sys_socketcall where Dave Miller and co were very smart in
   optimizing the code to the point where it's not reasonable for gcc
   to realize the result is ok.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
