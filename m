Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936640Ab0B1Twr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 14:52:47 -0500
Received: from cet.com.ru ([195.178.208.66]:43045 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S936463Ab0B1Twp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 14:52:45 -0500
Date: Sun, 28 Feb 2010 22:52:43 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Why does connector use a work queue???
Message-ID: <20100228195243.GA15976@ioremap.net>
References: <m1pr3qcbk1.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1pr3qcbk1.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 27, 2010 at 06:57:02PM -0800, Eric W. Biederman (ebiederm@xmission.com) wrote:
> These days netlink callbacks for messages happen in the context of the
> process who sent the message.  Things like permission checks are much
> more complicated if we don't use that process context.
> 
> I was looking at removing NETLINK_CB(skb).eff_cap but I discovered
> that connected takes the netlink messages, them from their
> perfectly good process context, and puts the into a workqueue
> for reasons that are not apparent to me.

Netlink was made synchronous rather recently and connector was not
changed to take advantage of that. Previously it used work queue to
postpone work processing into always-process context.

> Unless I am misreading something we should just be able to remove the
> work queues and greatly simplify the connector code.
> 
> Something like:

Idea looks very good, thank you, but it misses structure changes
to eliminate now unneded members.

-- 
	Evgeniy Polyakov
