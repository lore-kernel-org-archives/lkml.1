Return-Path: <linux-kernel-owner+w=401wt.eu-S1755933AbYKTQ6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbYKTQ6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 11:58:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbYKTQ5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 11:57:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:53082 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbYKTQ5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 11:57:54 -0500
Date: Thu, 20 Nov 2008 08:58:44 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: vm86 segfaults with NX bit
Message-ID: <20081120085844.6f158e08@infradead.org>
In-Reply-To: <s5hmyfu9zl1.wl%tiwai@suse.de>
References: <s5hmyfu9zl1.wl%tiwai@suse.de>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2008 16:39:06 +0100
Takashi Iwai <tiwai@suse.de> wrote:

> Hi,
> 
> X guys reported that VESA driver segfaults in vm86 mode with a kernel
> with CONFIG_X86_PAE, and it turned to be the NX bit.  See Novell
> bugzilla #443440:
> 	https://bugzilla.novell.com/show_bug.cgi?id=443440
> 
> I can confirm that the latest 2.6.28-rc still causes the same problem,
> and it disappears when booted with noexec=off option.
> 
> Also, when NX bit is reset for the first 1MB (or smaller) in
> do_sys_vm86(), it also works as expected.  But I have little clue
> where to restore the bit again.
> 
> Any good suggestions / solutions?
> 

did the code that mapped this memory setup use PROT_EXEC ?


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
