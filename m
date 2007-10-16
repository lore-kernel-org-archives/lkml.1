Return-Path: <linux-kernel-owner+w=401wt.eu-S933128AbXJPNT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933128AbXJPNT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 09:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932326AbXJPNTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 09:19:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:62938 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140AbXJPNTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 09:19:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=uiN8mqFsF/h7jhBp9XzTB+7QnLUCeVDYfHyS0vADT88hw73JkZbPS6L+oRs8tHNAYoeN7Wxv+cOLcWHbds0CdRAiuC49xb2byCqTrVfTe7+6bY+1Jb7mP0Vy2SlaAamrixDILcb7fmTiys1rrBT0YSSUFem95IERNsBm/Qoxjzs=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: In response to kernel compression e-mail a few months ago.
Date: Tue, 16 Oct 2007 14:19:07 +0100
User-Agent: KMail/1.9.1
Cc: Al Viro <viro@ftp.linux.org.uk>, Jan Engelhardt <jengelh@computergmbh.de>,
       linux-kernel@vger.kernel.org, apiszcz@solarrain.com
References: <Pine.LNX.4.64.0710141533080.3935@p34.internal.lan> <20071014205008.GZ8181@ftp.linux.org.uk> <Pine.LNX.4.64.0710141650500.12466@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0710141650500.12466@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710161419.07975.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 October 2007 21:58, Justin Piszcz wrote:
> 
> On Sun, 14 Oct 2007, Al Viro wrote:
> 
> > On Sun, Oct 14, 2007 at 09:46:15PM +0200, Jan Engelhardt wrote:
> >> (Obviously we shall pick .7z)
> >
> > The hell it is.  Take a look at memory footprint of those suckers...
> 
> For compression with -mx=9 it does use 500-900 MiB of RAM, that is true.
> For decompression, 50-70 MiB.

I'm with Al on this. 50 Mb for decompression?
Embedded and small device folks will not love this, I'm sure.
*Maybe* we can use lzma. Seems to use 8Mb on decompression:

  PID   VSZ*VSZRW   RSS (SHR) DIRTY (SHR) STACK COMMAND
30474 10708  8604  8760   392  8360     0     8 lzmacat pld-th-x86_64.tar.lzma

(pld-th-x86_64.tar.lzma is a random 40Mb .lzma file I found on the net)

Sizes in Kb again:

32392 linux-2.6.16.17.tar.7z
33520 linux-2.6.16.17.tar.lzma

P.S. sorting files by extension in tarball generally helps, but in case
of Linux kernel, they are all C code anyway, so no measurable gain there.
--
vda
