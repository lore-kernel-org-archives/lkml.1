Return-Path: <linux-kernel-owner+w=401wt.eu-S1758100AbYA1Ta3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbYA1Ta3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbYA1TaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:30:16 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:21542 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbYA1TaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:30:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Cqogzyw7Iv5ZPlKOyxQchPCEex0GtYl1K03wE6byHygqoJ0aLfKMV1xoOunw/WMTK3wjE7/mcNdQBUDqGUzh/fJ33bGUAhEWHvQ6gmXmC5mcvZaBq0/dQqbrXOxZkz2fjyCHASMmxhu1nKGHgHDInQ/yt0JenkVy9a2evE9DUXA=
Date: Mon, 28 Jan 2008 22:29:47 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>, Jacob Shin <jacob.shin@amd.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH 2/5] x86: fix runtime error in
	arch/x86/kernel/cpu/mcheck/mce_amd_64.c
Message-ID: <20080128192947.GA6720@cvg>
References: <20080127233751.GA4524@kroah.com> <1201477122-4541-2-git-send-email-gregkh@suse.de> <20080128122434.GA24757@elte.hu> <20080128173706.GA17495@suse.de> <20080128175736.GC22487@elte.hu> <20080128183237.GA19829@suse.de> <20080128190149.GA24424@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128190149.GA24424@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Mon, Jan 28, 2008 at 08:01:49PM +0100]
| 
| * Greg KH <gregkh@suse.de> wrote:
| 
| > > Are kobjects protected against accidental copying? If not add &kobj 
| > > to the 'magic value' too, and check that - it becomes 
| > > copying-resistent that way and has the same cost to check. (which is 
| > > negligible anyway)
| > 
| > Oh, that's a very cool idea, I like it :)
| 
| hey, you are welcome :-)
| 
| [ I guess i should not mention that i've implemented list debugging for 
|   Linux that checksums the struct list contents and stores the checksum 
|   in it (offset by a magic value plus to address of the list head), and 
|   thus protects it against accidental corruption? It was capable of 
|   reliably detecting mixed up list_add() arguments for example, it 
|   detected list corruption of _every_ sort, it detected double
|   list_del() and list_add() of an already active list member as well. It
|   was even capable of detecting SMP races: two parallel unserialized
|   list_del()'s on the same list head were detected and warned about as 
|   well. I guess i should release it one of these days? =B-) ]
| 

interesting... something like hash checks in lockdep?

[...snip...]

		- Cyrill -
