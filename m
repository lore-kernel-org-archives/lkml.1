Return-Path: <linux-kernel-owner+w=401wt.eu-S1751505AbYAOLs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbYAOLs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 06:48:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbYAOLss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 06:48:48 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40271 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbYAOLsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 06:48:47 -0500
Date: Tue, 15 Jan 2008 20:48:15 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC][PATCH 3/5] add /dev/mem_notify device
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Marcelo Tosatti <marcelo@kvack.org>,
       Daniel Spang <daniel.spang@gmail.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080115112027.6120915b@lxorguk.ukuu.org.uk>
References: <20080115195022.11A3.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080115112027.6120915b@lxorguk.ukuu.org.uk>
Message-Id: <20080115202711.11A6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan

thank you for kindfull explain.

> > > > the core of this patch series.
> > > > add /dev/mem_notify device for notification low memory to user process.
> > > 
> > > As you only wake one process how would you use this API from processes
> > > which want to monitor and can free memory under load. Also what fairness
> > > guarantees are there...
> > 
> > Sorry, I don't make sense what you mean fairness.
> > Could you tell more?
> 
> If you have two processes each waiting on mem_notify is it not possible
> that one of them will keep being the one woken up and the other will
> remain stuck ?

current wake up order is simply FIFO by poll(2) called.
because the VM cannot know how much amount each process can do in free.
the process rss and freeable memory is not proportional.

thus I adopt wake up one after another until restoration memory shortage.


> It also appears there is no way to wait for memory shortages (processes
> that can free memory easily) only for memory to start appearing.

poll() with never timeout don't fill your requirement?
to be honest, maybe I don't understand your afraid yet. sorry.


-kosaki


