Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbZBCVkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbZBCVkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 16:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZBCVkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 16:40:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751391AbZBCVkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 16:40:37 -0500
Date: Tue, 3 Feb 2009 13:39:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, oleg@redhat.com,
       viro@ZenIV.linux.org.uk, davidel@xmailserver.org, davem@davemloft.net,
       hch@lst.de, linux-api@vger.kernel.org, mpm@selenic.com,
       alan@lxorguk.ukuu.org.uk, corbet@lwn.net
Subject: Re: [PATCH 2/4] Convert epoll to a bitlock
Message-Id: <20090203133942.2ecec281.akpm@linux-foundation.org>
In-Reply-To: <1233598811-6871-3-git-send-email-corbet@lwn.net>
References: <1233598811-6871-1-git-send-email-corbet@lwn.net>
	<1233598811-6871-3-git-send-email-corbet@lwn.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  2 Feb 2009 11:20:09 -0700
Jonathan Corbet <corbet@lwn.net> wrote:

> Matt Mackall suggested converting epoll's ep_lock to a bitlock as a way of
> saving space in struct file.  This patch makes that change.

hrm.  bit_spin_lock() makes people upset (large penguiny people).  iirc
it doesn't have all the correct/well-understood memory/compiler
ordering semantics which spinlocks have.  And lockdep doesn't know about
it.

