Return-Path: <linux-kernel-owner+w=401wt.eu-S934150AbZLOXzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934150AbZLOXzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 18:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934125AbZLOXzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:55:50 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50191 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934102AbZLOXzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:55:48 -0500
Date: Tue, 15 Dec 2009 23:56:39 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       linux-kernel@vger.kernel.org, rubini@gnudd.com
Subject: Re: [PATCH 3/3] misc: use a proper range for minor number dynamic
 allocation
Message-ID: <20091215235639.25e841f1@lxorguk.ukuu.org.uk>
In-Reply-To: <20091215225630.GA12918@suse.de>
References: <1257813017-28598-1-git-send-email-cascardo@holoscopio.com>
	<1257813017-28598-2-git-send-email-cascardo@holoscopio.com>
	<1257813017-28598-3-git-send-email-cascardo@holoscopio.com>
	<4AF8B4FF.9050405@zytor.com>
	<20091111153632.944a255c.akpm@linux-foundation.org>
	<20091215143446.8b6a7e57.akpm@linux-foundation.org>
	<4B2810D6.9030309@zytor.com>
	<20091215225630.GA12918@suse.de>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What I have been doing in response to requests for misc device
allocations is to suggest people simply go and allocate some dynamic
device space. There are very very few cases a misc device needs a
specific minor and the large dynamic device space has really made misc a
"historical" entity which should be treated that way.

If you want 2048 minors for a random new device, the kernel will just
magic them for you, udev will magic the device nodes, and the tmpfs will
handle it nicely

(and if your udev isn't on its own private file system then I hope its an
old one, because the current one has a hole in it, which doesn't seem to
have been fixed yet)

Alan
