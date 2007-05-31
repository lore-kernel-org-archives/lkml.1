Return-Path: <linux-kernel-owner+w=401wt.eu-S1761959AbXEaT47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761959AbXEaT47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 15:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760764AbXEaT4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 15:56:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:46730 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760045AbXEaT4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 15:56:37 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] ACPI Debug - for test, devel and possibly even for production kernels
Date: Thu, 31 May 2007 15:56:17 -0400
User-Agent: KMail/1.9.5
Cc: trenn@suse.de, linux-acpi <linux-acpi@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <1180624839.10908.71.camel@queen.suse.de> <84144f020705311157n6bede2c7ga234d70823d5869f@mail.gmail.com>
In-Reply-To: <84144f020705311157n6bede2c7ga234d70823d5869f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705311556.17966.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 May 2007 14:57, Pekka Enberg wrote:
> On 5/31/07, Thomas Renninger <trenn@suse.de> wrote:
> > (This should efficiently be the same as the proposed big patch a year
> > ago from Pekka Enberg, just a bit smaller and should make ACPICA and
> > kernel/linux people happy:
> > http://marc.info/?l=linux-kernel&m=113699535303722&w=2)
> 
> No, you're keeping these obfuscating macros around:
> 
> +#define return_VOID                     return
> +#define return_ACPI_STATUS(s)           return(s)
> +#define return_VALUE(s)                 return(s)
> +#define return_UINT8(s)                 return(s)
> 
> Making the ACPI code look like regular Linux kernel code (or even
> regular C for that matter) was the whole point of my patch. Your patch
> doesn't change that.

I think that Thomas's point is that he is optimally removing
function tracing via #ifdef.
Your 600KB patch, on the other hand, permanently removed the feature
and touched every file in ACPICA.

The net effect to the user is the same, the ability to enable
ACPI_DEBUG and not enable ACPICA function tracing.

As I probably wrote a year ago, it isn't viable to completely
remove the tracing code --
until Linux reaches a point where vendors certify that their
BIOS is compatible with Linux before they ship, rather than the Linux
community having to debug some Windows-compatible systems into
Linux-compatibility well after they have shipped into the field.

-Len
