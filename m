Return-Path: <linux-kernel-owner+w=401wt.eu-S932563AbYEULqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563AbYEULqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 07:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758886AbYEULqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 07:46:01 -0400
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1694 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756675AbYEULqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 07:46:00 -0400
Date: Wed, 21 May 2008 13:44:06 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: Adrian Bunk <bunk@kernel.org>
cc: Al Viro <viro@ftp.linux.org.uk>, torvalds@linux-foundation.org,
       geert@linux-m68k.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: -ffreestanding or not -ffreestanding
In-Reply-To: <20080521075233.GA18352@cs181133002.pp.htv.fi>
Message-ID: <Pine.LNX.4.64.0805211326080.19545@localhost.localdomain>
References: <E1JycsB-0000M9-36@ZenIV.linux.org.uk> <20080521075233.GA18352@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 21 May 2008, Adrian Bunk wrote:

> Can we try to get this sorted out properly instead of constantly 
> fiddling with it?
> 
> Currently we use -ffreestanding on some architectures and fix breakages 
> on the other architectures when they arise.

This won't help completely unless you also clean up all archs to use the 
same mappings to the builtin functions.

The main problem I had with -ffreestanding is that it's awkward to map a 
library function to the builtin function and also provide the fallback 
from lib/string.c.
If you look at asm-m68k/string.h I once tried this with the mem* functions 
and I still have the duplicated memcmp in arch/m68k/lib/string.c.
(You could argue that it would be easier to just remove the define for 
memcmp in this specific case, but I'm interested in the general case.)

bye, Roman
