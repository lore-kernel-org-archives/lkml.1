Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbYBCXI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbYBCXI0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 18:08:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbYBCXIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 18:08:16 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52381 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753323AbYBCXIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 18:08:14 -0500
Date: Sun, 3 Feb 2008 15:07:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: netdev@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: locking api self-test hanging
Message-Id: <20080203150744.cf7d0415.akpm@linux-foundation.org>
In-Reply-To: <20080203150246.50647fa4.akpm@linux-foundation.org>
References: <20080203150246.50647fa4.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Feb 2008 15:02:46 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> With current mainline I'm getting intermittent hangs here:
> 
> 	http://userweb.kernel.org/~akpm/p2033590.jpg
> 
> with this config:
> 
> 	http://userweb.kernel.org/~akpm/config-sony.txt
> 
> on the Vaio.  Sometimes it boots (then hits another different hang),
> sometimes it gets stuck there.
> 

The second hang is in kobject_uevent_init().  All that function does is call
netlink_kernel_create().

These things make bisecting all the other bugs rather hard.
