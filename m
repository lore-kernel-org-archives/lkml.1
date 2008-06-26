Return-Path: <linux-kernel-owner+w=401wt.eu-S1761536AbYFZSZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761536AbYFZSZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbYFZSZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:25:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424AbYFZSZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:25:17 -0400
Date: Thu, 26 Jun 2008 14:18:41 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Mikael Pettersson <mikpe@it.uu.se>, Bernhard Walle <bwalle@suse.de>,
       x86@kernel.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       yhlu.kernel@gmail.com
Subject: Re: [PATCH 1/2] Add /sys/firmware/memmap
Message-ID: <20080626181841.GE3878@redhat.com>
References: <1214423826-12628-1-git-send-email-bwalle@suse.de> <1214423826-12628-2-git-send-email-bwalle@suse.de> <20080625224301.GE32344@redhat.com> <18531.20387.111875.576837@harpo.it.uu.se> <20080626104524.2d7ed1ab@halley.suse.de> <18531.23894.572847.322265@harpo.it.uu.se> <4863D930.2040300@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4863D930.2040300@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 11:00:16AM -0700, H. Peter Anvin wrote:
> Mikael Pettersson wrote:
>> Bernhard Walle writes:
>>  > > It should be configurable. Whether it's done via CONFIG_KEXEC or its own
>>  > > option I don't care.
>>  >  > Ok, changed:
>>  >  > diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
>>  > index 1008737..73fcc59 100644
>>  > --- a/drivers/firmware/Kconfig
>>  > +++ b/drivers/firmware/Kconfig
>>  > @@ -28,7 +28,7 @@ config EDD_OFF
>>  >   >  config FIRMWARE_MEMMAP
>>  >      def_bool y
>>  > -    depends on X86_64 || X86_32
>>  > +    depends on (X86_64 || X86_32) && KEXEC
>>  >   >  config EFI_VARS
>>  >         tristate "EFI Variable Support via sysfs"
>>
>> Yep, thanks.
>>
>
> Making this depend on KEXEC would be most unfortunate.  This is valuable  
> information for finding all kinds of issues even in the absence of KEXEC.
>

Agreed.

> I really don't see a point in making this configurable, except perhaps  
> under CONFIG_EMBEDDED.

I think we should just not put this functionality under any CONFIG option.
If we put it under CONFIG_EMBEDDED,  then even for using kexec, one
shall have to turn CONFIG_EMBEDDED on which probably does not make much
sense.

Thanks
Vivek
