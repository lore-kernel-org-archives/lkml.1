Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbXHPUD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbXHPUD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 16:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbXHPUDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 16:03:43 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:33166 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758014AbXHPUDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 16:03:41 -0400
Date: Thu, 16 Aug 2007 22:04:55 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Andrew Morton <akpm@osdl.org>,
       stable@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Alberto Pires de Oliveira Neto <apon1@terra.com.br>, giedrius@su.lt
Subject: Re: [PATCH] UML - Add a .note.SuSE section
Message-ID: <20070816200455.GA14424@uranus.ravnborg.org>
References: <20070816162428.GA8128@c2.user-mode-linux.org> <1187281856.2663.0.camel@laptopd505.fenrus.org> <20070816192639.GA8957@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070816192639.GA8957@c2.user-mode-linux.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2007 at 03:26:39PM -0400, Jeff Dike wrote:
> 
> The crash is in this section:
> 
>   __uml_setup_start = .;
>   .uml.setup.init : { *(.uml.setup.init) }
>   __uml_setup_end = .;

This looks like a classic bug.
You wanted this:
.uml.setup.init : {
	__uml_setup_start = .;
	*(.uml.setup.init)
	__uml_setup_end = .;
}

In this way you are sure __uml_setup_start has same address as start
of section.
With the original code the linker will align the .uml.setup.init section
to the alignment required by the included sections and thus
the label and the actual start address may differ.

	Sam
