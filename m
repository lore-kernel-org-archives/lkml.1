Return-Path: <linux-kernel-owner+w=401wt.eu-S1763225AbXHFKgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763225AbXHFKgI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 06:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760570AbXHFKf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 06:35:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51376 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435AbXHFKf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 06:35:56 -0400
Date: Mon, 6 Aug 2007 12:35:53 +0200
From: Andi Kleen <andi@firstfloor.org>
To: dragoran <drago01@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: allow non root users to set io priority "idle" ?
Message-ID: <20070806103553.GA16133@one.firstfloor.org>
References: <46B6EDCB.6030806@gmail.com> <p73zm14lxyy.fsf@bingen.suse.de> <46B6F75D.1070808@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B6F75D.1070808@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> couldn't this be fixed by bumping idle tasks to middle while they hold a 

Usually to high.

But it's all complicated and hasn't been done consistently
(there are real time mutexes in the -rt kernel for example, 
but there are lots of other locks and they have higher overhead too) 
and it's unclear we really want to do all this complexity anyways.

Also as I said the problem could then still happen in user space
which then would all need to be fixed to handle PI too.

In some cases the relationship is also not as simple as a single 
lock. And for IO handling it would be likely quite hard.

I personally always found idle priorities quite dubious because
even if they worked reliable for the CPU they will clear your cache/
load your memory controller and impact all other programs because
of this. And for the disk they will cause additional seeks which are 
also very costly.

-Andi
