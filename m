Return-Path: <linux-kernel-owner+w=401wt.eu-S1752598AbXCNRb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbXCNRb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 13:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbXCNRb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 13:31:28 -0400
Received: from smtp.osdl.org ([65.172.181.24]:47220 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598AbXCNRb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 13:31:27 -0400
Date: Wed, 14 Mar 2007 10:30:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ftp.linux.org.uk>
cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/13] fix ps3fb glue allowing a modular build
In-Reply-To: <20070314170720.GL4095@ftp.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0703141016060.9690@woody.linux-foundation.org>
References: <E1HRPbU-0003Ha-Oq@ZenIV.linux.org.uk>
 <Pine.LNX.4.62.0703141040030.28462@pademelon.sonytel.be>
 <20070314160258.GK4095@ftp.linux.org.uk> <Pine.LNX.4.62.0703141715570.28462@pademelon.sonytel.be>
 <20070314170720.GL4095@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Mar 2007, Al Viro wrote:
> 
> Nope.  How can kconfig distinguish that from a boolean option in modular
> driver?  bool *can* depend on tristate and be selected when tristate is
> set to m.

Btw, this is one of those things that easily causes problems.

In many ways it would be nice if we had two different kinds of "bool": one 
where "m" in the dependency chain means "y" is ok, and one where "m" means 
"n".

We used to have "dep_bool" and "dep_mbool" for this, a long time ago. It 
got dropped in the Kconfig language rewrite, and I think it was a mistake.

So I think it would be nice to re-introduce it. As it is, we have a number 
of Kconfig language constructs that are just unnecessarily hard to 
understand, because we end up having to add a "= y" or similar.

The rule *used* to be: "dep_mbool" was a boolean that was valid even for 
modules, while "dep_bool" was a boolean that was valid only for straigth 
"y", and a module would turn it off.

Maybe not "bool" vs "mbool", but it might be nice to have

	bool FB_PS3
		depends strictly on FB

ie a "depends strictly" refuses to upgrade a bool dependency from "m" to 
"y", while a regular depends allows it.

Or something.. The "depends strictly on X" thing would really be just a 
mental shorthand for "depends on (X)=y" (it's actually longer to type, but 
I think it's a bit more intuitive, thus "mental shortcut").

		Linus
