Return-Path: <linux-kernel-owner+w=401wt.eu-S938351AbXHIQX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938351AbXHIQX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 12:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939538AbXHIQXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 12:23:47 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:56030 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939715AbXHIQXp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 12:23:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=cu1T5A/1FOellDqeGXSBLZrsi6PFUH0JWYQ3nxMwiSAo5MqL19WlttgCM3lNWyYplSPTWhVtotWyAAHsiFESsp248tcP5dkKH3RtC5f32xN0xIsXn8l9437IISaDmHT8hHxn8e230xnSZ2hVa1watFNkXTSZpTQk1kv1Vx1RJEE=
Date: Thu, 9 Aug 2007 18:22:37 +0200
From: Diego Calleja <diegocg@gmail.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Lionel Elie Mamane <lionel@mamane.lu>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingcha@pimp.vs19.net
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-Id: <20070809182237.b5afc4c7.diegocg@gmail.com>
In-Reply-To: <46BB2C8E.2050205@redhat.com>
References: <20070803123712.987126000@chello.nl>
	<alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org>
	<20070804063217.GA25069@elte.hu>
	<20070804070737.GA940@elte.hu>
	<20070804103347.GA1956@elte.hu>
	<20070804163733.GA31001@elte.hu>
	<20070809062511.GA23435@capsaicin.mamane.lu>
	<46BB2C8E.2050205@redhat.com>
X-Mailer: Sylpheed 2.4.4 (GTK+ 2.11.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Thu, 09 Aug 2007 11:02:38 -0400, Chuck Ebbert <cebbert@redhat.com> escribió:

> NT maintains atimes by default, at least up to XP. You have to edit the
> registry to turn them off, and it is a single global switch -- not per
> mountpoint like Unix.
> 
> And it makes a huge difference there, too.

In windows Vista they've disabled atime updates by default.

And XP maintains atimes, but it uses a trick to avoid the performance
penalty we suffer in linux, similar to what Andi Kleen suggested: they
keep atime updates in memory for one hour, and only sync to disk after
that time - of course they also sync it if there's a oportunity to do it, like
when updating mtime.
