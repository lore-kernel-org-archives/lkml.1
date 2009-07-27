Return-Path: <linux-kernel-owner+w=401wt.eu-S1753585AbZG0TcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbZG0TcY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 15:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbZG0TcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 15:32:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:60961 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568AbZG0TcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 15:32:22 -0400
Date: Mon, 27 Jul 2009 12:20:30 -0700
From: Greg KH <gregkh@suse.de>
To: Nicolas Palix <npalix@diku.dk>
Cc: hjanssen@microsoft.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Staging: hv: Transform typedef HANDLE into void *
Message-ID: <20090727192030.GA4201@suse.de>
References: <200907272111.35259.npalix@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907272111.35259.npalix@diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 09:11:34PM +0200, Nicolas Palix wrote:
> 
> Remove typedef HANDLE which aliases a void pointer and use void *
> anywhere HANDLE was used.

No, I would like to change this to be the "real" pointer that the HANDLE
was used for, instead of just a void pointer.  These need to point to
real structures.  I did this already for the locks, and can be done for
pretty much everything else as well.

> -int WorkQueueQueueWorkItem(HANDLE hWorkQueue, PFN_WORKITEM_CALLBACK workItem, void* context)
> +int WorkQueueQueueWorkItem(void *hWorkQueue, PFN_WORKITEM_CALLBACK workItem, void *context)
>  {
>  	WORKQUEUE *wq = (WORKQUEUE *)hWorkQueue;

Here's an example.  This should really be a pointer to a "work queue"
and not a void pointer at all.  Changes like that would be gladly
accepted.

thanks,

greg k-h
