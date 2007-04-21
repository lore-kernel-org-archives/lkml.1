Return-Path: <linux-kernel-owner+w=401wt.eu-S1752354AbXDUQLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbXDUQLc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 12:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbXDUQLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 12:11:32 -0400
Received: from ik-out-1112.google.com ([66.249.90.183]:23180 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbXDUQLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 12:11:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OrxGjNz8GgrnG7RfqCtTD6uFXEkWbb5Dvr+fHaynvV3PxgdIT4qcRLwqw5AHlt/KFvAAMRe59CrRaSmZbC++jrBRe+39uxazZr9gzSiLzmLmQJfdwyj4BUByhNs5st2n8a6HomqaOnXODOJm8lZnNJYiKiUmqS6UEuE3P+bzCq8=
Message-ID: <a781481a0704210911g5921d3fdm8e0983d7d36535b3@mail.gmail.com>
Date: Sat, 21 Apr 2007 21:41:28 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Cedric Le Goater" <clg@fr.ibm.com>
Subject: Re: [Devel] Re: [PATCH] bluetooth bnep: Convert to kthread API.
Cc: devel@openvz.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph@smtp2.linux-foundation.org, Holtmann <marcel@holtmann.org>,
       linux-kernel@vger.kernel.org, Hellwig <hch@infradead.org>,
       containers@lists.osdl.org, Marcel@smtp2.linux-foundation.org,
       "Oleg Nesterov" <oleg@tv-sign.ru>
In-Reply-To: <4628B414.6000906@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	 <1176969596686-git-send-email-ebiederm@xmission.com>
	 <20070419162459.af7a182c.akpm@linux-foundation.org>
	 <462893F4.1000005@fr.ibm.com> <4628B414.6000906@fr.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 4/20/07, Cedric Le Goater <clg@fr.ibm.com> wrote:
> Cedric Le Goater wrote:
> > Andrew Morton wrote:
> >> On Thu, 19 Apr 2007 01:58:51 -0600
> >> "Eric W. Biederman" <ebiederm@xmission.com> wrote:
> >>>
> >>>
> >>> +   task = kthread_run(bnep_session, s, "kbnepd %s", dev->name);
> >> It's unusual to have a kernel thread which has a space in its name.  That
> >> could trip up infufficient-defensive userspace tools.

But all kernel threads are supposed to be only *in-kernel*
implementation details. Isn't a userspace tool whose behaviour relies
on the existence (or even the knowledge of the existence) of any
kernel thread *broken by design*?

> > but we can't just change it, can we ? i could be used by a user space tool
> > to check if the thread is running.

Yes, so although userspace shouldn't be bothering with kernel threads
in the first place, that does not mean that such tools do not exist.
So we'll have to live with this (unfortunate) naming for some time,
till we can get rid of it later.

Which is similar to the habit of some kernel threads in there that
actually *do* want to export the knowledge of their existence (and
even a signals-based interface!) to userspace. Eric did receive some
nacks on his patches that tried to remove the signals business from
kernel threads on this account, but perhaps that too is something that
we could get rid of later (hopefully by that time those using signals
in kernel threads would have realized their folly and shifted to
something else :-)

Satyam
