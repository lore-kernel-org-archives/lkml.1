Return-Path: <linux-kernel-owner+w=401wt.eu-S1761890AbYGBDmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761890AbYGBDmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 23:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758374AbYGBDl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 23:41:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33248 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755151AbYGBDl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 23:41:56 -0400
Date: Tue, 1 Jul 2008 20:38:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
       robfitz@273k.net, jikos@jikos.cz, vojtech@suse.cz, dmonakhov@openvz.org,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH 001/002] linux-input:  bcm5974-0.31: fixed resource
 leak, removed work struct, device data struct introduced
Message-Id: <20080701203847.2dae15ba.akpm@linux-foundation.org>
In-Reply-To: <200807012004.17292.david-b@pacbell.net>
References: <1214653629.10495.11.camel@alnilam>
	<20080701155925.a4c00a8e.akpm@linux-foundation.org>
	<200807012004.17292.david-b@pacbell.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2008 20:04:16 -0700 David Brownell <david-b@pacbell.net> wrote:

> On Tuesday 01 July 2008, Andrew Morton wrote:
> > I dunno what USB driver normally use for their dma memory. __Perhaps
> > dma_alloc_coherent()?
> 
> kmalloc() as a rule ...

kmalloc(GFP_DMA)?  Hopefully not...

> dma_alloc_coherent() only makes sense if
> the buffer gets reused enough that the dma mapping ops (or as I
> think of them, cache maintainence ops) really hurt.
> 
> - Dave
