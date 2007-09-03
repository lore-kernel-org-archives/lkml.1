Return-Path: <linux-kernel-owner+w=401wt.eu-S1752083AbXICIda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbXICIda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 04:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbXICIdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 04:33:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59700 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbXICIdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 04:33:10 -0400
Date: Mon, 3 Sep 2007 01:31:57 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Robert Richter" <robert.richter@amd.com>
Cc: "Andi Kleen" <ak@suse.de>, patches@x86-64.org,
       linux-kernel@vger.kernel.org, "Robert Richter" <robert.richter@amd.com>
Subject: Re: [patch 3/5] x86: Add PCI extended config space access for AMD
 Barcelona
Message-ID: <20070903013157.72c94891@laptopd505.fenrus.org>
In-Reply-To: <20070903081736.588599000@amd.com>
References: <20070903081736.288288000@amd.com>
	<20070903081736.588599000@amd.com>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Sep 2007 10:17:39 +0200
"Robert Richter" <robert.richter@amd.com> wrote:

> This patch implements PCI extended configuration space access for
> AMD's Barcelona CPUs. It extends the method using CF8/CFC IO
> addresses. An x86 capability bit has been introduced that is set for
> CPUs supporting PCI extended config space accesses.
> 


No offence but this feels a bit wrong to me.

PCI is sort of more a chipset property than a cpu property (I realize
that this boundary is changing of course).

I'd like to ask you to at least rename some of the feature bits to
indicate that the extended config space is for the IO access method;
after all Linux already supports the MMIO method for accessing extended
config space since a really long time; not marking the feature bit to
indicate it's the IO method is going to be extremely confusing and
cause bugs I bet.

(we probably need a global function that drivers can use to find out of
extended config space is accessible; however that for sure isn't a CPU
capability bit. However the current naming etc sort of makes me fear
drivers will abuse this thing while thinking it's the right API)
