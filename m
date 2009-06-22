Return-Path: <linux-kernel-owner+w=401wt.eu-S1754259AbZFVTo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbZFVTo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 15:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbZFVToU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 15:44:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48867 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751497AbZFVToU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 15:44:20 -0400
Date: Mon, 22 Jun 2009 12:43:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Lutomirski <luto@mit.edu>
cc: =?ISO-8859-15?Q?Thomas_Hellstr=F6m?= <thomas@shipmail.org>,
       Dave Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
       dri-devel@lists.sf.net, Jerome Glisse <jglisse@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] drm: previous pull req + 1.
In-Reply-To: <cb0375e10906221159u56fcf275yff34b93a39e07186@mail.gmail.com>
Message-ID: <alpine.LFD.2.01.0906221241130.3240@localhost.localdomain>
References: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie>  <4A3DABE1.50309@mit.edu>  <alpine.DEB.2.00.0906210615450.6234@skynet.skynet.ie>  <alpine.LFD.2.01.0906210945170.3119@localhost.localdomain>  <alpine.LFD.2.01.0906210948340.3119@localhost.localdomain>
  <cb0375e10906211150v7c54f355ga0066eccc128085@mail.gmail.com>  <alpine.LFD.2.01.0906211223190.3119@localhost.localdomain>  <alpine.DEB.2.00.0906212336200.20307@skynet.skynet.ie>  <4A3F3E3A.2030202@shipmail.org>  <alpine.LFD.2.01.0906221121100.3240@localhost.localdomain>
 <cb0375e10906221159u56fcf275yff34b93a39e07186@mail.gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 22 Jun 2009, Andrew Lutomirski wrote:
> 
> What if we only guaranteed that the framebuffer is mapped when it's
> showing on the screen?

I think that works ok. We only care about printk being immediate in that 
case, and if it gets buffered I don't think we care.

> printk doesn't need to write to the framebuffer immediately when X
> isn't running (since the framebuffer isn't shown) and presumably the
> framebuffer needs to be pinned somewhere when it's being displayed
> anyway.  This would involve fbcon knowing how to buffer text to be
> shown later so that printk still works in interrupt context.

But doesn't fbcon do that _anyway_ for VC switching?

(I've tried to stay out of fbcon, and have traditionally personally always 
preferred just regular VGA text mode, so I really have no clue about the 
internals).

			Linus
