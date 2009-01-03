Return-Path: <linux-kernel-owner+w=401wt.eu-S932525AbZACQ70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525AbZACQ70 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 11:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759127AbZACQ7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 11:59:17 -0500
Received: from one.firstfloor.org ([213.235.205.2]:52513 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbZACQ7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 11:59:16 -0500
Date: Sat, 3 Jan 2009 18:12:55 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kbuild@vger.kernel.org,
       sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/3] KBUILD: Add script to manipulate .config files on the command line
Message-ID: <20090103171255.GO496@one.firstfloor.org>
References: <20090103321.351399938@firstfloor.org> <200901031154.44868.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901031154.44868.arnd@arndb.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 03, 2009 at 11:54:44AM +0100, Arnd Bergmann wrote:
> > I extracted most of the CONFIG manipulation code from one of my
> > build scripts into a new shell script scripts/config
> 
> This looks very useful, thanks for sharing.
> 
> > The script is not integrated with the normal Kconfig machinery
> > and doesn't do any checking against Kconfig files, but just manipulates
> > that text format. This is always done at make time anyways.
> 
> Why? I would imagine it to be useful to get immediate feedback
> whether changing the option was successful. It should be easy to
> run scripts/kconfig/conf -o on the config file afterwards.

Mostly so that the script doesn't need to know about the source
directory. That would be another argument, making it harder to use. 
At least my build scripts often run in a different environment. And
make always checks it anyways.

Also I wasn't sure how to change the filename of the config file
without using Kconfig internals.  That would be less of a concern
now if it was merged, but it was one out of tree.

> 
> My normal workflow when changing single options is to remove the
> line from .config and call make oldconfig again. What I would
> like to see most here is something like
> 
> ./scripts/config --reconfigure smp
> Remove SMP from .config, and do oldconfig to ask again.

You don't need the make oldconfig, make always does that automatically.

BTW there's an undocumented option to do this, but I intentionally
didn't document it because it doesn't work with --file due to the
reasons stated above.

-Andi

-- 
ak@linux.intel.com
