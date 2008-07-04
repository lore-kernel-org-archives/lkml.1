Return-Path: <linux-kernel-owner+w=401wt.eu-S1756953AbYGDKyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953AbYGDKyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 06:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbYGDKyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 06:54:10 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:50856 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751714AbYGDKyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 06:54:09 -0400
Date: Fri, 4 Jul 2008 11:54:07 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kconfig question - multiple entries touching one integer
Message-ID: <20080704105407.GD24620@fluff.org.uk>
References: <20080704100829.GC24620@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080704100829.GC24620@fluff.org.uk>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2008 at 11:08:29AM +0100, Ben Dooks wrote:
> I'm trying to produce a Kconfig to deal with allocating
> extra resources depending on what is selected. I'd like
> to have an integer which specifies the 
> 
> ie:
> 
> config ARCH_EXTRA_RESOURCES
> 	int
> 	default 0
> 	help
> 	  Extra resources depending on the board selected
> 
> ...
> 
> config BOARD_A
> 	set ARCH_EXTRA_RESOURCES 32
> 
> config BOARD_B
> 	set ARCH_EXTRA_RESOURCES 64
> 
> in this example, if board A is selected, then ARCH_EXTRA_RESOURCES
> would be 32, if BOARD_B is selected then it would be 64.
> 
> doing
> 
> 	config ARCH_EXTRA_RESOURCES
> 	int
> 	default 0
> 	default 32 if BOARD_A
> 	default 64 if BOARD_B
> 
> doesn't work, and involves changing this part of the Kconfig
> every time a new board is added.
> 
> Is there any current way of doing this, would there be any
> objections to having some form of 'set' clause in a config
> statememt?

Currently, the rather crufty approach is to do:

config ARCH_EXTRA_RESOURCES_32
	bool

config ARCH_EXTRA_RESOURCES_64
	bool

config BOARD_A
	select ARCH_EXTRA_RESOURCES_32

config BOARD_B
	select ARCH_EXTRA_RESOURCES_64

and have the following in the header file:

#ifdef ARCH_EXTRA_RESOURCES_64
#define ARCH_EXTRA_RESOURCES 64
#elif defined(ARCH_EXTRA_RESOURCES_32)
#define ARCH_EXTRA_RESOURCES 32
#else
#define ARCH_EXTRA_RESOURCES 0
#endif

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
