Return-Path: <linux-kernel-owner+w=401wt.eu-S1031470AbXEDSSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031470AbXEDSSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 14:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031506AbXEDSSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 14:18:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031504AbXEDSSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 14:18:02 -0400
Date: Fri, 4 May 2007 13:17:23 -0500
From: David Teigland <teigland@redhat.com>
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: linux-kernel@vger.kernel.org, linux-cluster@redhat.com,
       joel.becker@oracle.com, swhiteho@redhat.com
Subject: Re: [PATCH] DLM: fix a couple of races
Message-ID: <20070504181723.GA13775@redhat.com>
References: <Pine.LNX.4.64.0705042119510.16239@cselinux1.cse.iitk.ac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705042119510.16239@cselinux1.cse.iitk.ac.in>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2007 at 09:49:45PM +0530, Satyam Sharma wrote:
> Hi,
> 
> There are the following two trivially-fixed races in fs/dlm/config.c:
> 
> 1. The configfs subsystem semaphore must be held by the caller when 
> calling config_group_find_obj(). It's needed to walk the subsystem 
> hierarchy without racing with a simultaneous mkdir(2) or rmdir(2). I 
> looked around to see if there was some other way we were avoiding this 
> race, but couldn't find any.
> 
> 2. get_comm() does hold the subsystem semaphore but lets go too soon -- 
> before grabbing a reference on the found config_item. A concurrent 
> rmdir(2) could come and release the comm after the up() but before the 
> config_item_get().
> 
> Patch that fixes both these bugs below.

Thanks, Steve should be able to throw this into one of his git trees.

Dave

