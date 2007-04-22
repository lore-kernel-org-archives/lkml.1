Return-Path: <linux-kernel-owner+w=401wt.eu-S1030862AbXDVUR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030862AbXDVUR2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 16:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030870AbXDVUR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 16:17:28 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60820 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030862AbXDVUR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 16:17:27 -0400
Date: Sun, 22 Apr 2007 21:17:09 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "<Andrew Morton" <akpm@osdl.org>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, Swen Schillig <swen@vnet.ibm.com>
Subject: Re: [PATCH] s390/scsi/zfcp_erp: Convert to use the kthread API
Message-ID: <20070422201709.GA23015@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	"<Andrew Morton" <akpm@osdl.org>, containers@lists.osdl.org,
	Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
	Swen Schillig <swen@vnet.ibm.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com> <1176969571980-git-send-email-ebiederm@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1176969571980-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 01:58:42AM -0600, Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Modify zfcperp%s to be started with kthread_run not
> a combination of kernel_thread, daemonize and siginitsetinv
> making the code slightly simpler and more maintainable.

This driver would also benefit from a full kthread conversion.
Unfortunately it has a strange dual-use semaphore (->erp_ready_sem)
that hinders a straight conversion.  Maybe the maintainer can take
a look whether there's a nice way to get rid of that one?

