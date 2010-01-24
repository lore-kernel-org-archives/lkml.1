Return-Path: <linux-kernel-owner+w=401wt.eu-S1751892Ab0AXSa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab0AXSa6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 13:30:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678Ab0AXSa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 13:30:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751027Ab0AXSaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 13:30:55 -0500
Date: Sun, 24 Jan 2010 10:30:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Borislav Petkov <petkovbb@googlemail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alex Deucher <alexdeucher@gmail.com>,
       Jerome Glisse <glisse@freedesktop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Linux 2.6.33-rc5
In-Reply-To: <20100124111946.GA4170@liondog.tnic>
Message-ID: <alpine.LFD.2.00.1001241018500.3574@localhost.localdomain>
References: <alpine.LFD.2.00.1001211535360.13231@localhost.localdomain> <20100124111946.GA4170@liondog.tnic>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 24 Jan 2010, Borislav Petkov wrote:
> 
> 1. After suspend, the right monitor shows very funny colors, as if it is
> on crack, in contrast to the left one which looks fine:
> 
> http://userweb.kernel.org/~bp/right_monitor.jpg
> http://userweb.kernel.org/~bp/left_monitor.jpg

Ok, at a guess, it looks like something isn't restoring the palette 
registers for the second output. You didn't say what GPU you have, but 
judging by your CC list, it's a radeon. You might want to let the Radeon 
KMS people know exactly what your setup is etc.

> 2. During suspend I get this juicy lockdep warning:

I'm pretty sure that this is not actually a new problem, it's a new 
warning for an old problem, see commit 846f99749 ("sysfs: Add lockdep 
annotations for the sysfs active reference"). So I'm not considering it a 
regression, even though I do agree that the messages look scary and very 
annoying.

I'm not at all convinced that we are going to be able to fix the problems 
that this made visible in time for 2.6.33. The sysfs-related lock chains 
easily get rather involved, although it is always possible that this 
particular one might be easily fixable (ie if radeon is able to call the 
final kref_put outside any locks - or whatever it is that ends up 
generating a dependency from struct_mutex for the sysfs active ref).

Or maybe I'm misreading the lockdep chain. Eric Biederman added to cc.

		Linus
