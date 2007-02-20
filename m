Return-Path: <linux-kernel-owner+w=401wt.eu-S1161076AbXBTXgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161076AbXBTXgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 18:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161091AbXBTXgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 18:36:36 -0500
Received: from smtp-out.google.com ([216.239.45.13]:57411 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161076AbXBTXgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 18:36:35 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=RC1IcSrCMD6HhkUE/cPuLhnljhgt18EpyPlrANwOl33bs2vux8VlUqgP2VMlUalGe
	wv/F0Cb5kUgB/9fhjasCQ==
Message-ID: <6599ad830702201536t7df92965pba0eb4f147742d12@mail.gmail.com>
Date: Tue, 20 Feb 2007 15:36:18 -0800
From: "Paul Menage" <menage@google.com>
To: "Sam Vilain" <sam@vilain.net>
Subject: Re: [PATCH 0/7] containers (V7): Generic Process Containers
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, akpm@osdl.org, pj@sgi.com,
       sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       vatsa@in.ibm.com, containers@lists.osdl.org, winget@google.com,
       rohitseth@google.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <45DB7F55.20008@vilain.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070212081521.808338000@menage.corp.google.com>
	 <45D0EC68.9090009@vilain.net>
	 <6599ad830702121515p10bc1b58kf1d29367b9b18016@mail.gmail.com>
	 <m1wt2c4ttj.fsf@ebiederm.dsl.xmission.com>
	 <6599ad830702200955l10f3c71aucff1d4b815e1a1e7@mail.gmail.com>
	 <m1bqjo4ogj.fsf@ebiederm.dsl.xmission.com>
	 <6599ad830702201447t711cdf00u3704a0dac8780f91@mail.gmail.com>
	 <45DB7F55.20008@vilain.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/20/07, Sam Vilain <sam@vilain.net> wrote:
> Paul Menage wrote:
> >> No. A reverse mapping is not needed and is not interesting.
> >>
> > ... to you.
> >
>
> You're missing the point of Eric's next sentence.  If you can achieve
> everything you need to achieve and get all the information you are after
> without it, then it is uninteresting.

Yes, you can do it with an exhaustive trawl of /proc. That can be very
expensive on busy machines.

>
> >> As long as I can walk all processes and ask what namespace are
> >> you in I don't care.
> >>
> >
> > How do you currently do that?
> >
>
> Take a look at /proc/PID/mounts for example.

That doesn't tell you what mounts namespace a process is in - it tells
you what the process can *view* in the namespace.

>
> So make helpers.  Macros.  Anything, just don't introduce model
> limitations like the container structure, because we've already got the
> structure; the nsproxy.
>

As I mentioned in another email, nsproxy is fine for things that don't
need explicit configuration or reporting, or which already have
configuration methods (such as fork(), mount(), etc) available, and
which don't need to support movement of processes between different
"namespaces". If it was extended to support the
naming/config/movement, then it would be fine to use it as the
equivalent of a container.

I'd actually be interested in trying to combine my container object
and the nsproxy object into a single concept.

Paul
