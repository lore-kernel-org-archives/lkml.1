Return-Path: <linux-kernel-owner+w=401wt.eu-S932422AbXAVUbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422AbXAVUbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 15:31:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932186AbXAVUbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 15:31:51 -0500
Received: from an-out-0708.google.com ([209.85.132.240]:28602 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932422AbXAVUbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 15:31:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=O2caD9Hz9UvIcALEticftZZrFEsDunqgjAOK/9u9uBIzIVm6F9jZrHxSeLvmb4EMRnUqrxWzFECH07ZjIMy9Ks3/OCBG4REfrAiPOL3ox2ucSE3gy6lwHYCy7xsN+vNRFccg1HiBYCnfweFha39qusW8D6HkGphlDU7r3euhjUc=
Message-ID: <9e0cf0bf0701221231sc638114j2f0123650ffc14ea@mail.gmail.com>
Date: Mon, 22 Jan 2007 22:31:48 +0200
From: "Alon Bar-Lev" <alon.barlev@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>
Subject: Re: [patch 03/26] Dynamic kernel command-line - arm
Cc: "Russell King" <rmk+lkml@arm.linux.org.uk>, tom@dbservice.com,
       bwalle@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <20070122115650.d0be8bd3.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070118125849.441998000@strauss.suse.de>
	 <20070118130028.719472000@strauss.suse.de>
	 <20070118141359.GB31418@flint.arm.linux.org.uk>
	 <45AF92E7.50901@dbservice.com>
	 <20070118152326.GC31418@flint.arm.linux.org.uk>
	 <20070122115650.d0be8bd3.akpm@osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

Can I do anything more in order to be closer to merge?
Some general comments... or should I CC other people etc...
I submitted this several times but got almost no architecture to ACK.

I just don't know how we can progress with this issue... All we wanted
is to break the 256 limit in x86...

Best Regards,
Alon Bar-Lev.

On 1/22/07, Andrew Morton <akpm@osdl.org> wrote:
> > On Thu, 18 Jan 2007 15:23:26 +0000 Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> > On Thu, Jan 18, 2007 at 04:31:51PM +0100, Tomas Carnecky wrote:
> > > Russell King wrote:
> > > > On Thu, Jan 18, 2007 at 01:58:52PM +0100, Bernhard Walle wrote:
> > > >> -static char command_line[COMMAND_LINE_SIZE];
> > > >> +static char __initdata command_line[COMMAND_LINE_SIZE];
> > > >
> > > > Uninitialised data is placed in the BSS.  Adding __initdata to BSS
> > > > data causes grief.
> > > >
> > >
> > > Static variables are implicitly initialized to zero. Does that also
> > > count as initialization?
> >
> > No.  As I say, they're placed in the BSS.  The BSS is zeroed as part of
> > the C runtime initialisation.
>
> I don't understand the objection.  With the above change, command_line[]
> will end up consuming COMMAND_LINE_SIZE bytes of .data.init and will be
> reliably initialized to all-zeros by the compiler (won't it?)
>
> > If you want to place a variable in a specific section, it must be
> > explicitly initialised.  Eg,
> >
> > static char __initdata command_line[COMMAND_LINE_SIZE] = "";
> >
> > However, there is a bigger question here: that is the tradeoff between
> > making this variable part of the on-disk kernel image, but throw away
> > the memory at runtime, or to leave it in the BSS where it will not be
> > part of the on-disk kernel image, but will not be thrown away at
> > runtime.
>
> Yes, it'll take some space in vmlinux.  We could perhaps create a new
> __initbss to prevent that, I assume.
>
>
