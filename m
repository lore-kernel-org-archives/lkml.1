Return-Path: <linux-kernel-owner+w=401wt.eu-S1752333AbZHSAJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333AbZHSAJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 20:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbZHSAJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 20:09:35 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53568 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751261AbZHSAJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 20:09:35 -0400
Subject: Re: kernel segv with 2.6.31-rc6 ?
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Roland McGrath <roland@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Helge Deller <deller@gmx.de>,
       linux-parisc <linux-parisc@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20090818050637.4C3E74730F@magilla.sf.frob.com>
References: <4A89CC4D.5040801@gmx.de>
	 <1250549376.7858.96.camel@mulgrave.site>
	 <200908181248.52572.rusty@rustcorp.com.au>
	 <20090818050637.4C3E74730F@magilla.sf.frob.com>
Content-Type: text/plain
Date: Tue, 18 Aug 2009 19:09:24 -0500
Message-Id: <1250640565.15079.3.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[resending, fluffed reply-all]

On Mon, 2009-08-17 at 22:06 -0700, Roland McGrath wrote:
> > I'd be happy to fail to load it.  There might be sysfs issues with it too.
> 
> That sounds reasonable to me.  And I'd be happy to at least look a little
> and maybe give some advice to anybody who finds themself building such a
> (free) module, doesn't know why or how it got that way, and wants to ask.

Actually, for parisc, its not reasonable.  It's expected that our
modules have multiple text sections (we have to use -ffunction-sections
to generate them in order that the PCREL17 jump stubs can be
interleaved).

The problem looks to be that some linker error gave the one of the named
function text sections a duplicate name.  Helge, can you post he objdump
info that shows which section had a duplicate name?

Even with the duplicate name, though, the module should be perfectly
loadable.

James


