Return-Path: <linux-kernel-owner+w=401wt.eu-S932266AbXIJTCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266AbXIJTCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 15:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754245AbXIJTC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 15:02:26 -0400
Received: from qb-out-0506.google.com ([72.14.204.229]:6902 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbXIJTCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 15:02:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=iBzKUW/jbkIU9nxSNM0BWlnvXAVVAUmQ3+jv38nBLJrAkKtvE4cyfRTuC/uYkiQihWfZXeZ+xqFw1ErzcWYKe0QIWOSxj9Wl6xjah6KWyGtUwlh+Z4iO2hhpNqMvjsL8mMtWTBT7vUSXKjdu6DZ7GiVHekpE52utr1pf9xsF9IM=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 3/3] build system: section garbage collection for vmlinux
Date: Mon, 10 Sep 2007 20:02:15 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
References: <200709051443.21522.vda.linux@googlemail.com> <200709061155.52661.vda.linux@googlemail.com> <20070910120140.GA29077@uranus.ravnborg.org>
In-Reply-To: <20070910120140.GA29077@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709102002.15383.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 September 2007 13:01, Sam Ravnborg wrote:
> > 
> > > Doing a normal kernel build will link vmlinux three or four times.
> > > If we introduce --gc-sections we should add a preparational link of
> > > vmlinux where we use --gc-sections and skip it for the rest of the links
> > > assuming that --gc-sections takes some time for ld to do.
> > 
> > Yes, this will speed up things a bit.
> 
> If we do the --gc-sections trick during the preparational link then we do
> not use the arch supplied linker script.
> Will it be possible to create a dedicated linker script that is valid
> for all architectures and which only include the KEEP() directives for
> the diverse sections?

Unfortunately, -r and --gc-sections don't mix.

x86_64-pc-linux-gnu-ld: --gc-sections and -r may not be used together
--
vda
