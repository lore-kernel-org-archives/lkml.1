Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbZEQKmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbZEQKmm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 06:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbZEQKmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 06:42:33 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:61214 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbZEQKmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 06:42:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=R9pgeL2hBIQ/9DesA9c+FJfs41nfyiQV4CrLIFz8UH0jfz7seU0qcU/UgLJv/jUJnj
         gQ8vneiam0BoSLUh9M9UiQRR/4ZZjdyFO14aLxUwujDwKlNnqlAT6FtbSxye0MPE5VA0
         eqqbLPEYcE5PNTDtMKjG8xW7a8gccsACjYGMA=
Date: Sun, 17 May 2009 12:42:28 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Martin Lottermoser <Martin.Lottermoser@t-online.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PATA DMA problem leading to kernel panic on reading movie DVDs
Message-ID: <20090517104228.GA28605@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@gmail.com>,
	Martin Lottermoser <Martin.Lottermoser@t-online.de>,
	linux-kernel@vger.kernel.org
References: <20090517091224.GA8280@wanza.invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090517091224.GA8280@wanza.invalid>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, May 17, 2009 at 11:12:24AM +0200, Martin Lottermoser wrote:
> Hello,
> 
> newer versions of the Linux kernel overestimate my DVD drive's
> DMA capabilities, leading either to DMA being disabled or a kernel
> panic.
> 
> My setup is:
> 
>   Motherboard: ASUS P4C800-E Deluxe
>     South bridge: ICH5R
>       IDE Interface Controller (PATA): Intel 82801EB/ER (PCI: 8086:24db)
>   DVD drive: Samsung SH-S202N, attached as hdc.
>     There is also an older CD writer (Lite-On LTR-52327S) attached as
>     hdd.
>   Operating system: Debian 5.0.0 with security updates
> 
> On upgrading from Debian 4.0 (Linux 2.6.18) to 5.0 (Linux 2.6.26) I
> found that trying to play movie DVDs with vlc (VideoLAN media player)
> led to DMA being disabled:
> 
>   hdc: cdrom_decode_status: status=0x51 { DriveReady SeekComplete Error }
>   hdc: cdrom_decode_status: error=0x40 { LastFailedSense=0x04 }
>   ide: failed opcode was: unknown
>   <4 more identical groups of these messages>
>   hdc: DMA disabled
>   hdc: ide_intr: huh? expected NULL handler on exit
>   hdc: ATAPI reset complete
> 
> The resulting configuration is too slow to play movies. I booted the
> older kernel and everything was fine.
> 
> I then tested various versions of the Linux kernel where I happened to
> have the original sources. The most interesting results were:
> 
>   2.6.22.9      works, no errors visible in syslog
>   2.6.23.14     works, but syslog shows an error (see below)
>   2.6.24.3	DMA disabled
>   2.6.29.3	Kernel panic: Fatal exception in interrupt (ide_intr)
>                 on trying to open the DVD with vlc

can you catch that kernel panic on another machine through serial
console/netconsole and send it to me, please?

Thanks.

-- 
Regards/Gruss,
    Boris.
