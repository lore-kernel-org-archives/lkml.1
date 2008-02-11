Return-Path: <linux-kernel-owner+w=401wt.eu-S1756549AbYBKVYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbYBKVYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 16:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbYBKVYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 16:24:14 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44262 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752725AbYBKVYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 16:24:12 -0500
Date: Mon, 11 Feb 2008 13:17:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH 3/3] Final removal of FASTCALL()/fastcall
Message-Id: <20080211131738.dda66683.akpm@linux-foundation.org>
In-Reply-To: <1202755123.6313.16.camel@brick>
References: <1202755123.6313.16.camel@brick>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008 10:38:42 -0800
Harvey Harrison <harvey.harrison@gmail.com> wrote:

> All users are gone, remove definitions and comments referring
> to them.

I'm still showing occurrences in:

./Documentation/RCU/NMI-RCU.txt
./Documentation/kprobes.txt
./Documentation/uml/UserModeLinux-HOWTO.txt
./kernel/rcupdate.c

The last one is interesting:

/* FASTCALL no longer exists, this wrapper may no longer be needed */
static void wakeme_after_rcu(struct rcu_head  *head)
{
        struct rcu_synchronize *rcu;

        rcu = container_of(head, struct rcu_synchronize, head);
        complete(&rcu->completion);
}

The comment is rather ungrammatical/meaningless.  Perhaps it is trying
to tell us that we can remove this function now?
