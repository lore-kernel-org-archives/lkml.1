Return-Path: <linux-kernel-owner+w=401wt.eu-S1756295AbXFDObc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295AbXFDObc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 10:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbXFDObM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 10:31:12 -0400
Received: from ns2.suse.de ([195.135.220.15]:48503 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbXFDObH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 10:31:07 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [AppArmor 38/45] AppArmor: Module and LSM hooks
Date: Mon, 4 Jun 2007 16:30:49 +0200
User-Agent: KMail/1.9.5
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20070514110607.549397248@suse.de> <200706041342.42178.agruen@suse.de> <20070604131242.GE1971@elf.ucw.cz>
In-Reply-To: <20070604131242.GE1971@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706041630.49316.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 June 2007 15:12, Pavel Machek wrote:
> How will kernel work with very long paths? I'd suspect some problems,
> if path is 1MB long and I attempt to print it in /proc
> somewhere.

Pathnames are only used for informational purposes in the kernel, except in 
AppArmor of course. /proc only uses pathnames in a few places, 
but /proc/mounts will silently fail and produce garbage entries. That's not 
ideal of course; we should fix that somehow.

Note that this has nothing to do with the AppArmor discussion ...

> Perhaps vfs should be modified not to allow such crazy paths? But placing
> limit in aa is ugly. 

Dream on. Redefining fundamental vfs semantics is not an option; we should 
rather make sure that we fail gracefully. Considering the alternatives, I 
still prefer the configurable limit. That's way more useful than allowing a 
process to DOS the kernel with AppArmor.

Andreas
