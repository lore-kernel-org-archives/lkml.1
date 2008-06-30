Return-Path: <linux-kernel-owner+w=401wt.eu-S1757009AbYF3Fq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009AbYF3Fq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 01:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbYF3FqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 01:46:19 -0400
Received: from ns2.suse.de ([195.135.220.15]:57155 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324AbYF3FqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 01:46:18 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] aio: avoid using queue_delayed_work in aio_kick_handler to schedule itself
Date: Mon, 30 Jun 2008 11:20:27 +0530
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: linux-aio@kvack.org, linux-kernel@vger.kernel.org,
       Benjamin LaHaise <bcrl@kvack.org>, Zach Brown <zach.brown@oracle.com>
References: <200806260927.27995.knikanth@suse.de> <x49prq3t43a.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49prq3t43a.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200806301120.27743.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 June 2008 18:41:37 Jeff Moyer wrote:
> Nikanth Karthikesan <knikanth@suse.de> writes:
> > Avoid using queue_delayed_work in aio_kick_handler() to run itself
> > immediately. Instead use aio_run_all_iocbs()
>
> Can you give some rationale for this change?  Also, how did you test it?
>

The comment in aio_kick_handler(), "we're in a worker thread already, don't 
use queue_delayed_work" triggered me to do this. Ran multiple instances 
of Stephen Hemminger's aio cp for basic testing.

I think this would make it unfair between different kioctx? May be only the 
comment should be removed? 

Thanks
Nikanth Karthikesan






