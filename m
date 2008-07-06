Return-Path: <linux-kernel-owner+w=401wt.eu-S1756183AbYGFAL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbYGFAL5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 20:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbYGFALu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 20:11:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35066 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbYGFALu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 20:11:50 -0400
Date: Sun, 6 Jul 2008 01:11:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Frans Pop <elendil@planet.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] parport/ppdev: fix registration of sysctl entries
Message-ID: <20080706001148.GX28946@ZenIV.linux.org.uk>
References: <20080705131924.GA2083@joi> <20080705235148.GW28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080705235148.GW28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 06, 2008 at 12:51:48AM +0100, Al Viro wrote:

> I don't believe that it's right.  Note that if you *do* race there, you
> are fucked regardless of sysctls - ppdev.c::register_device() racing
> with itself will do tons of fun things all by itself (starting with two
> threads allocating different pdev and both setting pp->pdev).
> 
> IOW, *if* that's what we are hitting here, you've only papered over the
> visible symptom.

BTW, with your patch you'll have 100% reproducible double registration if
you do PPCLAIM/PPRELEASE/PPCLAIN on one file descriptor.
