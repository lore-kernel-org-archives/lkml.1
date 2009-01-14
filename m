Return-Path: <linux-kernel-owner+w=401wt.eu-S1760777AbZANJDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760777AbZANJDK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 04:03:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760820AbZANJCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 04:02:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:36909 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760713AbZANJC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 04:02:29 -0500
Date: Wed, 14 Jan 2009 09:04:33 +0000
From: Arjan van de Ven <arjan@infradead.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 1/6] fastboot: Asynchronous function calls to speed up
 kernel boot
Message-ID: <20090114090433.45cf1e78@infradead.org>
In-Reply-To: <1231911163.20746.126.camel@rzhang-dt>
References: <20090105200959.04a626ac@infradead.org>
	<20090105201041.3289d3dd@infradead.org>
	<1231911163.20746.126.camel@rzhang-dt>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009 13:32:43 +0800
Zhang Rui <rui.zhang@intel.com> wrote:
> > +
> > +       wait_event(async_done, lowest_in_progress >= cookie);
> > +
> 
> In some cases, we only want to wait for a specific cookie
> rather than all the cookies smaller than it.
> 
> For example:
> device          cookie
> ACPI battery    1
> ata port 0      2
> ata port 1      3
> ata port 0 and port 1 in the same host can not be probed in parallel.
> 
> In this case, ata port1 should only wait for cookie 2 rather than
> both 1 and 2.
> 

I really don't want to go this way; ordering is really important and I
don't want to break this.

If you really have a fully separate domain (and there's only few of
those in our kernel), then use a special run list.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
