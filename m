Return-Path: <linux-kernel-owner+w=401wt.eu-S1757230AbYG3CEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbYG3CEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 22:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbYG3CER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 22:04:17 -0400
Received: from sacred.ru ([62.205.161.221]:50285 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225AbYG3CEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 22:04:16 -0400
Message-ID: <488FCC14.3070208@openvz.org>
Date: Wed, 30 Jul 2008 06:04:04 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Oleg Nesterov <oleg@tv-sign.ru>, jmorris@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: Request for documentation of PID handling functions
References: <21590.1217285986@redhat.com>
In-Reply-To: <21590.1217285986@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 30 Jul 2008 06:03:51 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Hi Pavel,
> 
> Can you please provide documentation for the PID handling functions you
> supplied in commit:
> 
> 	7af5729474b5b8ad385adadab78d6e723e7655a3
> 
> In particular I'd like to know what locks are required when.  I'm trying to
> determine if in this piece of code:
> 
> 		read_lock(&tasklist_lock);
> 		ret = 0;
> 		if (pid != task_pid_vnr(current))
> 			ret = -EPERM;
> 		read_unlock(&tasklist_lock);
> 
> the lock of tasklist_lock is necessary.

The RCU protection is enough to get pids from tasks. However, the pids
are detached under the tasklist lock write-locked, so provided you're
*already* sitting under it the RCU is excessive.

However, Oleg pointed me out some time ago, that in some cases RCU-only
protection was not enough in some cases, so I put him in Cc.

> David
> 

