Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbZGOM6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbZGOM6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 08:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754639AbZGOM6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 08:58:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:37705 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482AbZGOM6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 08:58:38 -0400
Date: Wed, 15 Jul 2009 06:00:06 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Zhang, Rui" <rui.zhang@intel.com>
Subject: Re: [PATCH 2/8] introduce the device async action mechanism
Message-ID: <20090715060006.71c2e2b6@infradead.org>
In-Reply-To: <1247643516.26272.77.camel@rzhang-dt>
References: <1247643516.26272.77.camel@rzhang-dt>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jul 2009 15:38:36 +0800
Zhang Rui <rui.zhang@intel.com> wrote:

> Introduce the device async action mechanism.
> 
> In order to speed up Linux suspend/resume/shutdown process,
> we introduce the device async action mechanism that allow devices
> to suspend/resume/shutdown asynchronously.
> 
> The basic idea is that,
> if the suspend/resume/shutdown process of a device set,
> including a root device and its child devices, are independent of
> other devices, we create an async domain for this device set,
> and make them suspend/resume/shutdown asynchronously.

Hi,

I have some concerns about having an async domain per device(group)
rather than having one async domain for all of this, I would
strongly suggest going to one global domain, so that it becomes
more practical to just wait for all async actions like this...
which you need to do during suspend for sure.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
