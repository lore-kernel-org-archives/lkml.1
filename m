Return-Path: <linux-kernel-owner+w=401wt.eu-S1762116AbZANLnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762116AbZANLnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 06:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758013AbZANLmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 06:42:47 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40433 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762162AbZANLmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 06:42:46 -0500
Subject: Re: [PATCH -v8][RFC] mutex: implement adaptive spinning
From: Peter Zijlstra <peterz@infradead.org>
To: Folkert van Heusden <folkert@vanheusden.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090114114059.GA23674@vanheusden.com>
References: <1231774622.4371.96.camel@laptop>
	 <20090114114059.GA23674@vanheusden.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 14 Jan 2009 12:42:46 +0100
Message-Id: <1231933366.7141.28.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-14 at 12:41 +0100, Folkert van Heusden wrote:
> > The key criteria for the busy wait is that the lock owner has to be running on
> > a (different) cpu. The idea is that as long as the owner is running, there is a
> > fair chance it'll release the lock soon, and thus we'll be better off spinning
> > instead of blocking/scheduling.
> 
> Won't this make Linux less "green"? (-> use more power since busy loops
> use more power than idle loops) If so, maybe it should be make
> configurable somewhere?

According to the 'race to idle' paradigm this would actually help making
it more green, since it increases throughput.
