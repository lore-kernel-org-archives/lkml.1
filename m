Return-Path: <linux-kernel-owner+w=401wt.eu-S1756411AbYFWCTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbYFWCTS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 22:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbYFWCTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 22:19:09 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:51161 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbYFWCTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 22:19:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=vX6dAfpaP2Dlb98uFpXcFsvRd9bdxK1HVMTKRcOgjZfhNhSKW19MPDz5wsAsnvRUAA
         E+oQHuzazh4O/5XpAkd5rBo2EPKGq/a/0RPC/jvm3ieI/4p01hgywejgW2GKQdG84tvU
         UiLYMnEHY19iMAoEdNp/u7+FwMnvLA1OggC0k=
Message-ID: <485F0812.4090903@gmail.com>
Date: Mon, 23 Jun 2008 11:18:58 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Benjamin Thery <benjamin.thery@bull.net>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Biederman <ebiederm@xmission.com>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 11/11] sysfs: user namespaces: fix bug with clone(CLONE_NEWUSER)
 with fairsched
References: <20080618170729.808539948@theryb.frec.bull.fr> <20080618170731.746054454@theryb.frec.bull.fr>
In-Reply-To: <20080618170731.746054454@theryb.frec.bull.fr>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Thery wrote:
> Mark the /sys/kernel/uids directory to be tagged so that processes in
> different user namespaces can remount /sys and see their own uid
> listings.
> 
> Without this patch, having CONFIG_FAIR_SCHED=y makes user namespaces
> unusable, because when you 
>   clone(CLONE_NEWUSER)
> it will auto-create the root userid and try to create
> /sys/kernel/uids/0.  Since that already exists from the parent user
> namespace, the create fails, and the clone misleadingly ends up
> returning -ENOMEM.
> 
> This patch fixes the issue by allowing each user namespace to remount
> /sys, and having /sys filter the /sys/kernel/uid/ entries by user
> namespace.
> 
> Signed-off-by: Serge Hallyn <serue@us.ibm.com>
> Signed-off-by: Benjamin Thery <benjamin.thery@bull.net>

Ditto as patch #10.

Thanks.

-- 
tejun
