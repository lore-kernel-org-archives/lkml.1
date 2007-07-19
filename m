Return-Path: <linux-kernel-owner+w=401wt.eu-S935645AbXGSDoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935645AbXGSDoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 23:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757479AbXGSDoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 23:44:30 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:16898 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289AbXGSDo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 23:44:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=PrKj9vQeeziXIr6AzCrQAXnlGi9n5dyFrfaWq4nfEOewMKxFDd+MTA6zyOql3uFjo3m/rejaAeR9LG+oMbHsA5HTjufcel9HDfO0S32mmuppD8Nbno3EGF18cpngN7ud8cCBCDau91Tn1Gv+cAqtf+I05bXdfZyrwpG2d+VAs1A=
Message-ID: <661de9470707182044h16623776ma70bf3a078cead8d@mail.gmail.com>
Date: Thu, 19 Jul 2007 09:14:28 +0530
From: "Balbir Singh" <balbir@linux.vnet.ibm.com>
To: "Paul Menage" <menage@google.com>
Subject: Re: Containers: css_put() dilemma
Cc: dhaval@linux.vnet.ibm.com, "Pavel Emelianov" <xemul@sw.ru>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "Paul Jackson" <pj@sgi.com>,
       "Linux Containers" <containers@lists.osdl.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <6599ad830707181615w4f2e4078j58473090691e36eb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <469BBE00.8000709@linux.vnet.ibm.com>
	 <469C99D1.7090807@linux.vnet.ibm.com>
	 <6599ad830707170849v11fe8cecs6d172cd38d247e09@mail.gmail.com>
	 <469CFF2B.1080702@linux.vnet.ibm.com>
	 <6599ad830707171044u38c0a940r12d2bc80b475ead4@mail.gmail.com>
	 <469D066B.6050606@linux.vnet.ibm.com>
	 <6599ad830707171126o7c431277p84f532d0122a8a98@mail.gmail.com>
	 <469D9728.2080701@linux.vnet.ibm.com>
	 <469DA57F.9050302@linux.vnet.ibm.com>
	 <6599ad830707181615w4f2e4078j58473090691e36eb@mail.gmail.com>
X-Google-Sender-Auth: db9f4178d5d97c9b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/19/07, Paul Menage <menage@google.com> wrote:
> On 7/17/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> >
> > Thinking out loud again, can we add can_destroy() callbacks?
> >
>
> What would the exact semantics of such a callback be?
>
> Since for proper interaction with release agents we need the subsystem
> to notify the framework when a subsystem object becomes releasable
> (currently as part of css_put()), what would a can_destroy() callback
> let you do that you couldn't do just by taking an extra css refcount
> to prevent destruction and releasing that refcount to allow
> destruction?

I was thinking along those lines before you mentioned that the next
version of css_put() will not block. The advantage I see of
can_destory() is that it allows subsystems to do their own reference
counting and decide whether they are ready to be deleted or not. The
other advantage I see is that it can act like a prepare to be deleted
phase for the controller, the controller might decide to take some
action in the can_destroy() phase, like the memory controller could
decide to start reclaiming all  the remaining page cache pages.

BTW, do you know upfront as to when the next set of container
enhancement patches will be ready? The css_put() issue is blocking us
currently.

Balbir
