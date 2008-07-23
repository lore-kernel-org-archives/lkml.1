Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbYGWTuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbYGWTuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 15:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbYGWTu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 15:50:27 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:4735 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbYGWTu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 15:50:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=di9IB37oFg35Zl9yG07gGcUUPAFaTnr8ZPepuCw+t3swVPVCdoTHo8L/kAE1wr1/cH
         bNtB0/3KTxCZ8S0Sx2tMQyuw5t6x4shFLqk0rIgiMj7EXsqsVrswsjwbKGj1ocE1+kds
         peS8Ww84hbddfCND7VKw+Y03Xk3JzA4bZOb5g=
Message-ID: <b637ec0b0807231250g3e5b29eak8fbba41b69816351@mail.gmail.com>
Date: Wed, 23 Jul 2008 21:50:24 +0200
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Subject: Re: New conflict message in latest GIT
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Rene Herman" <rene.herman@keyaccess.nl>,
       "Andrew Morton" <akpm@osdl.org>, "Thomas Renninger" <trenn@suse.de>,
       "Jean Delvare" <khali@linux-fr.org>
In-Reply-To: <200807231256.42743.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b637ec0b0807221156x46d550a1h4180d6d624daeeb@mail.gmail.com>
	 <200807231256.42743.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Wed, Jul 23, 2008 at 8:56 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> On Tuesday 22 July 2008 12:56:36 pm Fabio Comolli wrote:
>> Linus' GIT tree 2.6.26-05752-g93ded9b shows this message:
>>
>> i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
>> ACPI: I/O resource 0000:00:1f.3 [0x18e0-0x18ff] conflicts with ACPI
>> region SMBI [0x18e0-0x18ef]
>> ACPI: Device needs an ACPI driver
>>
>> There is no equivalent in 2.6.26 or previous kernels.
>
> The "ACPI: I/O resource ... conflicts with ..." message was added by
> Thomas:
>  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=df92e695998e1bc6e426a840eb86d6d1ee87e2a5
>
> That conflict checking infrastructure was in 2.6.26, but Jean's
> change to make the i801_smbus driver use it didn't happen until
> about a week ago:
>  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=54fb4a05af0a4b814e6716cfdf3fa97fc6be7a32
>
> The message is telling us that the i801_smbus driver thinks it owns
> the 0x18e0-0x18ff region, but there's also an ACPI opregion that
> references that region.  There's no coordination between ACPI and
> the i801_smbus driver, so there may be issues where nearly
> simultaneous accesses cause incorrect behavior, e.g,. one may
> read the wrong value from a temperature sensor.  That, of course,
> can lead to more serious things like unintended machine shutdowns.
>
> I don't have any ideas about how to address this.  I think Thomas's
> intent was to collect better information for unreproducible bugs.
> (Maybe this sort of conflict should even set a taint flag?)
>

OK, I actually didn't even know what i801_smbus (i2c_801 I suppose)
was. It seems that my laptop has a super-IO chip which is detected by
lm-sensors as `Nat. Semi. PC87591 Super IO' which doesn't have a
driver and never will.

So, if I'm correct, this modules is totally useless for me and I
better compile it out. Am I correct?

> Bjorn
>
>

Regards,
Fabio
