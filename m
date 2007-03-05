Return-Path: <linux-kernel-owner+w=401wt.eu-S1750936AbXCEGKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750936AbXCEGKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 01:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbXCEGKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 01:10:40 -0500
Received: from nz-out-0506.google.com ([64.233.162.225]:5263 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbXCEGKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 01:10:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RXxsGo64sYaVZMG4o5zXrIWklxy/KsVcW1C7jH90US0fcdjn+iqLy2dT3ZmJn6dCMEWyyzNK9BPVZ74EhiJf4aXY5TCmuHrIZrvUH9tro3Ac+hhIvULJbzxt6m6NueMekiO4Y5JwkLpR9W4Cw2nHvsww1oDOp7vZXKezzzmYT/s=
Subject: Re: 2.6.21-rc1: framebuffer/console boot failure
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Andrew Nelless <andrew@nelless.net>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <35793.86.7.220.119.1173019974.squirrel@wmbeta.mxes.net>
References: <35472.86.7.220.119.1172237750.squirrel@wmbeta.mxes.net>
	 <20070224030950.074f88d4.akpm@linux-foundation.org>
	 <33525.86.7.220.119.1172358010.squirrel@wmbeta.mxes.net>
	 <1172359843.4415.8.camel@daplas>
	 <34578.86.7.220.119.1172401665.squirrel@wmbeta.mxes.net>
	 <1172493697.20842.6.camel@daplas>
	 <36488.86.7.220.119.1172515738.squirrel@wmbeta.mxes.net>
	 <1172531359.7101.22.camel@daplas>
	 <35793.86.7.220.119.1173019974.squirrel@wmbeta.mxes.net>
Content-Type: text/plain
Date: Mon, 05 Mar 2007 14:12:38 +0800
Message-Id: <1173075158.4158.1.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-04 at 14:52 +0000, Andrew Nelless wrote:
> On Mon, February 26, 2007 11:09 pm, Antonino A. Daplas wrote:
> >
> > Not sure if the timer override workaround for nvidia chipsets is the
> > culprit, but if you want, you can choose to revert that to the previous behavior (which is
> > ignoring ACPI timer override). Open arch/x86_64/kernel/earlyquirk.c:nvidia_bugs() and change
> > this line:
> >
> > if (acpi_table_parse(ACPI_SIG_HPET, nvidia_hpet_check)) return; into this:
> >
> > acpi_table_parse(ACPI_SIG_HPET, nvidia_hpet_check); /* return; */
> >
> >
> > Tony
> >
> 
> This fixes the problem. After a lot of rebooting
> and testing the problem is definitely gone when this
> check is patched out and the ACPI timer override is
> ignored. It looks like there should be a cleaner
> patch than just obliterating the condition and return
> though.
> 
> Perhaps the code should remain as is and
> "acpi_use_timer_override" could be complimented
> by exposing the "acpi_skip_timer_override" option to
> the kernel command line?

acpi_skip_timer_override is still documented in
Documentation/kernel-parameters.txt. 

Tony


