Return-Path: <linux-kernel-owner+w=401wt.eu-S1762765AbYEBJdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762765AbYEBJdV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 05:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760107AbYEBJdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 05:33:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41097 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756786AbYEBJdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 05:33:04 -0400
Date: Fri, 2 May 2008 10:33:02 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] fs: remove local variable copy of f_pos to enable
	thread-safe updates
Message-ID: <20080502093301.GE5882@ZenIV.linux.org.uk>
References: <91456.70679.qm@web52001.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91456.70679.qm@web52001.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 02:14:25AM -0700, Matti Linnanvuori wrote:
> From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
> 
> Remove local variable copy of f_pos to enable thread-safe updates in
> implementation functions of system calls read, readv, write and writev.

... and we are back to square one with racy instances of ->read() that
will use *pos twice, leaving a window for e.g. lseek() to invalidate
e.g. wraparound tests.  Not that deciding what to do at the end of
e.g. read() with lseek() happening in the middle would be fun anyway -
esp. since you don't remember the kind of seek it had been.

Go argue that with Linus.
