Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbYEJTNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbYEJTNE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 15:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbYEJTMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 15:12:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33223 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbYEJTMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 15:12:54 -0400
Date: Sat, 10 May 2008 20:12:51 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       WANG Cong <wangcong@zeuux.org>
Subject: Re: [Patch 1/9] fs/exec.c: export free_arg_pages
Message-ID: <20080510191251.GA13907@ZenIV.linux.org.uk>
References: <1210254754206-git-send-email-xiyou.wangcong@gmail.com> <12102547782640-git-send-email-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12102547782640-git-send-email-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 09:52:26PM +0800, WANG Cong wrote:
> free_arg_pages() is used to clean the pages allocated by copy_strings_kenrel().
> Since copy_strings_kernel() is exported, so should be free_arg_pages().

Not really.  free_arg_pages() cleans them all at once; copy_strings_kernel()
adds to pile.  free_arg_pages() is called once for _all_ of them.  And that
happens in fs/exec.c, so it doesn't need to be exported.
