Return-Path: <linux-kernel-owner+w=401wt.eu-S1751211AbXBMJDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751211AbXBMJDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 04:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbXBMJDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 04:03:32 -0500
Received: from smtp-out.google.com ([216.239.45.13]:10263 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbXBMJDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 04:03:31 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=uJQH/L3GCx3N3wq9f2SX/sm9BdvXLIGcso6FjN5gz4wb9Ad6zMWg+lQYyXg4ib3Xd
	oHDeBTjxNpwDCacQl3byQ==
Message-ID: <6599ad830702130103l54f48df0y7c20606d31122a50@mail.gmail.com>
Date: Tue, 13 Feb 2007 01:03:12 -0800
From: "Paul Menage" <menage@google.com>
To: "Pavel Emelianov" <xemul@sw.ru>
Subject: Re: [PATCH 6/7] containers (V7): BeanCounters over generic process containers
Cc: akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru,
       serue@us.ibm.com, vatsa@in.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, winget@google.com,
       containers@lists.osdl.org, devel@openvz.org
In-Reply-To: <45D17C48.9030105@sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070212081521.808338000@menage.corp.google.com>
	 <20070212085104.998727000@menage.corp.google.com>
	 <45D17C48.9030105@sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/13/07, Pavel Emelianov <xemul@sw.ru> wrote:
> menage@google.com wrote:
> > This patch implements the BeanCounter resource control abstraction
> > over generic process containers. It contains the beancounter core
> > code, plus the numfiles resource counter. It doesn't currently contain
> > any of the memory tracking code or the code for switching beancounter
> > context in interrupts.
>
> Numfiles is not the most interesting place in beancounters.
> Kmemsize accounting is much more important actually.

Right, but the memory accouting was a much bigger and more intrusive
patch than I wanted to include as an example.

>
> I have already pointed out the fact that this place
> will hurt performance too much. If we have some context
> on task this context must
>   1. be get-ed without any locking

Would you also be happy with the restriction that a task couldn't be
moved in/out of a beancounter container by any task other than itself?
If so, the beancounter can_attach() method could simply return false
if current != tsk, and then you'd not need to worry about locking in
this situation.

>   2. be settable to some temporary one without
>      locking as well

I thought that we solved that problem by having a tmp_bc field in the
task_struct that would take precedence over the main bc if it was
non-null?

Paul
