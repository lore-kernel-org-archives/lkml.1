Return-Path: <linux-kernel-owner+w=401wt.eu-S1758207AbYDUXZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207AbYDUXZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 19:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264AbYDUXZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 19:25:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35027 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbYDUXZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 19:25:38 -0400
Date: Tue, 22 Apr 2008 00:25:34 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Sparc
Message-ID: <20080421232534.GT27459@ZenIV.linux.org.uk>
References: <20080421.153231.108090227.davem@davemloft.net> <alpine.LFD.1.10.0804211608570.2779@woody.linux-foundation.org> <20080421231815.GS27459@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421231815.GS27459@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 12:18:15AM +0100, Al Viro wrote:

> FWIW, two things I _really_ want dead and gone are
> 	* timod (or full rewrite of that animal; current one is badly racy
> and plays fast and loose with way too many place in VFS guts)
> 	* altroot (use chroot, damnit, and bind whatever you need in there)

BTW, the part about altroot goes for other architectures too; it's badly
broken and it's one hell of an obstacle to fs/namei.c work of any kind.

As absolute minimum we _must_ lose the "if we hadn't found what we wanted
in that subtree, repeat lookup starting at real root"; that's causing
nightmares in pathname resolution and there's no excuse whatsoever for
that since we have bindings.
