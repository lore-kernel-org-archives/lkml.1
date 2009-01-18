Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbZARTUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbZARTUH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 14:20:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbZARTTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 14:19:52 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:49605 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbZARTTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 14:19:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sZSsXEio1vULIwlo1z3povxQoGw8JL4EftNmNhizrrmoCBR/kQMMcWgmUaU8KUo61o
         5iRrjZbOuuaZ1yF3vS6fZEEGBJC+H+tZtBL5nXMdXlMned+YE5+5z43eu0A8DAgsJyfR
         m34/y9M7CETVUfIXSJIih3Q37CbeZG9hZDGOA=
MIME-Version: 1.0
In-Reply-To: <9b2b86520901180345j434eacbdn7386958991ee50b@mail.gmail.com>
References: <9b2b86520901180345j434eacbdn7386958991ee50b@mail.gmail.com>
Date: Sun, 18 Jan 2009 19:19:48 +0000
X-Google-Sender-Auth: 8cd26b3efaed2d74
Message-ID: <9b2b86520901181119kfdc15bev7f6d859172355055@mail.gmail.com>
Subject: Re: 2.6.29-rc2 regression: hibernation hang on eeepc-701 (method 
	"platform" only)
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: kernel-testers@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       linux acpi <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/18/09, Alan Jenkins <alan-jenkins@tuffmail.co.uk> wrote:
> Hibernation hangs just after writing the image.  With s2disk I can see
> this from the console messages.  The same hang happens with kernel
> swsusp ('echo disk | sudo tee /sys/power/state'), and I can see that
> the image has been written from the HDD led.
>
> In either case, I can still hard-power-off and resume from hibernation.
>
> It doesn't hang if I use the shutdown method (either 'echo shutdown |
> sudo tee /sys/power/disk' or  's2disk -P "shutdown method=shutdown"').

As a wild guess I tried "acpi_sleep=s4_nonvs", but it didn't help.

In fact it didn't seem to work.  The kernel log says that NVS was
still saved and restored.

$ dmesg | grep -i nvs
[    0.000000]  BIOS-e820: 000000001f790000 - 000000001f7d0000 (ACPI NVS)
[    0.000000] Kernel command line: root=/dev/sda2 ro resume=/dev/sda2
resume_offset=144480 quiet acpi_sleep=s4_nonvs
[   91.105449] PM: Saving platform NVS memory
[   91.106707] PM: Restoring platform NVS memory

Thanks
Alan
