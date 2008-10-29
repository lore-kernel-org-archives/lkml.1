Return-Path: <linux-kernel-owner+w=401wt.eu-S1753425AbYJ2HUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbYJ2HUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 03:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbYJ2HU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 03:20:28 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:45969 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbYJ2HU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 03:20:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=QX9BTfWN54xCvyomSzLtxsP1XF+Hg/KRnzZNjIi8oq403azPsQrUNwRIUgpLFQcUz/
         JIYEiCeiLwaSCHr8pZmMWikl2Xdj6HSJJ9r5MNNWtK+mmOEpomm5lMidMgdgGiG9YTW2
         6k0C15w9bmR/ahkWlwkOmfYfn5ylwQCU0Zzog=
Message-ID: <2f11576a0810290020i362441edkb494b10c10b17401@mail.gmail.com>
Date: Wed, 29 Oct 2008 16:20:24 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] lru_add_drain_all() don't use schedule_on_each_cpu()
Cc: "Christoph Lameter" <cl@linux-foundation.org>, heiko.carstens@de.ibm.com,
       npiggin@suse.de, linux-kernel@vger.kernel.org, hugh@veritas.com,
       torvalds@linux-foundation.org, riel@redhat.com, lee.schermerhorn@hp.com,
       linux-mm@kvack.org
In-Reply-To: <20081028134536.9a7a5351.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2f11576a0810210851g6e0d86benef5d801871886dd7@mail.gmail.com>
	 <2f11576a0810211018g5166c1byc182f1194cfdd45d@mail.gmail.com>
	 <20081023235425.9C40.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20081027145509.ebffcf0e.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0810280914010.15939@quilx.com>
	 <20081028134536.9a7a5351.akpm@linux-foundation.org>
X-Google-Sender-Auth: 56d6212f3da5d745
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I guess we should document our newly discovered schedule_on_each_cpu()
> problems before we forget about it and later rediscover it.

Now, schedule_on_each_cpu() is only used by lru_add_drain_all().
and smp_call_function() is better way for cross call.

So I propose
   1. lru_add_drain_all() use smp_call_function()
   2. remove schedule_on_each_cpu()


Thought?
