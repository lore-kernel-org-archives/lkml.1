Return-Path: <linux-kernel-owner+w=401wt.eu-S1755397AbZJLJZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbZJLJZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 05:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755385AbZJLJZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 05:25:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:35721 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755327AbZJLJZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 05:25:50 -0400
Date: Mon, 12 Oct 2009 11:25:13 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: iceberg <iceberg@ispras.ru>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] hidraw.c: double mutex_lock
In-Reply-To: <1255353109.13239.0@pamir>
Message-ID: <alpine.LSU.2.00.0910121124110.19284@wotan.suse.de>
References: <1255353109.13239.0@pamir>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009, iceberg wrote:

> 	KERNEL_VERSION: 2.6.31
> 	DESCRIBE:
> 	In driver ./drivers/hid/hidraw.c in function hidraw_read may be 
> double mutex_lock:
> 
> Path:
> 1. line 50: begin first iteration of "while(ret==0)"
> 2. line 52: first call to mutex_lock
> 3. inner loop "while (list->head == list->tail)" does not change state 
> of mutex, because mutex_lock immediatelly follows mutex_unlock
> 4. if we go to the second iteration of "while(ret == 0)" in 
> line 50 then there are second call to mutex_lock in line 52 (mutex 
> aquired twice).
> 
> Second iteration of loop "while(ret==0)" is possible if local variable 
> ret is not changed at line 94: ret+=len - i.e. len==0;
> Variable len may be zero if hidraw_read is called with count==0 or 
> list->buffer[list->tail].len == 0.

Good catch. I will fix that up by moving the mutex_lock() so that it's 
locked before the loop is entered.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
