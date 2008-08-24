Return-Path: <linux-kernel-owner+w=401wt.eu-S1755078AbYHXPD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbYHXPD5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 11:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbYHXPDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 11:03:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38146 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbYHXPDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 11:03:48 -0400
Date: Sun, 24 Aug 2008 11:58:35 -0300 (BRT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
X-X-Sender: v4l@areia
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>,
       Henne <henne@nachtwindheim.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] V4L: fix retval in vivi driver for more than one device
In-Reply-To: <200808241634.36653.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0808241152400.2897@areia>
References: <48AF1E83.4000102@nachtwindheim.de> <Pine.LNX.4.64.0808241045530.2897@areia>
 <200808241634.36653.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Please note that I am working on creating a much improved V4L
> infrastructure to take care of such things. It's simply nuts that v4l
> drivers need to put in all the plumbing just to be able to have
> multiple instances.
>
> In particular, all these limitations on the number of instances should
> disappear (unless you run out of minors).

If you use vivi with a large number of devs (for example, 128), you'll run 
out of minors, since we currently have only 64 for video grabber. Due to 
the videodev limits, in fact, we can allocate "only" 32 virtual devices 
per driver.

Even with the changes on V4L infrastructure, vivi driver still doesn't do 
the right thing if you use a large number of devs.

I'm currently fixing the "vivi" driver and adding some notes on it about 
the current limits.

Cheers,
Mauro.
