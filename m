Return-Path: <linux-kernel-owner+w=401wt.eu-S1762967AbXHXOUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762967AbXHXOUw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 10:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417AbXHXOUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 10:20:43 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:51481 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbXHXOUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 10:20:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=uHJFV27Tjv2X+vPI5RUZ4ntJpVMtct1O6Z0ooQS5M2+JG/lO3mWk7+RziZldMfL78V6DGQtabiegj1Y2M6Ftd7OPpaEBBgJBIpbZDLzouWBpX83aIAPHTeQGhHdvgi+gEjJP1WdRto/5Ij557pzI/NB55+tsC3rMcPEZ8bEL2U0=
Message-ID: <3ae72650708240720p33a7388h708787e8eb1921bf@mail.gmail.com>
Date: Fri, 24 Aug 2007 16:20:41 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Meelis Roos" <mroos@linux.ee>
Subject: Re: isapnp & module autoload (udev?)
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.SOC.4.64.0708241642540.27738@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.SOC.4.64.0708241434440.27738@math.ut.ee>
	 <3ae72650708240540qcf05809j609e0fbb05f221b3@mail.gmail.com>
	 <Pine.SOC.4.64.0708241642540.27738@math.ut.ee>
X-Google-Sender-Auth: 5ff6d3f85c5d191a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/24/07, Meelis Roos <mroos@linux.ee> wrote:
> > What's in the module? What does:
> >   /sbin/modinfo <kernel module name> | grep alias
> > print?
>
> filename:       /lib/modules/2.6.23-rc3/kernel/sound/isa/sb/snd-sb16.ko
> description:    Sound Blaster 16
...
> alias:          pnp:cCTL0070dCTL0001*
> alias:          pnp:cCTL0051dCTL0001*
...
> > And what does the hardware say? What does:
> >   grep . /sys/bus/pnp/devices/*/id
> > print?
...
> /sys/bus/pnp/devices/01:01.00/id:CTL0001
...
> CTL0001 seems to be present in both but it occurs with CTL0070 or
> CTL0051.

Right, that will not match. You could add:
  alias pnp:dCTL0001 snd-sb16
to:
  /etc/modprobe.d/pnp
or some other file in that directory.

We may switch to acpi based module autoloading in the future and add
"acpi:*" aliases to the modules intsead of the broken pnp alias hack.
Just to check if that would work, can you please provide the output
of:
  grep . /sys/bus/acpi/devices/*/modalias

Thanks,
Kay
