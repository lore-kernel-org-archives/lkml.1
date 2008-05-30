Return-Path: <linux-kernel-owner+w=401wt.eu-S1755201AbYE3MqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbYE3MqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 08:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbYE3MqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 08:46:05 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:52605 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbYE3MqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 08:46:03 -0400
Date: Fri, 30 May 2008 05:45:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: Confused by smp_read_barrier_depends() in rxrpc_rotate_tx_window()
Message-ID: <20080530124554.GA14312@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Dave!

I confess to being confused by the smp_read_barrier_depends() in
rxrpc_rotate_tx_window().  It looks like it is ordering the prior
fetch of tail from call->acks_tail with the subsequent use of
tail as an index into the call->acks_window[] array, but then the
code does an assignment to call->acks_tail a few lines later.

If we hold a lock protecting call->acks_tail, why do we need the
smp_read_barrier_depends()?  If we don't hold such a lock, why
is the assignment to call->acks_tail safe?

Help?

						Thanx, Paul
