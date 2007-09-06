Return-Path: <linux-kernel-owner+w=401wt.eu-S1755735AbXIFK42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbXIFK42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 06:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755631AbXIFK4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 06:56:00 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:22464 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303AbXIFKz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 06:55:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=CsbGpg4lmiKP6/WqOJUH8jI1lt8nJLEzQEs9rakqkni245eEQW46VKjSszU4mvhz/iBM0og8wIS2ONVhNxMQtUyYCmXpx4DK7Cl7cTza+N6+9m0FONIslnttlKr2aN0b+H2P3k5FHyUJE4CVcabCbq6JfqRLTLV7k0/eJDGIhUM=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 3/3] build system: section garbage collection for vmlinux
Date: Thu, 6 Sep 2007 11:55:52 +0100
User-Agent: KMail/1.9.1
Cc: kai@germaschewski.name, linux-kernel@vger.kernel.org
References: <200709051443.21522.vda.linux@googlemail.com> <200709051940.15653.vda.linux@googlemail.com> <20070905204628.GE30812@uranus.ravnborg.org>
In-Reply-To: <20070905204628.GE30812@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709061155.52661.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 September 2007 21:46, Sam Ravnborg wrote:
> On Wed, Sep 05, 2007 at 07:40:15PM +0100, Denys Vlasenko wrote:
> > On Wednesday 05 September 2007 14:55, Denys Vlasenko wrote:
> > > Part 3:
> > > 
> > > Makefile:
> > > init/Kconfig:
> > >   add config DISCARD_UNUSED_SECTIONS with appropriate
> > >   big scary warning. It enables gcc and ld options
> > >   for section garbage collection.
> > 
> > At it typically happens, last-minute "obviously correct" change was a mistake.
> > 
> > This doesn't work as intended:
> > 
> > LDFLAGS_vmlinux += $(call ld-option, --gc-sections)
> > 
> > With the above line, --gc-sections doesn't get added,
> > and vmlinux is not garbage collected.

> Did you find out why it does not work?

ld-option is designed to test whether -Wl,-Wsomething will work
on gcc commandline. I am adding --gc-sections to ld commandline.

> > 
> > It must be
> > 
> > LDFLAGS_vmlinux += --gc-sections

> Doing a normal kernel build will link vmlinux three or four times.
> If we introduce --gc-sections we should add a preparational link of
> vmlinux where we use --gc-sections and skip it for the rest of the links
> assuming that --gc-sections takes some time for ld to do.

Yes, this will speed up things a bit.

However, for me build time is totally dominated by CC stages, not LD.
I don't have 32 core CPU yet :(
--
vda
