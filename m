Return-Path: <linux-kernel-owner+w=401wt.eu-S1760345AbYFMApR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760345AbYFMApR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 20:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756471AbYFMApD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 20:45:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53070 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755739AbYFMApA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 20:45:00 -0400
Date: Thu, 12 Jun 2008 17:43:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
Cc: johannes@sipsolutions.net, tomasw@gmail.com, riel@redhat.com,
       linux-kernel@vger.kernel.org, yi.zhu@intel.com,
       reinette.chatre@intel.com, linux-wireless@vger.kernel.org
Subject: Re: Problem: Out of memory after 2days with 2GB RAM
Message-Id: <20080612174357.ed9dc10a.akpm@linux-foundation.org>
In-Reply-To: <c4e36d110806121311n64890e17h67f49c32481fbb28@mail.gmail.com>
References: <c4e36d110806120307n20cce692s9c136f11596f5ab0@mail.gmail.com>
	<20080612093833.0fb9cdd6@bree.surriel.com>
	<1213278884.3936.15.camel@johannes.berg>
	<1ba2fa240806120843s268b2ff4mb45a11adf11afc7f@mail.gmail.com>
	<1ba2fa240806120935r54a080eci7fa6fafc718eed17@mail.gmail.com>
	<1213290335.3730.4.camel@johannes.berg>
	<1ba2fa240806121039o376b0a8sdfaacf3a1f4a9e57@mail.gmail.com>
	<1213292812.3730.21.camel@johannes.berg>
	<1ba2fa240806121103m60a8ffa4ie11850fedc69d13c@mail.gmail.com>
	<1213294547.3730.29.camel@johannes.berg>
	<c4e36d110806121311n64890e17h67f49c32481fbb28@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2008 22:11:32 +0200
"Zdenek Kabelac" <zdenek.kabelac@gmail.com> wrote:

> Well - it's great that there will be saved few kB in allocation of
> never used pointers in iwl driver - but does this really solve the
> problem that kernel gets relatively quickly out of memory for
> allocations of this size - I guess iwl isn't the only driver
> requesting 32 sequential pages.

I hope it is the only one.  Doing a 128kb GFP_ATOMIC allocation is
hopelessly unreliable.  Even a 128k GFP_KERNEL allocation will fail all
over the place.

Please convert the driver to allocate no more than 4k at a time.
