Return-Path: <linux-kernel-owner+w=401wt.eu-S1758680AbXKATAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680AbXKATAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 15:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbXKATAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 15:00:00 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:14183 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbXKAS77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 14:59:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=iBU61Aj/9WpQ1zP8ph1Ocqbb/frLZTGqsoC+V11l0iuNLh9/Uk95i9iVaekzzRvgUQwDpqTVBX8r8pmWd13X+fdM00u+CpuaL8FN4J7Yzc5vFGrhdIDxPJQFf0ePH5oQX5rey7Pl08OQkFSvsUJ/voOApNkbHnR30BIOVgS7+HA=
Message-ID: <3ae72650711011159u53a48ce0ge118427c2107be01@mail.gmail.com>
Date: Thu, 1 Nov 2007 19:59:57 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [PATCH] [sysfs]: make readlink result shorter when the symlink and its target shared some base sysfs subdirectory
Cc: "Denis Cheng" <crquan@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20071031143441.GA7128@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1193826860-6166-1-git-send-email-crquan@gmail.com>
	 <20071031143441.GA7128@suse.de>
X-Google-Sender-Auth: 2f9b29162d4082a8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 31, 2007 3:34 PM, Greg KH <gregkh@suse.de> wrote:
> On Wed, Oct 31, 2007 at 06:34:20PM +0800, Denis Cheng wrote:
> > this is especially useful after /sys/slab introduced, for example:
> >
> > $ ls -l /sys/slab/mm_struct
> > lrwxrwxrwx 1 root root 0 2007-10-31 17:40 /sys/slab/mm_struct -> :0000448
> >
> > instead of:
> >
> > $ ls -l /sys/slab/mm_struct
> > lrwxrwxrwx 1 root root 0 2007-10-31 17:40 /sys/slab/mm_struct -> ../slab/:0000448
> >
> > Signed-off-by: Denis Cheng <crquan@gmail.com>
>
> As pretty as this change is, it's not really necessary, right?
>
> Is there any other place in /sys that would benefit from this?

Yeah:
  ep_81 -> ../../../../../devices/pci0000:00/0000:00:1d.0/usb2/2-0:1.0/usb_endpoint/usbdev2.1_ep81

just becomes:
  ep_81 -> usb_endpoint/usbdev1.1_ep81

which is nice. The current logic always goes back down to the root of sysfs
and moves forward to the target, which in this case prepends the pointless:
  "../../../../../devices/pci0000:00/0000:00:1d.0/usb2/2-0:1.0/" to
the target string.

Kay
