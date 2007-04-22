Return-Path: <linux-kernel-owner+w=401wt.eu-S1030608AbXDVMfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030608AbXDVMfH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 08:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030512AbXDVMfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 08:35:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46967 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030608AbXDVMfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 08:35:05 -0400
Date: Sun, 22 Apr 2007 13:34:56 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "<Andrew Morton" <akpm@osdl.org>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] powerpc pseries rtasd: Convert to kthread API.
Message-ID: <20070422123456.GG20763@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	"<Andrew Morton" <akpm@osdl.org>, containers@lists.osdl.org,
	Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
	Paul Mackerras <paulus@samba.org>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com> <1176969582987-git-send-email-ebiederm@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1176969582987-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 01:58:46AM -0600, Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> This patch modifies the startup of rtasd to use kthread_run instaed of
> a combination of kernel_thread and daemonize.  Making the code a little
> simpler and more maintainble.

Looks okay, but I have some questions about the original code.

Why does the driver only check if it really needs to run in the
thread and calls vmalloc from it?  If we did all these in the
initialization function we could actually properly unwind.

