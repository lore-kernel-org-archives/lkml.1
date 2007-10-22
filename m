Return-Path: <linux-kernel-owner+w=401wt.eu-S1754641AbXJVNSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbXJVNSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 09:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbXJVNSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 09:18:10 -0400
Received: from relay4.usu.ru ([194.226.235.39]:45649 "EHLO relay4.usu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226AbXJVNSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 09:18:09 -0400
Message-ID: <471CA308.80401@ums.usu.ru>
Date: Mon, 22 Oct 2007 19:18:00 +0600
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); ru-RU; rv:1.8.0.13pre) Gecko/20070505 Iceape/1.0.9 (Debian-1.0.10~pre070720-0etch3+lenny1) Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
Cc: Henrik Carlqvist <hc1@poolhem.se>, linux-kernel@vger.kernel.org
Subject: Re: tristate and bool not enogh for Kconfig anymore
References: <200710201257.55616.nick@ukfsn.org> <20071020144238.4f258c8c.hc1@poolhem.se> <20071022101107.GA20690@infradead.org> <471C7C33.4090003@ums.usu.ru> <20071022105727.GA22181@infradead.org> <471C8937.9010007@ums.usu.ru> <20071022125334.GA10563@infradead.org>
In-Reply-To: <20071022125334.GA10563@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV using ClamSMTP@relay4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, Oct 22, 2007 at 05:27:51PM +0600, Alexander E. Patrakov wrote:
>   
>> Yes, there is a call to usermodehelper_init() before the initcalls in 
>> do_basic_setup(), this does mean that firmware can be loaded by means of 
>> the old and obsolete /sbin/hotplug mechanism, but who has /sbin/hotplug now?
>>     
>
> I do.  We're not going to cripple the kernel just because you use <censored> userspace.
>
>   
AFAIK, there were good reasons (effect similar to fork bomb on a system 
with large number of, e.g., SCSI disks - Greg KH obviously knows more 
details) to drop /sbin/hotplug from all distributions in favour of udev. 
Anyway, the "hotplug" package is no longer supported by its author. So 
there is no option to use a non-<censored> from your viewpoint but still 
supported-upstream userspace.

As already mentioned in a different subthread, the solution is to wait 
for the firmware in the background, so that the built-in case also 
starts working. Drivers that don't do this (e.g. qla2xxx) must be fixed, 
but for now, IMHO, it does make sense to mark them as non-working in the 
non-modular case.

-- 
Alexander E. Patrakov
