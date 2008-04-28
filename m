Return-Path: <linux-kernel-owner+w=401wt.eu-S965867AbYD1Pto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965867AbYD1Pto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935627AbYD1Pnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:43:35 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:55725 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936280AbYD1Pnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:43:32 -0400
Date: Mon, 28 Apr 2008 11:42:40 -0400
From: Jeff Dike <jdike@addtoit.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 9/19] UML - Tidy ptrace interface
Message-ID: <20080428154240.GD7334@c2.user-mode-linux.org>
References: <20080425175610.GA11188@c2.user-mode-linux.org> <20080426.173538.195417245.xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426.173538.195417245.xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 05:35:38PM +0800, WANG Cong wrote:
> From: Jeff Dike <jdike@addtoit.com>
> Date: Fri, 25 Apr 2008 13:56:10 -0400
> > Tidy the ptrace interface code.  Removed a bunch of unused macros.
> > Started converting register sets from arrays of longs to structures.
> 
> Could you please explain a bit why do this? I think long arrary is OK.

It's wrong on x86_64.  There, FRAME_SIZE is 168 -
     #define FRAME_SIZE 
and SS is the last register defined -
    #define SS 160
but there are a number of registers beyond that in the user_regs_struct:
	unsigned long	ss;
	unsigned long	fs_base;
	unsigned long	gs_base;
	unsigned long	ds;
	unsigned long	es;
	unsigned long	fs;
	unsigned long	gs;

The effect of GETREGS into a long[FRAME_SIZE] will be stack corruption.

    	      	      Jeff

-- 
Work email - jdike at linux dot intel dot com
