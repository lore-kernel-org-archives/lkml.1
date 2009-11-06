Return-Path: <linux-kernel-owner+w=401wt.eu-S1758048AbZKFNLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048AbZKFNLl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 08:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757885AbZKFNLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 08:11:40 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51795 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757493AbZKFNLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 08:11:39 -0500
Date: Fri, 6 Nov 2009 13:13:30 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: castet.matthieu@free.fr
Cc: linux-kernel@vger.kernel.org
Subject: Re: Using x86 segments against NULL pointer deference exploit
Message-ID: <20091106131330.0ce956f4@lxorguk.ukuu.org.uk>
In-Reply-To: <1257512389.4af41dc504e1b@imp.free.fr>
References: <1257512389.4af41dc504e1b@imp.free.fr>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Nov 2009 13:59:49 +0100
castet.matthieu@free.fr wrote:

> Hi,
> 
> I am wondering why we can't set the KERNEL_DS data segment to not contain the
> first page, ie changing it from R/W flat model to R/W expand down from
> 0xffffffff to 4096.

For one it is enormously expensive because the moment you have segment
limits all sorts of stuff goes slower. You also do sometimes need low 4K
access for wine/dosemu etc as you guess - and for APM and so on. Plus in
64bit you don't have a lot of those features ayway.

> The drawback of this it that the kernel can't access anymore data in the first
> segment. Is it needed for application like wine or dosemu ?

Yes. 

