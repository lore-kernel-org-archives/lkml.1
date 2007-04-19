Return-Path: <linux-kernel-owner+w=401wt.eu-S1766873AbXDSQsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766873AbXDSQsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 12:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766868AbXDSQsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 12:48:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44613 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766873AbXDSQsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 12:48:09 -0400
Date: Thu, 19 Apr 2007 17:47:46 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "<Andrew Morton" <akpm@osdl.org>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd_blkdevs: Convert to use the kthread API
Message-ID: <20070419164746.GA19469@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	"<Andrew Morton" <akpm@osdl.org>, containers@lists.osdl.org,
	Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com> <11769657692046-git-send-email-ebiederm@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11769657692046-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 12:55:28AM -0600, Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com> - unquoted
> 
> thread_run is used intead of kernel_thread, daemonize, and mucking
> around blocking signals directly.

Please don't do incomplete transitions like that.  We don't really
want people to use kthread_run, but not the kthread stopping
mechanisms, because people will simply forget about that bit and
we'll never get rid of the enormous amount of, erm creativity, in
handling kernel thread stopping.

This is just the first patch in your series where the thread is mutable,
but it equally applies to all following patches where this is the case
aswell.
