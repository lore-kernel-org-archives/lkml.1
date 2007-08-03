Return-Path: <linux-kernel-owner+w=401wt.eu-S1761919AbXHCDFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761919AbXHCDFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 23:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758952AbXHCDFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 23:05:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39829 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758315AbXHCDFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 23:05:31 -0400
Date: Fri, 3 Aug 2007 08:47:56 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org
Subject: Re: gcc fixed size char array initialization bug - known?
In-Reply-To: <Pine.LNX.4.64.0708022157310.9319@fbirervta.pbzchgretzou.qr>
Message-ID: <alpine.LFD.0.999.0708030841390.23798@enigma.security.iitk.ac.in>
References: <Pine.LNX.4.60.0708022141420.6774@poirot.grange>
 <Pine.LNX.4.64.0708022157310.9319@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 2 Aug 2007, Jan Engelhardt wrote:

> On Aug 2 2007 21:55, Guennadi Liakhovetski wrote:
> > [...]
> >
> >	struct {
> >		char c[4];
> >		int i;
> >	} t;
> >	t.i = 0x12345678;
> >	strcpy(t.c, c);
> >
> >and t.i is silently corrupted. Just wanted to ask if this is known, 
> >really...
> 
> What does this have to do with the kernel? The string "0123" is
> generally _five_ characters long, so c[4] is not enough.
> Or use strncpy.

<nitpicking>

While we're talking of null-termination of strings, then I bet you
generally want to be using strlcpy(), really. Often strncpy() isn't
what you want. Of course, if that buffer isn't a string at all, then
you should be using memfoo() functions and not strbar() ones in the
first place ...
