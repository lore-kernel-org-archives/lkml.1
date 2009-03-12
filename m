Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbZCLIBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbZCLIBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 04:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbZCLIBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 04:01:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:21906 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbZCLIB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 04:01:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=cl5RvFd8eOflXYe28+i2atKkOTORyBtzikP0364GDdHSTkGVTwAn/F3NXF4l0BdtAJ
         oT9E4/Z2pYJgScD+k6CFiyRb/vklPURFYhxczInIbL9hDOBa+to3ehAguZBhG/8ZzmvB
         +419ElM3rmPo2KnXK7Lih8mHNg1hX/zTGx5EY=
MIME-Version: 1.0
In-Reply-To: <20090311150027.GK10490@alberich.amd.com>
References: <20090311150027.GK10490@alberich.amd.com>
Date: Thu, 12 Mar 2009 01:01:26 -0700
X-Google-Sender-Auth: 53762a927cdf5c9b
Message-ID: <86802c440903120101o2a0c1ad0iec395c45f782078a@mail.gmail.com>
Subject: Re: [PATCH] x86: mtrr: don't modify RdDram/WrDram bits of fixed MTRRs
From: Yinghai Lu <yinghai@kernel.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       trenn@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 8:00 AM, Andreas Herrmann
<andreas.herrmann3@amd.com> wrote:
> BIOS is expected to clear the SYSCFG[MtrrFixDramModEn] on AMD CPUs after
> fixed MTRRs are configured.
>
> Some BIOSes do not clear SYSCFG[MtrrFixDramModEn] on BP (and on APs).
>
> This can lead to obfuscation in Linux when this bit is not cleared on
> BP but cleared on APs. A consequence of this is that the saved
> fixed-MTRR state (from BP) differs from the fixed-MTRRs of APs --
> because RdDram/WrDram bits are read as zero when
> SYSCFG[MtrrFixDramModEn] is cleared -- and Linux tries to sync
> fixed-MTRR state from BP to AP. This implies that Linux sets
> SYSCFG[MtrrFixDramEn] and activates those bits.
>
> More important is that (some) systems change these bits in SMM when
> ACPI is enabled. Hence it is racy if Linux modifies RdMem/WrMem bits,
> too.
>
> I suggest not to touch RdDram/WrDram bits of fixed-MTRRs and
> SYSCFG[MtrrFixDramEn] and to clear SYSCFG[MtrrFixDramModEn] as
> suggested by AMD K8, and AMD family 10h/11h BKDGs.
> BIOS is expected to do this anyway. This should avoid that
> Linux and SMM tread on each other's toes ...
>

wonder if you could add one dmi check to tell the user that bios is
buggy, ask vendor fixed BIOS
and skip fixed mtrr sync.

instead of covering bios problem quietly.

YH
