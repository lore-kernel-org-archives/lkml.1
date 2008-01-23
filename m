Return-Path: <linux-kernel-owner+w=401wt.eu-S1752861AbYAWLJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbYAWLJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 06:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbYAWLJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 06:09:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36270 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbYAWLJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 06:09:06 -0500
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove BKL from sysctl(2)
References: <20080122202727.GB1975@martell.zuzino.mipt.ru>
	<20080123105140.3406e25b@lxorguk.ukuu.org.uk>
From: Andi Kleen <andi@firstfloor.org>
Date: 23 Jan 2008 12:09:05 +0100
In-Reply-To: <20080123105140.3406e25b@lxorguk.ukuu.org.uk>
Message-ID: <p73k5m0lrxq.fsf@crumb.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> 
> There are cases that updating the corepath name and dumping a core at the
> same moment can result in the wrong thing being exec()'d or a file being
> opened which is a mix of the old and new name and could go anywhere.
> 
> I see two variants on your patch that work
> 
> #1	Replace the lock_kernel with a sysctl_update mutex and fix both
> paths
> #2	Add locking specifically to the corename path

Doesn't that apply to pretty much all proc_dostring users, not just
corename? 

Some of them might be already broken if their readers don't take BKL.
Also possibly some of the proc_dointvec for multiple numbers.

-Andi
