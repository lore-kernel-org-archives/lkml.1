Return-Path: <linux-kernel-owner+w=401wt.eu-S1753699AbZA1NJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbZA1NJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 08:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbZA1NJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 08:09:03 -0500
Received: from ozlabs.org ([203.10.76.45]:59719 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbZA1NJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 08:09:01 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: Re: Modversions and long symbol names
Date: Wed, 28 Jan 2009 23:38:56 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <20090120173636.GB24529@mediacenter>
In-Reply-To: <20090120173636.GB24529@mediacenter>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200901282338.56696.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 January 2009 04:06:36 Shawn Bohrer wrote:
> Currently when modversions is enabled the kernel will not load any
> modules that depend on exported symbols with names longer than
> 64 - sizeof(unsigned long) characters.
> 
> This is because the struct modversion_info has the name member set to a
> size of MODULE_NAME_LEN.  This is not the module name this is the symbol
> name so I'm guessing this is a mistake or at least a misused constant.

Yes, it's overloaded.

> Is it possible to increase this size to something more reasonable like
> 512 characters?

Oh, you almost had me.  Almost.

This *looks* like the kind of naive question a newbie would ask.  And a poor coder would simply patch in the increase.  A reasonable coder would also make a comment about the potential bloat.  A good coder would ask why you need more than fifty_five_characters_in_one_single_exported_identifier.

But you're operating on a completely different level!

You chose this example to demonstrate, by (if I may) expandio ad absurdum, that our current approach is flawed.  Obviously you *knew* that it could be converted to a pointer, and equally obviously this would require us to process relocations before parsing version symbols.  Clearly, you understood that this would mean we had to find another solution for struct module versioning, but you knew that that was always the first symbol version anyway.

You no-doubt knew that we could potentially save 7% on our module size using this approach.  But obviously not wanting to criticize my code, you instead chose this oh-so-subtle intimation where I would believe the triumph to be mine alone!

I am humbled by your genius, and I only hope that my patch series approaches the Nirvanic perfection you foresaw.

Kudos Shawn, kudos!
Rusty.
