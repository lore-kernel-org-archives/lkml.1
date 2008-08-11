Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbYHKXt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbYHKXt2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 19:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757276AbYHKXtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 19:49:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37974 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757136AbYHKXtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 19:49:13 -0400
Date: Mon, 11 Aug 2008 16:48:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: rene.herman@keyaccess.nl, akpm@linuxfoundation.org, fritz@isdn4linux.de,
       kkeil@suse.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] ISDN: make ICN not auto-grab port 0x320
Message-Id: <20080811164814.db41c20b.akpm@linux-foundation.org>
In-Reply-To: <20080809215020.1bb602e7@lxorguk.ukuu.org.uk>
References: <489DD669.2090207@keyaccess.nl>
	<20080809215020.1bb602e7@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Aug 2008 21:50:20 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Sat, 09 Aug 2008 19:39:53 +0200
> Rene Herman <rene.herman@keyaccess.nl> wrote:
> 
> > Grabbing ISA bus resources without anything or anyone telling us we
> > should can break boot on randconfig/allyesconfig builds by keeping
> > resources that are in fact owned by different hardware busy and does
> > as reported by Ingo Molnar.
> 
> Not an interesting case, and also wrong in the modular case where loading
> the module is a direct user action indicating clear intent to use the
> functionality *as is*.
> 
> NAK this one too.
> 
> At the very least make the requirement to say "like please run for real"
> dependant on it not being built modular - which is what was done for the
> last ones that were twiddled to keep Ingo amused.
> 

otoh it's a bit sad to break allyesconfig kernels - there is
regression-testing value in being able to run such kernels.

I wonder if we can add a new boot option `allyesconfig-test' or
something like that, and then, within the offending drivers, test that
flag and take suitable avoiding action.

Or we could do it at compile-time - define
CONFIG_ALLYESCONFIG_TESTING in some fashion.

