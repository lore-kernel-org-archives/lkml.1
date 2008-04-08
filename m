Return-Path: <linux-kernel-owner+w=401wt.eu-S1755810AbYDHIYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbYDHIYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 04:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbYDHIYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 04:24:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41060 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752091AbYDHIYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 04:24:35 -0400
Date: Tue, 8 Apr 2008 01:23:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "eric miao" <eric.y.miao@gmail.com>
Cc: "linux-arm-kernel email list" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-fbdev-devel@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       "Daniel Mack" <daniel@caiaq.de>
Subject: Re: [PATCH 4/4] pxafb: preliminary smart panel interface support
Message-Id: <20080408012359.d0a7d0c8.akpm@linux-foundation.org>
In-Reply-To: <f17812d70804072107k77c2642ah23c8f2ce9535159f@mail.gmail.com>
References: <f17812d70804072107k77c2642ah23c8f2ce9535159f@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Apr 2008 12:07:27 +0800 "eric miao" <eric.y.miao@gmail.com> wrote:

> +static int pxafb_smart_thread(void *arg)
> +{
> +	struct pxafb_info *fbi = (struct pxafb_info *) arg;

Please don't typecast when assigning a pointer to or from void*.

Reasons:

- It defeats typechecking: if someone later converts `arg' to a u8, they
  won't even get a compiler warning.

- Improved code readability.

