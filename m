Return-Path: <linux-kernel-owner+w=401wt.eu-S1753115AbXLHOH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbXLHOH7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 09:07:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbXLHOHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 09:07:50 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55068 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbXLHOHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 09:07:49 -0500
Date: Sat, 8 Dec 2007 14:07:47 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-nfs@vger.kernel.org, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NLM: Add lockd reference counting and clean up lockd
	startup and shutdown
Message-ID: <20071208140747.GA11675@infradead.org>
References: <1197118932-4512-1-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197118932-4512-1-git-send-email-jlayton@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	mutex_lock(&nlmsvc_mutex);
> +	while (atomic_read(&nlmsvc_ref) != 0) {

might be better to do the refcounting outside the thread and use the
kthread api, which is something we still need to do for lockd anyway.

