Return-Path: <linux-kernel-owner+w=401wt.eu-S1760171AbZKGET3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760171AbZKGET3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 23:19:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760137AbZKGET2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 23:19:28 -0500
Received: from mail-px0-f179.google.com ([209.85.216.179]:61507 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760135AbZKGET1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 23:19:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Qch59ioxqiw28J8if2ULzuZnIr7nz4X9xRGmj3hJtNxoGUf/hAkyu351s+8HOUtwVw
         gXS5e9vW90xU5vILgv1DhycxhN1t8IUTqj7n0h0E84KjcDspIrgR4liNiTtokWKEL5Xb
         kmz5cbwjnkSfbt/qaYCHKkuclg9eBkPErXq+U=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0911061209520.5187@V090114053VZO-1>
References: <alpine.DEB.1.10.0911051417370.24312@V090114053VZO-1>
	 <alpine.DEB.1.10.0911051419320.24312@V090114053VZO-1>
	 <28c262360911060741x3f7ab0a2k15be645e287e05ac@mail.gmail.com>
	 <alpine.DEB.1.10.0911061209520.5187@V090114053VZO-1>
Date: Sat, 7 Nov 2009 13:19:33 +0900
Message-ID: <28c262360911062019q254f7541lbdc3d94491a69bd6@mail.gmail.com>
Subject: Re: Subject: [RFC MM] mmap_sem scaling: Use mutex and percpu counter 
	instead
From: Minchan Kim <minchan.kim@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: npiggin@suse.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 7, 2009 at 2:10 AM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> On Sat, 7 Nov 2009, Minchan Kim wrote:
>
>> How about change from 'mm_readers' to 'is_readers' to improve your
>> goal 'scalibility'?
>
> Good idea. Thanks. Next rev will use your suggestion.
>
> Any creative thoughts on what to do about the 1 millisecond wait period?
>

Hmm,
it would be importatn to prevent livelock for reader to hold lock
continuously before
hodling writer than 1 msec write ovhead.
First of all, After we solve it, second step is that optimize write
overhead, I think.

-- 
Kind regards,
Minchan Kim
