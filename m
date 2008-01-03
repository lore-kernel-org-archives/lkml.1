Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008AbYACOOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbYACOOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 09:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbYACOOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 09:14:09 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47554 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbYACOOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 09:14:08 -0500
Date: Thu, 3 Jan 2008 14:14:05 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>, Jiri Slaby <jirislaby@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: isofs oops - d_splice_alias+0x1f (2.6.24-rc5-mm1)
Message-ID: <20080103141405.GV27894@ZenIV.linux.org.uk>
References: <477CE1E0.4010504@gmail.com> <Pine.LNX.4.64.0801031550160.2076@sbz-30.cs.Helsinki.FI> <20080103141120.GC19363@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103141120.GC19363@elte.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2008 at 03:11:20PM +0100, Ingo Molnar wrote:
> and there are about 5 other callsites as well that only check for a NULL 
> return.

... except that this is *not* getting NULL or make_bad_inode(); that's
getting ERR_PTR(), which can't happen in mainline.  So that looks like
an -mm patch changing calling conventions and not updating callers...
