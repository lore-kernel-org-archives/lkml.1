Return-Path: <linux-kernel-owner+w=401wt.eu-S1753915AbXHKEme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbXHKEme (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 00:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbXHKEmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 00:42:24 -0400
Received: from gw03.mail.saunalahti.fi ([195.197.172.111]:57558 "EHLO
	gw03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbXHKEmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 00:42:23 -0400
Date: Sat, 11 Aug 2007 07:42:18 +0300
From: Mikko Rapeli <mikko.rapeli@iki.fi>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: early boot lockup with 2.6.23-rc1
Message-ID: <20070811044218.GA1899@nalle>
References: <20070808223120.GA2286@nalle> <46BAC14E.9040604@zytor.com> <20070809182316.GA2289@nalle> <20070809194348.GA2287@nalle> <46BB94B1.9020307@zytor.com> <20070810163324.GA1916@nalle> <46BC962B.9030209@zytor.com> <20070810192030.GB1916@nalle>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070810192030.GB1916@nalle>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 10:20:31PM +0300, Mikko Rapeli wrote:
> I've bisected thus far, if it helps:

Bisect came to this conclusion:

git-bisect start
# good: [4eb6bf6bfb580afaf1e1a1d30cba17a078530cf4] lots-of-architectures: enable arbitary speed tty support
git-bisect good 4eb6bf6bfb580afaf1e1a1d30cba17a078530cf4
# bad: [773208946a132fb733ba273ee8562814f828cc28] Revert "USB: fix gregkh-usb-usb-use-menuconfig-objects"
git-bisect bad 773208946a132fb733ba273ee8562814f828cc28
# bad: [dc690d8ef842b464f1c429a376ca16cb8dbee6ae] Merge master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6
git-bisect bad dc690d8ef842b464f1c429a376ca16cb8dbee6ae
# good: [15028aad00ddf241581fbe74a02ec89cbb28d35d] [TG3]: Update version to 3.78.
git-bisect good 15028aad00ddf241581fbe74a02ec89cbb28d35d
# bad: [82afee684fe3badaf5ee3fc5b6fda687d558bfb5] Merge master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6
git-bisect bad 82afee684fe3badaf5ee3fc5b6fda687d558bfb5
# bad: [c39736823232bc3ca113c8228fa852c09fba300e] Remove old i386 setup code
git-bisect bad c39736823232bc3ca113c8228fa852c09fba300e
# good: [5be865661516263d90317a6b35b588a2d7c3cb55] String-handling functions for the new x86 setup code.
git-bisect good 5be865661516263d90317a6b35b588a2d7c3cb55
# good: [3b53d3045bbb8ea3c9dce663b102eab0903817c5] MCA support for new x86 setup code
git-bisect good 3b53d3045bbb8ea3c9dce663b102eab0903817c5
# good: [7052fdd890bda0b3904674b69a1d24aec0a10d67] Code for actual protected-mode entry
git-bisect good 7052fdd890bda0b3904674b69a1d24aec0a10d67
# good: [f2d98ae63dc64dedb00499289e13a50677f771f9] Linker script for the new x86 setup code
git-bisect good f2d98ae63dc64dedb00499289e13a50677f771f9
# bad: [91a6c462b02d8dc02dbe95e5a407d78078a38d01] Use the new x86 setup code for x86-64; unify with i386
git-bisect bad 91a6c462b02d8dc02dbe95e5a407d78078a38d01
# bad: [4fd06960f120e02e9abc802a09f9511c400042a5] Use the new x86 setup code for i386
git-bisect bad 4fd06960f120e02e9abc802a09f9511c400042a5


