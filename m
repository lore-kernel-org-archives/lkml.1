Return-Path: <linux-kernel-owner+w=401wt.eu-S1756697AbYDUJp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbYDUJp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 05:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754534AbYDUJpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 05:45:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50309 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378AbYDUJpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 05:45:18 -0400
Date: Mon, 21 Apr 2008 10:45:15 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: fault in __d_lookup [Was: 2.6.25-mm1]
Message-ID: <20080421094515.GR27459@ZenIV.linux.org.uk>
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org> <480C50EC.2090803@gmail.com> <20080421090610.GO27459@ZenIV.linux.org.uk> <480C6064.10801@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480C6064.10801@gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 11:37:40AM +0200, Jiri Slaby wrote:
> On 04/21/2008 11:06 AM, Al Viro wrote:
> >On Mon, Apr 21, 2008 at 10:31:40AM +0200, Jiri Slaby wrote:
> >
> >        hlist_for_each_entry_rcu(dentry, node, head, d_hash) {
> >                struct qstr *qstr;
> >
> >                if (dentry->d_name.hash != hash)
> >                        continue;
> >
> >walking into node == (struct hlist_node *)0x00f0000000000000...
> 
> Yup, true, In the last oops I stuck on memcmp few lines below.
> 
> BTW. it's 100% reproducible after it happens once, but fixable by reboot. 
> Any tests I should run (memtest, some printks sticked anywhere)?

Well, if list has such turd in it, you'll certainly hit it every time
you walk that list, so 100% reproducible is not surprising.

How well is it reproducible from fresh boot?
