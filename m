Return-Path: <linux-kernel-owner+w=401wt.eu-S1751822AbZGXAdC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbZGXAdC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 20:33:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbZGXAdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 20:33:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751539AbZGXAdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 20:33:00 -0400
Date: Thu, 23 Jul 2009 17:32:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       mike.miller@hp.com, jens.axboe@oracle.com
Subject: Re: [PATCH 2 2/4] cciss: use mutex instead of flag to indicate busy
 initializing
Message-Id: <20090723173252.a83eac26.akpm@linux-foundation.org>
In-Reply-To: <20090721195527.20740.1301.stgit@bob.kio>
References: <20090721195517.20740.18994.stgit@bob.kio>
	<20090721195527.20740.1301.stgit@bob.kio>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jul 2009 13:55:27 -0600
Andrew Patterson <andrew.patterson@hp.com> wrote:

> cciss: use mutex instead of flag to indicate busy initializing
> 
> Convert busy_initializing from simple integer flag to mutex, so we
> can use it to block and thus avoid some race conditions.
> 

But the code never blocks on busy_initializing.  The only place where
we do a mutex_lock() is in cciss_init_one().  Everywhere else we're
using the mutex as a boolean flag in weird ways.

I really don't have the time to work out what we're trying to do here. 
Does the code actually work?  If so I'm thinking we should merge it and
pretend that someone else did it :(

