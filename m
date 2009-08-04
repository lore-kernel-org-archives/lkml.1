Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbZHDBFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbZHDBFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 21:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbZHDBFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 21:05:20 -0400
Received: from smtp-out.google.com ([216.239.33.17]:52316 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbZHDBFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 21:05:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=YHmxN2J4SUrBE+UfRAzs/Y6DrQqrjiQHhOtiI2F0VS6Yv+h9Wk3oOw+lAUWkD65ZD
	b/xJG2+wmC/Wg7qM8KZVg==
MIME-Version: 1.0
In-Reply-To: <2f86c2480908031756j557e7aebmbf7951da6a1aadb0@mail.gmail.com>
References: <20090731012908.27908.62208.stgit@hastromil.mtv.corp.google.com>
	 <20090731015154.27908.9639.stgit@hastromil.mtv.corp.google.com>
	 <4A7652E7.4020206@cn.fujitsu.com>
	 <2f86c2480908031756j557e7aebmbf7951da6a1aadb0@mail.gmail.com>
Date: Mon, 3 Aug 2009 18:05:16 -0700
Message-ID: <6599ad830908031805y31136eceqeff0bab455100d6c@mail.gmail.com>
Subject: Re: [PATCH 6/6] Makes procs file writable to move all threads by tgid 
	at once
From: Paul Menage <menage@google.com>
To: Benjamin Blum <bblum@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       serue@us.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 3, 2009 at 5:56 PM, Benjamin Blum<bblum@google.com> wrote:
> No, the idea is that even though we had a reference that we already
> dropped, we in effect "traded" the newcg to the task for its oldcg,
> giving it our reference on newcg and gaining its reference on oldcg. I
> believe the cgroup_mutex guarantees that it'll still be there when we
> do the trade - perhaps a BUG_ON(tsk->cgroups != oldcg) is wanted
> inside the second task_lock section there?

I don't think that's safe, since the task could exit and drop its
reference (and switch to init_css_set).

>>
>> I think it's more intuitive to return 1 if found and 0 if not found.
>
> I was sticking with the convention of nonzero return values indicating
> failure, as is used everywhere else in this context.
>

Make it a bool, so that it's intuitively more obvious that true==success?

Paul
