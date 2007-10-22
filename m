Return-Path: <linux-kernel-owner+w=401wt.eu-S1753875AbXJVH1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbXJVH1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 03:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbXJVH1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 03:27:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56297 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbXJVH1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 03:27:16 -0400
Date: Mon, 22 Oct 2007 08:27:09 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>, Nix <nix@esperi.org.uk>,
       Paolo Giarrusso <p.giarrusso@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: [uml-devel] User Mode Linux still doesn't build in 2.6.23-final.
Message-ID: <20071022072709.GZ8181@ftp.linux.org.uk>
References: <200710111754.46854.rob@landley.net> <200710200252.37919.p.giarrusso@gmail.com> <87y7dyhv2u.fsf@hades.wkstn.nix> <20071021114854.GF2455@hacking> <20071021130848.GA4621@c2.user-mode-linux.org> <20071021132031.GI2455@hacking> <20071021154346.GW8181@ftp.linux.org.uk> <20071022043746.GF2998@hacking> <20071022052214.GY8181@ftp.linux.org.uk> <20071022061245.GG2998@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022061245.GG2998@hacking>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 02:12:46PM +0800, WANG Cong wrote:
> I build UML for non-SMP x86. But I don't know about UML_NET_VDE. ;(
> 
> Errors threw out by gcc (too many) are put here:
> 	http://wangcong.org/down/errors.txt
> 
> And my .config is located here:
> 	http://wangcong.org/down/dot_config
> 
> (Errors look like same as without your patch.)

Er...  That patch is on top of the current mainline, including
commit 2b8232ce512105e28453f301d1510de8363bccd1.  Check if what
you are applying it against the recent tree.  By the look of your
build log you are missing
-       $(Q)ln -fsn $(srctree)/include/asm-$(SUBARCH) include/asm-um/arch
+       $(Q)ln -fsn $(srctree)/include/asm-$(HEADER_ARCH) include/asm-um/arch
 else
-       $(Q)cd $(TOPDIR)/include/asm-um && ln -sf ../asm-$(SUBARCH) arch
+       $(Q)cd $(TOPDIR)/include/asm-um && ln -sf ../asm-$(HEADER_ARCH) arch
in arch/um/Makefile.

That, or you simply need to do make mrproper...

