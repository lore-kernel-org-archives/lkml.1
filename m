Return-Path: <linux-kernel-owner+w=401wt.eu-S1030801AbXDVTpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030801AbXDVTpF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 15:45:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030811AbXDVTpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 15:45:04 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54008 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030801AbXDVTpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 15:45:03 -0400
Date: Sun, 22 Apr 2007 20:44:55 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH] bluetooth bnep: Convert to kthread API.
Message-ID: <20070422194455.GA18561@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	containers@lists.osdl.org, Oleg Nesterov <oleg@tv-sign.ru>,
	linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com> <1176969596686-git-send-email-ebiederm@xmission.com> <20070419162459.af7a182c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070419162459.af7a182c.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 04:24:59PM -0700, Andrew Morton wrote:
> On Thu, 19 Apr 2007 01:58:51 -0600
> "Eric W. Biederman" <ebiederm@xmission.com> wrote:
> 
> > From: Eric W. Biederman <ebiederm@xmission.com>
> > 
> > This patch starts kbenpd using kthread_run replacing
> > a combination of kernel_thread and daemonize.  Making
> > the code a little simpler and more maintainable.
> > 
> >
> 
> 	while (!atomic_read(&s->killed)) {
> 
> ho hum.

Note that this also stands against a full kthread conversion.
Marcel put my old patches for a full kthread conversion in, but
they didn't deal properly with some of the premaure exit cases,
and causes OOPSes.

I don't remember what the problems where, but the case of a thread
terminating earlier and possibly asynchronously is one of the
cases we'll probably have to add to the kthread infrastructure
before all uses of kernel_thread in drivers can be converted.

