Return-Path: <linux-kernel-owner+w=401wt.eu-S1760212AbYJIRVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760212AbYJIRVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 13:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756797AbYJIRUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 13:20:54 -0400
Received: from xenotime.net ([66.160.160.81]:56941 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754911AbYJIRUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 13:20:54 -0400
Date: Thu, 9 Oct 2008 10:20:49 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Yinghai Lu" <yinghai@kernel.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: mtrr_cleanup update command line
Message-Id: <20081009102049.c22cf670.rdunlap@xenotime.net>
In-Reply-To: <86802c440810081828m2b9210e6y81503bdffe12fb03@mail.gmail.com>
References: <1222817380-29481-1-git-send-email-yhlu.kernel@gmail.com>
	<20080930165739.7847be37.rdunlap@xenotime.net>
	<20081008170751.6d86b8e2.rdunlap@xenotime.net>
	<86802c440810081828m2b9210e6y81503bdffe12fb03@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Oct 2008 18:28:39 -0700 Yinghai Lu wrote:

> On Wed, Oct 8, 2008 at 5:07 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> > On Tue, 30 Sep 2008 16:57:39 -0700 Randy Dunlap wrote:
> >
> > BTW, this comment is alread in Documentation/kernel-parameters.txt, at the top of the file:
> 
> oh...
> 
> >
> > The following is a consolidated list of the kernel parameters as implemented
> > (mostly) by the __setup() macro and sorted into English Dictionary order
> > (defined as ignoring all punctuation and sorting digits before letters in a
> > case insensitive manner), and with descriptions where known.
> >
> >
> how about
> 
> like to filter out disable, enable, no, etc...

I don't think that mtrr gets any special treatment here.
All "acpi" parameters are not grouped together (unless they begin with
"acpi").  All "apic" parameters are not grouped together.
All "*iommu*" parameters are not grouped together....


> diff --git a/Documentation/kernel-parameters.txt
> b/Documentation/kernel-parameters.txt
> index 4b9ee9b..782e2b0 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -620,35 +620,6 @@ and is between 256 and 4096 characters. It is
> defined in the file
>                         See drivers/char/README.epca and
>                         Documentation/digiepca.txt.
> 
> -       disable_mtrr_cleanup [X86]
> -       enable_mtrr_cleanup [X86]
> -                       The kernel tries to adjust MTRR layout from continuous
> -                       to discrete, to make X server driver able to add WB
> -                       entry later. This parameter enables/disables that.
> -
> -       mtrr_chunk_size=nn[KMG] [X86]
> -                       used for mtrr cleanup. It is largest continous chunk
> -                       that could hold holes aka. UC entries.
> -
> -       mtrr_gran_size=nn[KMG] [X86]
> -                       Used for mtrr cleanup. It is granularity of mtrr block.
> -                       Default is 1.
> -                       Large value could prevent small alignment from
> -                       using up MTRRs.
> -
> -       mtrr_spare_reg_nr=n [X86]
> -                       Format: <integer>
> -                       Range: 0,7 : spare reg number
> -                       Default : 1
> -                       Used for mtrr cleanup. It is spare mtrr entries number.
> -                       Set to 2 or more if your graphical card needs more.
> -
> -       disable_mtrr_trim [X86, Intel and AMD only]
> -                       By default the kernel will trim any uncacheable
> -                       memory out of your available memory pool based on
> -                       MTRR settings.  This parameter disables that behavior,
> -                       possibly causing your machine to run very slowly.
> -
>         dmasound=       [HW,OSS] Sound subsystem buffers
> 
>         dscc4.setup=    [NET]
> @@ -1310,6 +1281,35 @@ and is between 256 and 4096 characters. It is
> defined in the file
>                         [HW] Make the MicroTouch USB driver use raw coordinates
>                         ('y', default) or cooked coordinates ('n')
> 
> +       disable_mtrr_cleanup [X86]
> +       enable_mtrr_cleanup [X86]
> +                       The kernel tries to adjust MTRR layout from continuous
> +                       to discrete, to make X server driver able to add WB
> +                       entry later. This parameter enables/disables that.
> +
> +       mtrr_chunk_size=nn[KMG] [X86]
> +                       used for mtrr cleanup. It is largest continous chunk
> +                       that could hold holes aka. UC entries.
> +
> +       mtrr_gran_size=nn[KMG] [X86]
> +                       Used for mtrr cleanup. It is granularity of mtrr block.
> +                       Default is 1.
> +                       Large value could prevent small alignment from
> +                       using up MTRRs.
> +
> +       mtrr_spare_reg_nr=n [X86]
> +                       Format: <integer>
> +                       Range: 0,7 : spare reg number
> +                       Default : 1
> +                       Used for mtrr cleanup. It is spare mtrr entries number.
> +                       Set to 2 or more if your graphical card needs more.
> +
> +       disable_mtrr_trim [X86, Intel and AMD only]
> +                       By default the kernel will trim any uncacheable
> +                       memory out of your available memory pool based on
> +                       MTRR settings.  This parameter disables that behavior,
> +                       possibly causing your machine to run very slowly.
> +
>         n2=             [NET] SDL Inc. RISCom/N2 synchronous serial card
> 
>         NCR_D700=       [HW,SCSI]
> 


---
~Randy
