Return-Path: <linux-kernel-owner+w=401wt.eu-S933554AbXIUW4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933554AbXIUW4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932629AbXIUWnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:43:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:34479 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932754AbXIUWnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:43:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=RJQOQjNcjvV7sH1qlBGopTwd0ha5tYAitzshAXZ9s0RAbPTCVcFC4KNN0PutIWeZdIxl0B4pPQ5njcbspy19BsAZGcIAfLBhqYGT4tXomk7ofuQazkvJU3xkkRrleKmRaetrdFin/CIdD8ZbS6hXVIGGjlvDFBENbUEQdVFIeMc=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Krzysztof Oledzki <olel@ans.pl>
Subject: Re: [PATCH 1/2] bnx2: factor out gzip unpacker
Date: Fri, 21 Sep 2007 23:43:40 +0100
User-Agent: KMail/1.9.1
Cc: Valdis.Kletnieks@vt.edu, David Miller <davem@davemloft.net>,
       jeff@garzik.org, mchan@broadcom.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
References: <200709211201.24475.vda.linux@googlemail.com> <200709212018.06553.vda.linux@googlemail.com> <Pine.LNX.4.64.0709212130490.11228@bizon.gios.gov.pl>
In-Reply-To: <Pine.LNX.4.64.0709212130490.11228@bizon.gios.gov.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709212343.41160.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 September 2007 20:33, Krzysztof Oledzki wrote:
> 
> On Fri, 21 Sep 2007, Denys Vlasenko wrote:
> 
> > On Friday 21 September 2007 19:36, Valdis.Kletnieks@vt.edu wrote:
> >> On Fri, 21 Sep 2007 19:05:23 BST, Denys Vlasenko said:
> >>
> >>> I plan to use gzip compression on following drivers' firmware,
> >>> if patches will be accepted:
> >>>
> >>>    text    data     bss     dec     hex filename
> >>>   17653  109968     240  127861   1f375 drivers/net/acenic.o
> >>>    6628  120448       4  127080   1f068 drivers/net/dgrs.o
> >>>          ^^^^^^
> >>
> >> Should this be redone to use the existing firmware loading framework to
> >> load the firmware instead?
> >
> > Not in every case.
> >
> > For example, bnx2 maintainer says that driver and
> > firmware are closely tied for his driver. IOW: you upgrade kernel
> > and your NIC is not working anymore.
>
> Firmware may come with a kernel. We have a "install modules", we can also 
> add "install firmware".

Install where? I boot my machine over NFS, and it has no hard drive.

> > Another argument is to make kernel be able to bring up NICs
> > without needing firmware images in initramfs/initrd/hard drive.
> 
> It is not possible to bring up things like FC or WiFi without firmware, 
> what special is in classic NICs?

Nothing.

It is just not (yet?) decreed from The Very Top that all and every
firmware image should be loaded using request_firmware().

Also people may want to gzip something else than firmware.
--
vda
