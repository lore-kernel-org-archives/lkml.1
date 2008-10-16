Return-Path: <linux-kernel-owner+w=401wt.eu-S1754862AbYJPC7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbYJPC7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 22:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbYJPC66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 22:58:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbYJPC66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 22:58:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: prasad@linux.vnet.ibm.com
X-Fcc: ~/Mail/linus
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, akpm@linux-foundation.org,
       mingo@elte.hu, jason.wessel@windriver.com, avi@qumranet.com,
       richardj_moore@uk.ibm.com
Subject: Re: [RFC Patch 2/9] x86 architecture implementation of Hardware
	Breakpoint interfaces
In-Reply-To: K.Prasad's message of  Thursday, 9 October 2008 00:53:48 +0530 <20081008192348.GB4989@in.ibm.com>
References: <20081008192044.GA4510@in.ibm.com>
	<20081008192348.GB4989@in.ibm.com>
X-Shopping-List: (1) Unreliable trash
   (2) Interlocking scary ladder auditions
   (3) Sulfurous inorganic flossbag doodads
   (4) Golden doodads
   (5) Studious basket Garden Weasels
Message-Id: <20081016025728.3F92B1544CB@magilla.localdomain>
Date: Wed, 15 Oct 2008 19:57:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm leaving aside the single-step stuff, which I just posted about.

I'm also concerned about getting RF right here.  We need to make sure that
every place that warps ->ip away somewhere also clears RF.  In case of
instruction breakpoints in user space, we might also want to mask RF from
being seen/changed via ptrace/user_regset (a bit like is done for TF).

I'm a little inclined to do a first x86 version without instruction
breakpoint support and hash out the rest of the code for a bit.  Then add
instruction breakpoints in a later patch.  (Not that it has to be a lot
later or anything.  Just to table the detailed review of RF fiddling until
after most of the meaty stuff is pretty baked.)


Thanks,
Roland
