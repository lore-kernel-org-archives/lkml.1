Return-Path: <linux-kernel-owner+w=401wt.eu-S1758884AbYELDyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758884AbYELDyD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 23:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754517AbYELDxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 23:53:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:29705 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299AbYELDxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 23:53:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=K3EaaOPx4AbcIkzgUqnN+KUZGcvXR1s1WVsTR84AqLzE36NZsROchUAhuTkg7jxKQk/ET6eAvDxiTDxeWWFbWf+l37AXGOd/fqIEMua1illLKdwkzQKppkTEh/LHZxFm2rIDFOdlpr5HTchFPeNnd4i0MFpJMcyvdBgHBqXV6us=
Date: Mon, 12 May 2008 11:51:51 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, WANG Cong <wangcong@zeuux.org>
Subject: Re: [Patch 9/9] fs/exec.c: fix a wrong goto path
Message-ID: <20080512035139.GC2572@hacking>
References: <1210254754206-git-send-email-xiyou.wangcong@gmail.com> <12102548752866-git-send-email-xiyou.wangcong@gmail.com> <20080510193701.GH13907@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080510193701.GH13907@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 10, 2008 at 08:37:01PM +0100, Al Viro wrote:
>On Thu, May 08, 2008 at 09:52:34PM +0800, WANG Cong wrote:
>> When nameidata_to_filp() fails, I see no reasons to fall into 'out' path
>> where doesn't free any resources at all.
>
>How about "nameidata_to_filp() frees on failure"?

When it fails, it should free the resources that were allocated before it.
That's to say, it should goto 'exit' on failure.

Am I missing something obvious?

-- 
Hi, I'm a .signature virus, please copy/paste me to help me spread
all over the world.
