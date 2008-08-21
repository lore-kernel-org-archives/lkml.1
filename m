Return-Path: <linux-kernel-owner+w=401wt.eu-S1755774AbYHUTlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbYHUTlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 15:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758894AbYHUTlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 15:41:08 -0400
Received: from mail-gx0-f29.google.com ([209.85.217.29]:61566 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758629AbYHUTlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 15:41:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=J++jBL8fAI9U1xLSWt/AxsH9F/QozNIdrSZfC4sv/dTvDwjE4GlxFNeCZx1KawwMf5
         yY8QG123XDVVjszhWNd2ckoTZieEf+V/IysBnZrMC7nvF3yMl4DHfxDsnIuXcYMDCjTk
         XSqCtG9pQMQN+L5BcQmqQMJRU6uD27HixYVfs=
Message-ID: <19f34abd0808211241l54863821n8e978682c9d43dc7@mail.gmail.com>
Date: Thu, 21 Aug 2008 21:41:05 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: latest -git: hibernate: possible circular locking dependency detected
Cc: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>,
       "Max Krasnyanskiy" <maxk@qualcomm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Pavel Machek" <pavel@ucw.cz>
In-Reply-To: <200808212131.29906.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0808210804y7ee91d1fy12da5ad6f82d2451@mail.gmail.com>
	 <200808212107.42356.rjw@sisk.pl>
	 <19f34abd0808211214x24af9351tcc077307fd1f2be5@mail.gmail.com>
	 <200808212131.29906.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 9:31 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Now, what is the source of the "SysRq : Power Off" in the dmesg you posted?

The only suggestion I can make is that SysRq can be triggered remotely
with serial console (COM1/ttyS0), because I know that the serial line
is producing junk in the other direction (i.e. reading from /dev/ttyS0
on the kernel which has been booted with console=ttyS0 reads junk,
sometimes things that look like pieces of dmesg). Other than that, I
have no idea. The SysRq thing seems to only happen after I've entered
"echo disk > /sys/power/state" too.

(Also see my email at http://lkml.org/lkml/2008/8/21/409)

>
> Also, have you tried to hibernate with the "platform" setting selected in
> "cat /sys/power/disk" and if you have, does the lockdep warning appear in this
> case?

Yes, I have tried it. In fact, I believe the lockdep warning in the
boot-log comes with such a setting (ACPI was enabled; isn't platform
the default in that case?). At least it looked to be selected when
acpi is enabled:

> # cat /sys/power/disk
> [platform] test testproc shutdown reboot


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
