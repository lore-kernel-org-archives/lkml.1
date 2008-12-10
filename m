Return-Path: <linux-kernel-owner+w=401wt.eu-S1755871AbYLJJA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbYLJJA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 04:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755089AbYLJJAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 04:00:49 -0500
Received: from smtp-out.google.com ([216.239.45.13]:21982 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037AbYLJJAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 04:00:48 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=p8etOvU6OTQrNHJPtBlZyXDoeTSikn9hE2W5Z9G2b4Dvfz4stHFkVf0Dtw50b44YL
	u0Tr69VJvgUpsGQbYaZTQ==
MIME-Version: 1.0
In-Reply-To: <62469.10.75.179.62.1228476245.squirrel@webmail-b.css.fujitsu.com>
References: <20081205172642.565661b1.kamezawa.hiroyu@jp.fujitsu.com>
	 <20081205172845.2b9d89a5.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830812050139l5797f16kaf511f831b09e8f4@mail.gmail.com>
	 <62469.10.75.179.62.1228476245.squirrel@webmail-b.css.fujitsu.com>
Date: Wed, 10 Dec 2008 01:00:42 -0800
Message-ID: <6599ad830812100100i54132600he52504b4785542ec@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/4] New css->refcnt implementation.
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 5, 2008 at 3:24 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> The basic rule is that you're only supposed to increment the css
>> refcount if you have:
>>
>> - a reference to a task in the cgroup (that is pinned via task_lock()
>> so it can't be moved away)
>> or
>> - an existing reference to the css
>>
> My problem is that we can do css_get() after pre_destroy() and
> css's refcnt goes down to 0.

But where are you getting the reference from in order to do css_get()?
Which call in mem cgroup are you concerned about?

Paul
