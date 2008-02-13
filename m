Return-Path: <linux-kernel-owner+w=401wt.eu-S1761968AbYBMC36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761968AbYBMC36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 21:29:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbYBMC3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 21:29:47 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36451 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753552AbYBMC3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 21:29:46 -0500
Date: Tue, 12 Feb 2008 18:28:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/4] fib_trie: improve output format for
 /proc/net/fib_trie
Message-Id: <20080212182823.6f8a3a12.akpm@linux-foundation.org>
In-Reply-To: <20080213005122.727447010@vyatta.com>
References: <20080213005042.150212716@vyatta.com>
	<20080213005122.727447010@vyatta.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008 16:50:44 -0800 Stephen Hemminger <shemminger@vyatta.com> wrote:

> Make output format prettier (more tree like).
> 
>    <local>:
>    --- 0.0.0.0/0
>      |--- 10.111.111.0/24
>      |  +-- 10.111.111.0/32 link broadcast
>      |  |--- 10.111.111.254/31
>      |  |  +-- 10.111.111.254/32 host local
>      |  |  +-- 10.111.111.255/32 link broadcast
>      |--- 127.0.0.0/8
>      |  |--- 127.0.0.0/31
>      |  |  +-- 127.0.0.0/32 link broadcast
>      |  |  +-- 127.0.0.0/8 host local
>      |  |  +-- 127.0.0.1/32 host local
>      |  +-- 127.255.255.255/32 link broadcast
>      |--- 192.168.1.0/24
>      |  |--- 192.168.1.0/28
>      |  |  +-- 192.168.1.0/32 link broadcast
>      |  |  +-- 192.168.1.9/32 host local
>      |  +-- 192.168.1.255/32 link broadcast
>    <main>:
>    --- 0.0.0.0/0
>      |--- 0.0.0.0/4
>      |  +-- 0.0.0.0/0 universe unicast
>      |  +-- 10.111.111.0/24 link unicast
>      +-- 169.254.0.0/16 link unicast
>      +-- 192.168.1.0/24 link unicast

isn't that a non-back-compatible kernel ABI change?  It might
break pre-existing parsers?

aside: how lame are we to put pretty-printers in the kernel?
English-only ones, at that?  Root cause: kernel developers still
don't have a sufficiently easy way of shipping userspace tools.
