Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338Ab0A0M3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab0A0M3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 07:29:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215Ab0A0M3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 07:29:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751675Ab0A0M3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 07:29:47 -0500
Date: Wed, 27 Jan 2010 04:28:11 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Chris Wilson <chris@chris-wilson.co.uk>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Roman Jarosz <kedgedev@gmail.com>,
       A Rojas <nqn1976list@gmail.com>,
       "A. Boulan" <arnaud.boulan@libertysurf.fr>, michael@reinelt.co.at,
       jcnengel@googlemail.com, rientjes@google.com, earny@net4u.de,
       linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       stable@kernel.org
Subject: Re: [PATCH] drm/i915: Selectively enable self-reclaim
In-Reply-To: <alpine.LFD.2.00.1001270327580.24253@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1001270419180.24253@localhost.localdomain>
References: <alpine.LFD.2.00.1001270252290.24253@localhost.localdomain> <1264590844-22972-1-git-send-email-chris@chris-wilson.co.uk> <alpine.LFD.2.00.1001270327580.24253@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 27 Jan 2010, Linus Torvalds wrote:
>
> Setting the mapping gfp mask like that is totally wrong. Yes, it looks 
> like you take the 'struct_mutex' lock, but I don't think the page fault 
> does that, does it? So the locking in no way protects other uses of that 
> mapping gfp mask.

Actually, it looks like the gem_fault code _does_ take the lock. So I 
guess it's technically correct. If still really really ugly.

			Linus
