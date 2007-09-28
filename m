Return-Path: <linux-kernel-owner+w=401wt.eu-S1757521AbXI1Eiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521AbXI1Eiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 00:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754166AbXI1Eii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 00:38:38 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55557 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbXI1Eii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 00:38:38 -0400
Date: Thu, 27 Sep 2007 21:41:11 -0700
From: Greg KH <greg@kroah.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: tapio.laxstrom@iptime.fi, linux-kernel@vger.kernel.org
Subject: Re: drivers/usb/misc/emi*.c have the biggest data objects in the
	whole tree
Message-ID: <20070928044111.GB24458@kroah.com>
References: <200709141135.35239.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709141135.35239.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 11:35:34AM +0100, Denys Vlasenko wrote:
> Hi Tapio,
> 
> You are the author of these files. Are you still maintaining them?
> If not, do you know who is the current maintainer?
> 
> These two object files hold the biggest data objects in the whole Linux kernel
> after lockdep:
> 
>    text    data     bss     dec     hex filename
>    1258  160516       0  161774   277ee ./drivers/usb/misc/emi26.o
>    1504  209296       0  210800   33770 ./drivers/usb/misc/emi62.o
> 
> Basically, these are big arrays of the following structures:
> 
> typedef struct _INTEL_HEX_RECORD
> {
>         __u32   length;
>         __u32   address;
>         __u32   type;
>         __u8    data[MAX_INTEL_HEX_RECORD_LENGTH];
> } INTEL_HEX_RECORD;
> 
> I suggest the following optimizations:
> 
> Change structure to
> 
> typedef struct _INTEL_HEX_RECORD
> {
>         __u8   type;
>         __u8   length;
>         __u16   address;
>         __u8    data[MAX_INTEL_HEX_RECORD_LENGTH];
> } INTEL_HEX_RECORD __attribute__((__packed__));

Only if you redo the whole firmware image too :)

What is this really hurting?  It's only relevant if you load the
specific module, if you have this device type.  It's a firmware blob,
nothing really interesting at all.

thanks,

greg k-h
