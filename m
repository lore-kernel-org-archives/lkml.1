Return-Path: <linux-kernel-owner+w=401wt.eu-S1754983AbXHUFJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbXHUFJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 01:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750826AbXHUFJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 01:09:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33002 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750805AbXHUFJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 01:09:22 -0400
Date: Mon, 20 Aug 2007 22:08:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Satyam Sharma <satyam@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, wbrana@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][bugzilla #8679] therm_throt.c: Fix section mismatch
Message-Id: <20070820220847.014d30ae.akpm@linux-foundation.org>
In-Reply-To: <20070820220328.438e8a4d.akpm@linux-foundation.org>
References: <alpine.LFD.0.999.0708211003390.2774@enigma.security.iitk.ac.in>
	<20070820220328.438e8a4d.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2007 22:03:28 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> register_hotcpu_notifier() is cunning.  If CONFIG_HOTPLUG_CPU=y, we need
> the notifier block and the function to which it points to be in .data and
> in .text.  If CONFIG_HOTPLUG_CPU=n, we don't need them to be present at all.
> 
> So what we can do is to just leave the notifier block in .data and the
> function in .text and then the compiler/linker will notice that nothing
> references them and they will be omitted at build time.

As long as the notifier block and the function are static.  I don't think
the toolchain is smart enough to remove them if they have global scope,
but I didn't check this..
