Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbZCLM3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbZCLM3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 08:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755094AbZCLM3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 08:29:10 -0400
Received: from mail-bw0-f178.google.com ([209.85.218.178]:53212 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242AbZCLM3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 08:29:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Q5jCOVH1rmiLXUCUSylJxsssc6W0/xbpQJaGIBR1hihMb/cx61X6X6TvLrW599MNSD
         FzpW4P6yVv8Gu+kaRYqec7fPQCmk9y6wtnYOBKMSV0mgOiauJ2j4V/dz3JJRu1kydQ3R
         ld6HKxBiTzPa1PoP1Gsja/DKdjV58mTvhWWmU=
Subject: Re: [PATCH] x86: mtrr: don't modify RdDram/WrDram bits of fixed
 MTRRs
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, trenn@suse.de
In-Reply-To: <20090312114121.GF20716@alberich.amd.com>
References: <20090311150027.GK10490@alberich.amd.com>
	 <86802c440903120101o2a0c1ad0iec395c45f782078a@mail.gmail.com>
	 <20090312114121.GF20716@alberich.amd.com>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 14:29:02 +0200
Message-Id: <1236860942.12514.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-12 at 12:41 +0100, Andreas Herrmann wrote:
> On Thu, Mar 12, 2009 at 01:01:26AM -0700, Yinghai Lu wrote:
> > On Wed, Mar 11, 2009 at 8:00 AM, Andreas Herrmann
> > <andreas.herrmann3@amd.com> wrote:
> > > BIOS is expected to clear the SYSCFG[MtrrFixDramModEn] on AMD CPUs after
> > > fixed MTRRs are configured.
> > >
> > > Some BIOSes do not clear SYSCFG[MtrrFixDramModEn] on BP (and on APs).
> > >
> > > This can lead to obfuscation in Linux when this bit is not cleared on
> > > BP but cleared on APs. A consequence of this is that the saved
> > > fixed-MTRR state (from BP) differs from the fixed-MTRRs of APs --
> > > because RdDram/WrDram bits are read as zero when
> > > SYSCFG[MtrrFixDramModEn] is cleared -- and Linux tries to sync
> > > fixed-MTRR state from BP to AP. This implies that Linux sets
> > > SYSCFG[MtrrFixDramEn] and activates those bits.
> > >
> > > More important is that (some) systems change these bits in SMM when
> > > ACPI is enabled. Hence it is racy if Linux modifies RdMem/WrMem bits,
> > > too.
> > >
> > > I suggest not to touch RdDram/WrDram bits of fixed-MTRRs and
> > > SYSCFG[MtrrFixDramEn] and to clear SYSCFG[MtrrFixDramModEn] as
> > > suggested by AMD K8, and AMD family 10h/11h BKDGs.
> > > BIOS is expected to do this anyway. This should avoid that
> > > Linux and SMM tread on each other's toes ...
> > >
> > 
> > wonder if you could add one dmi check to tell the user that bios is
> > buggy, ask vendor fixed BIOS
> > and skip fixed mtrr sync.
> 
> There seem to be several systems affected that do not hide
> RdMem/WrMem bits from OS. 
> 
>  (Causing Suspend/resume problem:)
> - Acer Ferrari 1000
> - Acer Ferrari 5000


What problem?
Hang second resume???

I have an acer 5720G that hangs on second resume - bios doesn't pass
control to linux at all. First resume works fine.


Best regards,
	Maxim Levitsky



