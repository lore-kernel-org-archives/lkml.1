Return-Path: <linux-kernel-owner+w=401wt.eu-S1758191AbZFIHug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191AbZFIHug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 03:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754834AbZFIHu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 03:50:29 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:63723 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784AbZFIHu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 03:50:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=AFMdck5MS4PmaxatZg/tnAwGASU+r0g1xgt+lz1h0Di3k6sJ2DvZukcDQMWo4pd5OM
         mNTBx62e9jYuwwy0vZdVETXWOLuAtxnoX6VkHucQ4L2FBtZJZxDIPCLX2gpoZWH59uo1
         Q6x2FIZfMD4ejckgtgUYcHIAizDwne0klORTU=
MIME-Version: 1.0
In-Reply-To: <20090608141212.GE15070@csn.ul.ie>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera> <4A2BBC30.2030300@lwfinger.net>
	 <84144f020906070640rf5ab14nbf66d3ca7c97675f@mail.gmail.com>
	 <4A2BCC6F.8090004@redhat.com>
	 <84144f020906070732l31786156r5d9753a0cabfde79@mail.gmail.com>
	 <20090608101739.GA15377@csn.ul.ie>
	 <84144f020906080352k57f12ff9pbd696da5f332ac1a@mail.gmail.com>
	 <20090608110303.GD15377@csn.ul.ie>
	 <Pine.LNX.4.64.0906081657001.7036@melkki.cs.Helsinki.FI>
	 <20090608141212.GE15070@csn.ul.ie>
Date: Tue, 9 Jun 2009 10:50:28 +0300
X-Google-Sender-Auth: 54c3e314add1e3cc
Message-ID: <84144f020906090050y351e3e9cmb69a089e1a996cd4@mail.gmail.com>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>, Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 8, 2009 at 5:12 PM, Mel Gorman<mel@csn.ul.ie> wrote:
> In addition, include how many objects there are per-slab and include what
> the order is being passed to the page allocator when allocating new slabs.
> Would that be enough to determine if fallback-to-smaller orders occured?

Well, if the slab_out_of_memory() is called, we already know the
higher order allocation failed _and_ the fallback allocation failed.
So yes, it would be enough.
