Return-Path: <linux-kernel-owner+w=401wt.eu-S1758166AbYELD6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166AbYELD6b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 23:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbYELD6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 23:58:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35405 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbYELD6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 23:58:23 -0400
Date: Mon, 12 May 2008 04:58:19 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       WANG Cong <wangcong@zeuux.org>
Subject: Re: [Patch 9/9] fs/exec.c: fix a wrong goto path
Message-ID: <20080512035819.GM13907@ZenIV.linux.org.uk>
References: <1210254754206-git-send-email-xiyou.wangcong@gmail.com> <12102548752866-git-send-email-xiyou.wangcong@gmail.com> <20080510193701.GH13907@ZenIV.linux.org.uk> <20080512035139.GC2572@hacking>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080512035139.GC2572@hacking>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 11:51:51AM +0800, WANG Cong wrote:
> On Sat, May 10, 2008 at 08:37:01PM +0100, Al Viro wrote:
> >On Thu, May 08, 2008 at 09:52:34PM +0800, WANG Cong wrote:
> >> When nameidata_to_filp() fails, I see no reasons to fall into 'out' path
> >> where doesn't free any resources at all.
> >
> >How about "nameidata_to_filp() frees on failure"?
> 
> When it fails, it should free the resources that were allocated before it.
> That's to say, it should goto 'exit' on failure.
> 
> Am I missing something obvious?

Yes.  Take a look at the things dealt with at exit.  Then look at what
nameidata_to_filp() does on failure.
