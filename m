Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbZEOQEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbZEOQEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 12:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756048AbZEOQEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 12:04:07 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34160 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755154AbZEOQEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 12:04:06 -0400
Subject: RE: [RFQ] New driver architecture questions
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Mukker, Atul" <Atul.Mukker@lsi.com>
Cc: Jeff Garzik <jeff@garzik.org>, Julian Calaby <julian.calaby@gmail.com>,
       adam radford <aradford@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Austria, Winston" <Winston.Austria@lsi.com>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
In-Reply-To: <6C678488C5CEE74F813A4D1948FD2DC7A96C7789@cosmail02.lsi.com>
References: <6C678488C5CEE74F813A4D1948FD2DC7A95E6D37@cosmail02.lsi.com>
	 <4A0B858F.3080405@garzik.org>
	 <6C678488C5CEE74F813A4D1948FD2DC7A95E6D38@cosmail02.lsi.com>
	 <4A0B9B0D.6080006@garzik.org>
	 <b1bc6a000905141758y20aa7852h8b1012e3da6f8c0f@mail.gmail.com>
	 <646765f40905141801k5ae6249p925a4a377652c62e@mail.gmail.com>
	 <4A0CDB27.6090009@garzik.org>
	 <6C678488C5CEE74F813A4D1948FD2DC7A96C7789@cosmail02.lsi.com>
Content-Type: text/plain
Date: Fri, 15 May 2009 12:04:04 -0400
Message-Id: <1242403444.14252.3.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-15 at 08:56 -0600, Mukker, Atul wrote: 
> >>
> > >> Perhaps this is a bad example?  It seems like the "common layer"
> > >> sections that are "cross-OS" shouldn't contain any Linux specific code
> > at all.
> > >
> > > I think the implication is that the cross-OS parts are coded, as it
> > > happens, in the linux coding style, using linux functions, but then a
> > > Windows layer maps these to Windows specific functions.
> > 
> > Correct.
> > 
> > 	Jeff
> > 
> > 
> > 
> [Atul] I think we are close, for example, memcpy API in the stack is
> osi_memcpy(), which translates to memcpy() on Linux and
> ScsiPortMoveMemory() on windows.

So what we really don't want to see in Linux drivers is the particular
name you've chosen for your glue layer API (like osi_mempy).  The way
you get around this is to run a macro substituter over the HIM before
you put it in the kernel, so the API logic all appears to be linux
specific, even though it's translated from your generic HIM.   This adds
a bit of a burden sometimes in patching because you have to translate
back to the HIM to apply the patch, but this can be largely automated.

James


