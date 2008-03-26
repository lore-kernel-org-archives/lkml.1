Return-Path: <linux-kernel-owner+w=401wt.eu-S1757059AbYCZXd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059AbYCZXd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 19:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbYCZXdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 19:33:18 -0400
Received: from gw.goop.org ([64.81.55.164]:48152 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371AbYCZXdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 19:33:17 -0400
Message-ID: <47EADD33.7060507@goop.org>
Date: Wed, 26 Mar 2008 16:33:07 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: what's the incompatibility between hibernation and hotplug memory
References: <47EAD9A7.6020609@goop.org> <200803270027.26037.rjw@sisk.pl>
In-Reply-To: <200803270027.26037.rjw@sisk.pl>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> Generally, we might not be able to handle memory unplugged at a wrong time
> (eg. after we've created the image).
>   

Hot memory unplugging is distinct from memory hotplug.

> Which part of Kconfig says that exactly?
>   

mm/Kconfig:

config MEMORY_HOTPLUG
	bool "Allow for memory hot-add"
	depends on SPARSEMEM || X86_64_ACPI_NUMA
	depends on HOTPLUG && !HIBERNATION && ARCH_ENABLE_MEMORY_HOTPLUG
	depends on (IA64 || X86 || PPC64 || SUPERH)

comment "Memory hotplug is currently incompatible with Software Suspend"
	depends on SPARSEMEM && HOTPLUG && HIBERNATION


    J
