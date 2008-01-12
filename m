Return-Path: <linux-kernel-owner+w=401wt.eu-S1760098AbYALF0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760098AbYALF0n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 00:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750895AbYALF0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 00:26:36 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47136 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbYALF0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 00:26:35 -0500
Date: Fri, 11 Jan 2008 21:26:23 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       tglx@tglx.de, hpa@zytor.com
Subject: [patch 0/8] Series to improve the x86 backtracing code
Message-ID: <20080111212623.518e1527@laptopd505.fenrus.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patch series improves the x86 backtracing code in the following ways:
1) Fix a bad bug in x86 (32 bit) FRAME_POINTER backtracing (2.6.24 material)
2) Add the capability to mark a backtrace entry as reliable / unreliable
3) Change the x86 (32 bit) FRAME_POINTER backtracing to use the normal backtrace but use the frames
   as guidance to the reliability of the backtrace entries
4) Patch to capture the EBP register earlier in the backtrace callchain to get a better FRAME_POINTER
   based backtrace
5) Split the x86 (64 bit) backtrace code up similar to the 32 bit code by turning a macro into a function
6) Enable FRAME_POINTER backtracing on 64 bit similar to the 32 bit patch in number 3
7) Add a simple self-test module for backtraces (will move to tests/ later when that gets merged)
8) Add the feature to x86 64bit to print a set of bytes prior to the current EIP in the Code: line
   (already present in 32 bit)

I have not yet implemented 2 requested items
1) To give dump_stack() and co a parameter towards the KERN_ log level; this is a patch that touches 125 files
   and while I like the idea I'm not sure it's worth THAT.
2) Linus' request to only print the first 5 entries of a backtrace with a important loglevel, and do the rest
   as KERN_WARNING  or so. This realistically wants 1) and I've not gotten to it yet (and it's independent functionality
   anyway)


Andrew:  You already have patch 1 in your tree, and it's not modified since that, so no need to refresh

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
