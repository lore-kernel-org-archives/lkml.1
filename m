Return-Path: <linux-kernel-owner+w=401wt.eu-S1756810AbXIESv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810AbXIESv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 14:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754275AbXIESvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 14:51:21 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:17365 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204AbXIESvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 14:51:20 -0400
Subject: Re: [PATCH 0/3] build system: section garbage collection for
	vmlinux
From: Daniel Walker <dwalker@mvista.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: sam@ravnborg.org, kai@germaschewski.name, linux-kernel@vger.kernel.org
In-Reply-To: <200709051937.04014.vda.linux@googlemail.com>
References: <200709051443.21522.vda.linux@googlemail.com>
	 <1189009748.4442.19.camel@imap.mvista.com>
	 <200709051937.04014.vda.linux@googlemail.com>
Content-Type: text/plain
Date: Wed, 05 Sep 2007 11:38:39 -0700
Message-Id: <1189017519.4442.24.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-05 at 19:37 +0100, Denys Vlasenko wrote:
> On Wednesday 05 September 2007 17:29, Daniel Walker wrote:
> > On Wed, 2007-09-05 at 14:43 +0100, Denys Vlasenko wrote:
> > > Build system: section garbage collection for vmlinux
> > > 
> > > 
> > > Newer gcc and binutils can do dead code and data removal
> > > at link time. It is achieved using combination of
> > > -ffunction-sections -fdata-sections options for gcc and
> > > --gc-sections for ld.
> > > 
> > > Theory of operation:
> > > 
> > > Option -ffunction-sections instructs gcc to place each function
> > > (including static ones) in it's own section named .text.function_name
> > > instead of placing all functions in one big .text section.
> > > 
> > > At link time, ld normally coalesce all such sections into one
> > > output section .text again. It is achieved by having *(.text.*) spec
> > > along with *(.text) spec in built-in linker scripts.
> > 
> > You version doesn't work with CONFIG_MODULES right?
> 
> It works with CONFIG_MODULES.

Really? Take a look at this version,

http://lkml.org/lkml/2006/6/4/169

Marcello had to implement a two pass build to add back symbol used in
modules which got removed from the main kernel.. You don't appear to do
that. Marcelo also claims better size reduction than you .

Daniel

