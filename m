Return-Path: <linux-kernel-owner+w=401wt.eu-S1755108AbZJVL1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbZJVL1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 07:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754976AbZJVL1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 07:27:50 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:35960 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225AbZJVL1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 07:27:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kGpMKmmniok+vYYCtpx6z5cnOD3mZ4S+6Ht/Ai4ZN9/8plVin3cMWjsMWh7n9aoPD/
         mAY/dNDTphDgP/AfwYFYcbINhXmVITQdyMwjzUe7RxxQ+63DxDNdYhLEx1t4hpYy+alS
         6LDbWIPFzCGI6HM1UJyVAvEIp2BRKF6Wmiklg=
Date: Thu, 22 Oct 2009 13:27:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Leonidas ." <leonidas137@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Can current macro be accessed from interrupt context?
Message-ID: <20091022112746.GA4928@nowhere>
References: <f22d86810910220410r33002b5ei403ddf6632254472@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f22d86810910220410r33002b5ei403ddf6632254472@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 04:10:49AM -0700, Leonidas . wrote:
> Hello,
> 
> Going through UTLK, it says that current macro makes sense only in
> case of process context,
> in case of interrupt context it is invalid.


Indeed, usually it makes only sense in process context.

 
> But current would still be pointing to interrupted process right? The
> pointer would still be valid?



Yeah, unless you irq handler executes in a threaded interrupt, in
which case current will be pointing to the given irq thread.

There are few tiny cases where it is unsafe to deref "current",
such as the very beginning of a cpu's awakening, when the per cpu
datas are not yet ready for this cpu.


> Can I safely assume that whether or not interrupt handlers are
> executing on separate stacks or
> interrupted threads stack, current macro can be accessed from interrupt context?


Yep.
For example we do that in the function graph tracer. Because we store return
addresses of functions in the "current" task structure. Even if the task
is interrupted, it still makes sense to use current because we want
to know the flow of execution as a linear thing per cpu, the interrupt
is part of that flow

I hope that helps.

Frederic.

