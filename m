Return-Path: <linux-kernel-owner+w=401wt.eu-S932286AbXDPGyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286AbXDPGyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 02:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932332AbXDPGyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 02:54:21 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:31585 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286AbXDPGyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 02:54:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TduXENI8/IjTmxZLM7WF4ZP/lCoEXvr/j6sFsBo8UDIeTdBVN7MwgblSVA586H7+oz6H6og7L9yh0lLGIU03FAuKN+wdvwg4yy3lo0Hn1WPBmZRKdOkCfUe+SpqKQ7lFl9oTKB0rcwV51ditEGdQSWhH+vtLScV4jqDumlSjkYw=
Subject: Re: [2/2] 2.6.21-rc7: known regressions
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Dave Jones <davej@redhat.com>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Richard Purdie <rpurdie@rpsys.net>
In-Reply-To: <20070416062921.GB7528@redhat.com>
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org>
	 <20070416003723.GM3691@stusta.de> <20070416005446.GB21217@redhat.com>
	 <20070416011636.GO3691@stusta.de>  <20070416062921.GB7528@redhat.com>
Content-Type: text/plain
Date: Mon, 16 Apr 2007 14:54:07 +0800
Message-Id: <1176706447.5129.6.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-16 at 02:29 -0400, Dave Jones wrote:
> On Mon, Apr 16, 2007 at 03:16:37AM +0200, Adrian Bunk wrote:
>  > On Sun, Apr 15, 2007 at 08:54:46PM -0400, Dave Jones wrote:
>  > > On Mon, Apr 16, 2007 at 02:37:23AM +0200, Adrian Bunk wrote:
>  > > 
>  > >  > Subject    : ThinkPad X60: resume no longer works  (PCI related?)
>  > >  >              workaround: booting with "hpet=disable"
>  > >  > References : http://lkml.org/lkml/2007/3/13/3
>  > >  > Submitter  : Dave Jones <davej@redhat.com>
>  > >  >              Jeremy Fitzhardinge <jeremy@goop.org>
>  > >  > Caused-By  : PCI merge
>  > >  >              commit 78149df6d565c36675463352d0bfe0000b02b7a7
>  > >  > Handled-By : Eric W. Biederman <ebiederm@xmission.com>
>  > >  >              Rafael J. Wysocki <rjw@sisk.pl>
>  > >  > Status     : unknown
>  > > 

<snip>

> I'll try and narrow down exactly where it's failing in the
> backlight code next, but it's getting late here, so I may
> leave this until tomorrow for further investigation.
> Some other clues for anyone playing along at home:
> This X60 has Intel graphics.  ie, I'm not using any of
> the drivers that 'select FB_BACKLIGHT',

CONFIG_ACPI_VIDEO depends on BACKLIGHT_CLASS_DEVICE, which, in turn is
enabled by FB_BACKLIGHT. So we can narrow it down further, can you try?

CONFIG_FB_BACKLIGHT=y
CONFIG_ACPI_VIDEO=n

Tony


