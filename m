Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827AbZBCWG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbZBCWG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 17:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbZBCWGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 17:06:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751598AbZBCWGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 17:06:48 -0500
Date: Tue, 3 Feb 2009 14:05:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: corbet@lwn.net, linux-kernel@vger.kernel.org, andi@firstfloor.org,
       oleg@redhat.com, viro@ZenIV.linux.org.uk, davidel@xmailserver.org,
       davem@davemloft.net, hch@lst.de, linux-api@vger.kernel.org,
       mpm@selenic.com, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 2/4] Convert epoll to a bitlock
Message-Id: <20090203140543.6e915f97.akpm@linux-foundation.org>
In-Reply-To: <4988BD4E.8080206@cosmosbay.com>
References: <1233598811-6871-1-git-send-email-corbet@lwn.net>
	<1233598811-6871-3-git-send-email-corbet@lwn.net>
	<20090203133942.2ecec281.akpm@linux-foundation.org>
	<4988BD4E.8080206@cosmosbay.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Feb 2009 22:55:26 +0100
Eric Dumazet <dada1@cosmosbay.com> wrote:

> Andrew Morton a __crit :
> > On Mon,  2 Feb 2009 11:20:09 -0700
> > Jonathan Corbet <corbet@lwn.net> wrote:
> > 
> >> Matt Mackall suggested converting epoll's ep_lock to a bitlock as a way of
> >> saving space in struct file.  This patch makes that change.
> > 
> > hrm.  bit_spin_lock() makes people upset (large penguiny people).  iirc
> > it doesn't have all the correct/well-understood memory/compiler
> > ordering semantics which spinlocks have.  And lockdep doesn't know about
> > it.
> > 
> 
> In a previous attempt (2005), I suggested using a single global lock.
> 
> http://search.luky.org/linux-kernel.2005/msg50862.html

ok..

> Probably an array of hashed spinlocks would be more than enough.
> 

yes, f_ep_lock is a teeny innermost lock.  Perhaps using
f->f_dentry->d_inode->i_lock would be a decent speed/space compromise.


