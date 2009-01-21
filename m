Return-Path: <linux-kernel-owner+w=401wt.eu-S1760007AbZAUFwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007AbZAUFwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 00:52:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbZAUFwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 00:52:16 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:48407 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbZAUFwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 00:52:15 -0500
Date: Wed, 21 Jan 2009 06:53:56 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>, axboe@kernel.dk
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Size of sector_t in userspace [Was: fix 41 'make headers_check' warnings]
Message-ID: <20090121055356.GA26731@uranus.ravnborg.org>
References: <1232273454.23100.9.camel@localhost.localdomain> <20090118110221.GA29602@elte.hu> <1232501276.3123.49.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232501276.3123.49.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens.

In an attempt to fix some of the issues in our exported Headers jsr
encountered some strange stuff in types.h.

types.h is exported to userspace where we do not have access to CONFIG_*
symbols.
Despite this we use CONFGI_LBD to decide the size of sector_t like this:

#ifdef CONFIG_LBD
typedef u64 sector_t;
typedef u64 blkcnt_t;
#else
typedef unsigned long sector_t;
typedef unsigned long blkcnt_t;
#endif

But as CONFIG_LBD is never defined in userspace sector_t is now 32
bit on 32 bit boxes and 64 bit on 64 bit boxes (in userspace).

Is sector:t (and the companion blkcnt_t) really used by userspace?
If it is - what size is it expected to have?

	Sam
