Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbYH1Qub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbYH1Qub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 12:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbYH1QuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 12:50:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33047 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbYH1QuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 12:50:18 -0400
Date: Thu, 28 Aug 2008 09:47:41 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] char_dev: add cdev->release() and convert
	cdev_alloc() to use it
Message-ID: <20080828164741.GA17475@kroah.com>
References: <48B6D428.2020308@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B6D428.2020308@kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 06:36:56PM +0200, Tejun Heo wrote:
> Add cdev->release() so that cdev can be considered in more involved
> object lifetime management.  cdev_alloc() used a separate ktype for
> auto-free release().  This patch converts it to use cdev->release() so
> that there's no need for separate ktype and cdev_init() can be used
> for auto-free variant too.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Ick, I really don't want struct cdev to be used for lifecycle
management, as it is only for major:minor stuff.  Why do you want to
make this change?

thanks,

greg k-h
