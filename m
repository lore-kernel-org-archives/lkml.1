Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab0BQQEB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 11:04:01 -0500
Received: from mail-iw0-f185.google.com ([209.85.223.185]:45234 "EHLO
	mail-iw0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab0BQQD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 11:03:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CtKaWtpt6bbeQeFmDrWTd1/uo6yAnfGF+zxkddHOKnkFvtKkAxTdx1/ECabbKZE7V3
         9rLmqS5/wQwRt2L2jOy9u6cImIDMqLllt+HZpFvUBfZVDMLSPe43bxhSXrFcWpW0MtWX
         R9pElK/x39mqGm3iwg7I+kKcHupOVs+INtcho=
Date: Wed, 17 Feb 2010 17:03:50 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Roland McGrath <roland@redhat.com>
Cc: Michael Stefaniuc <mstefani@redhat.com>, prasad@linux.vnet.ibm.com,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       Alexandre Julliard <julliard@winehq.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: Regression in ptrace (Wine) starting with 2.6.33-rc1
Message-ID: <20100217160339.GA5041@nowhere>
References: <4B745F5C.5050001@redhat.com> <20100213173323.GB3778@in.ibm.com> <4B7719AC.6040901@redhat.com> <20100214171535.GA5065@nowhere> <4B785952.8020706@redhat.com> <20100214204130.GD5479@nowhere> <4B7881AC.5070209@redhat.com> <20100215115713.GA8907@in.ibm.com> <4B79A27B.6080607@redhat.com> <20100215194724.8B5F519@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100215194724.8B5F519@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 11:47:24AM -0800, Roland McGrath wrote:
> > - The other one with 'locally'/'globally' enabled breakpoints.
> 
> There is no "local/global" enablement.  That distinction is meaningless
> given the way the kernel uses the hardware.  Which of those bits you set
> has no material effect on the watchpoint/trap behavior.  



Yeah.


 
> The only regression is in the observed bit pattern read back from dr7.
> To be 100% compatible, the hw_breakpoint ptrace-compatibility front-end
> should record the state of the useless bits to report back, so the only
> differences from the bit pattern written are whatever ones the real
> hardware would have shown from writing dr7 and reading it back.



Agreed. We have to match the previous ABI, it's a regression.

We have the NULL breakpoint address thing fixed (will push it to Ingo).
We now need to fix the local/global flag storage.

The fastest way to do so is to keep a per thread dr7 variable.
I'm looking at it and will send a fix soon.

We can think about something proper later.

Thanks.

