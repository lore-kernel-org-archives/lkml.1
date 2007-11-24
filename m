Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbXKXVyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbXKXVyn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 16:54:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbXKXVyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 16:54:35 -0500
Received: from osl1smout1.broadpark.no ([80.202.4.58]:63067 "EHLO
	osl1smout1.broadpark.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbXKXVye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 16:54:34 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain
Subject: Re: [PATCH 5/5] lguest: loading bzImage directly
From: Kjartan Maraas <kmaraas@broadpark.no>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Malley <mail@chrismalley.co.uk>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, lguest <lguest@ozlabs.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>
In-reply-to: <1191456175.8268.6.camel@localhost.localdomain>
References: <1191368052.17826.40.camel@localhost.localdomain>
 <1191368106.17826.43.camel@localhost.localdomain>
 <1191368154.17826.44.camel@localhost.localdomain>
 <1191368217.17826.47.camel@localhost.localdomain>
 <1191368399.17826.51.camel@localhost.localdomain>
 <1191368457.17826.53.camel@localhost.localdomain>
 <1191404221.17247.15.camel@feisty>
 <1191456175.8268.6.camel@localhost.localdomain>
Date: Sat, 24 Nov 2007 22:54:10 +0100
Message-id: <1195941250.2369.5.camel@localhost.localdomain>
X-Mailer: Evolution 2.21.2 (2.21.2-2.fc9)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


to., 04.10.2007 kl. 10.02 +1000, skrev Rusty Russell:
> On Wed, 2007-10-03 at 10:37 +0100, Chris Malley wrote:
> > Hi guys
> > 
> > Would it not be clearer to #include <asm/bootparam.h> and use 
> > the relevant named members of struct setup_header / struct boot_params
> > rather than the hard-coded values 0x202, 0x1F1, 0x214 ?
> 
> Yes, but unfortunately bootparam.h wasn't designed to be included from
> userspace.
> 
[snip]

This change seems to have broken build of the battstat applet in
gnome-applets or rather the included apmlib in there. Intended?

Any pointers on how to adapt the code in case it was?

> diff -r 6bb527d113a8 include/linux/apm_bios.h
> --- a/include/linux/apm_bios.h	Wed Oct 03 13:49:31 2007 +1000
> +++ b/include/linux/apm_bios.h	Thu Oct 04 09:37:28 2007 +1000
> @@ -16,28 +16,28 @@
>   * General Public License for more details.
>   */
>  
> +#include <linux/types.h>
> +
> +struct apm_bios_info {
> +	__u16	version;
> +	__u16	cseg;
> +	__u32	offset;
> +	__u16	cseg_16;
> +	__u16	dseg;
> +	__u16	flags;
> +	__u16	cseg_len;
> +	__u16	cseg_16_len;
> +	__u16	dseg_len;
> +};
> +
> +#ifdef __KERNEL__
> +
>  typedef unsigned short	apm_event_t;
>  typedef unsigned short	apm_eventinfo_t;
> -
> -#ifdef __KERNEL__
> -
> -#include <linux/types.h>
>  
>  #define APM_CS		(GDT_ENTRY_APMBIOS_BASE * 8)
>  #define APM_CS_16	(APM_CS + 8)
>  #define APM_DS		(APM_CS_16 + 8)
> -
> -struct apm_bios_info {
> -	u16	version;
> -	u16	cseg;
> -	u32	offset;
> -	u16	cseg_16;
> -	u16	dseg;
> -	u16	flags;
> -	u16	cseg_len;
> -	u16	cseg_16_len;
> -	u16	dseg_len;
> -};
>  
>  /* Results of APM Installation Check */
>  #define APM_16_BIT_SUPPORT	0x0001

Cheers
Kjartan


