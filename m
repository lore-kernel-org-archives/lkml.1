Return-Path: <linux-kernel-owner+w=401wt.eu-S933148AbXC1Q73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148AbXC1Q73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 12:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933191AbXC1Q73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 12:59:29 -0400
Received: from mail.fieldses.org ([66.93.2.214]:43528 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933148AbXC1Q72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 12:59:28 -0400
Date: Wed, 28 Mar 2007 12:59:25 -0400
To: Thorsten Kranzkowski <dl8bcu@dl8bcu.de>, Phy Prabab <phyprabab@gmail.com>,
       nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: Odd log message associated with NFS
Message-ID: <20070328165925.GB21221@fieldses.org>
References: <2fe399760703271140l703c2791oa84e9e1832487dcb@mail.gmail.com> <20070327193909.GA585@ds20.borg.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070327193909.GA585@ds20.borg.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2007 at 07:39:10PM +0000, Thorsten Kranzkowski wrote:
> Mar 16 16:57:06 Marvin kernel: svc: bad direction 268435456, dropping request
> Mar 16 17:58:19 Marvin kernel: svc: bad direction 268435456, dropping request
> Mar 16 19:55:49 Marvin kernel: svc: bad direction 268435456, dropping request

So that's 2^28, in a field that should always be zero.  It's the very
first check of any data read from the rpc call, so it'd be consistent
with the call data being garbage, for one reason or another.

What would cause that to happen, I don't know.  Do you have a reliable
way to reproduce it?

--b.
