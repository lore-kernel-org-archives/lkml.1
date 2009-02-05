Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbZBESPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbZBESPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 13:15:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760118AbZBESNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 13:13:54 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:39351 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760077AbZBESNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 13:13:53 -0500
To: felipe.balbi@nokia.com
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "wim\@iguana.be" <wim@iguana.be>
Subject: Re: [PATCH] watchdog: davinci: convert to ioremap() + io[read|write]
References: <1233854782-3642-1-git-send-email-khilman@deeprootsystems.com>
	<20090205173810.GE10567@scadufax.research.nokia.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Thu, 05 Feb 2009 10:13:47 -0800
In-Reply-To: <20090205173810.GE10567@scadufax.research.nokia.com> (Felipe Balbi's message of "Thu\, 5 Feb 2009 19\:38\:10 +0200")
Message-ID: <87tz784uqs.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Balbi <felipe.balbi@nokia.com> writes:

> On Thu, Feb 05, 2009 at 06:26:22PM +0100, Kevin Hilman wrote:
>> +       wdt_base = ioremap(res->start, res->end);
>
> second argument should be size right ??
>
> ioremap(res->start, res->end - res->start + 1);
>
> in fact you have a size variable in this driver used for
> request_mem_region() just be sure the value is still valid and use it
> ;-)

doh.

>> +       if (!wdt_base) {
>> +               printk(KERN_ERR MODULE_NAME "failed to map memory region\n");
>
> you have a dev pointer in platform_device would be cool
> to use dev_err() here

sounds good, I'll convert the rest of the printk(KERN_* into dev_* as well.

Kevin
