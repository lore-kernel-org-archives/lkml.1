Return-Path: <linux-kernel-owner+w=401wt.eu-S934965AbYCFRFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934965AbYCFRFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 12:05:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763223AbYCFRFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 12:05:24 -0500
Received: from cantor.suse.de ([195.135.220.2]:38837 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759450AbYCFRFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 12:05:23 -0500
Date: Thu, 6 Mar 2008 09:05:14 -0800
From: Greg KH <gregkh@suse.de>
To: Balaji Rao <balajirrao@gmail.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Mark kobjects as unitialized
Message-ID: <20080306170514.GA13839@suse.de>
References: <200803062223.18857.balajirrao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803062223.18857.balajirrao@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 10:23:18PM +0530, Balaji Rao wrote:
> Hi greg,
> 
> When I remove only the kvm-intel module without removing the kvm
> module itself, I get an error saying that a kobject is trying to be
> reinitialized. Its because of the fact that kvm reuses a kobject in
> kvm_init when calling sysdev_register.

Where exactly in the code does that happen?  kobjects should not be
"reused" as that implies that they are static, and not dynamically
allocated, right?

Which kobject is this?

Ugh, is this the sys_device stuff?  I hate that code...

> This patch fixes kobject_cleanup by marking the kobject as
> uninitialized when we cleanup to allow kobjects to be reused.

The patch seems correct, but I would like to verify which kobject is
being reused here first.

thanks,

greg k-h
