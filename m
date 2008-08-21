Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbYHUTvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbYHUTvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 15:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbYHUTu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 15:50:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39829 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbYHUTu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 15:50:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: latest -git: hibernate: possible circular locking dependency detected
Date: Thu, 21 Aug 2008 21:54:23 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>,
       "Max Krasnyanskiy" <maxk@qualcomm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Pavel Machek" <pavel@ucw.cz>
References: <19f34abd0808210804y7ee91d1fy12da5ad6f82d2451@mail.gmail.com> <200808212131.29906.rjw@sisk.pl> <19f34abd0808211241l54863821n8e978682c9d43dc7@mail.gmail.com>
In-Reply-To: <19f34abd0808211241l54863821n8e978682c9d43dc7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808212154.24600.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 21 of August 2008, Vegard Nossum wrote:
> On Thu, Aug 21, 2008 at 9:31 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Now, what is the source of the "SysRq : Power Off" in the dmesg you posted?
> 
> The only suggestion I can make is that SysRq can be triggered remotely
> with serial console (COM1/ttyS0), because I know that the serial line
> is producing junk in the other direction (i.e. reading from /dev/ttyS0
> on the kernel which has been booted with console=ttyS0 reads junk,
> sometimes things that look like pieces of dmesg). Other than that, I
> have no idea. The SysRq thing seems to only happen after I've entered
> "echo disk > /sys/power/state" too.
> 
> (Also see my email at http://lkml.org/lkml/2008/8/21/409)
> 
> >
> > Also, have you tried to hibernate with the "platform" setting selected in
> > "cat /sys/power/disk" and if you have, does the lockdep warning appear in this
> > case?
> 
> Yes, I have tried it. In fact, I believe the lockdep warning in the
> boot-log comes with such a setting (ACPI was enabled; isn't platform
> the default in that case?). At least it looked to be selected when
> acpi is enabled:

Yes, it is the default in that case.

> > # cat /sys/power/disk
> > [platform] test testproc shutdown reboot

The problem is, in the case of the "platform" hibernation, kernel_power_off()
is not called at all (ACPI mechanism to enter the S4 sleep state is used
instead).  Apart from this, there should be lines like:

"ACPI: Preparing to enter system sleep state S4"

in the dmesg log in that case and they are not present in your dmesg.

Your dmesg looks like a mixture of hibernation in the "shutdown" mode with
"emergency" shutdown caused by "SysRq : Power Off".

Thanks,
Rafael
