Return-Path: <linux-kernel-owner+w=401wt.eu-S1752367AbYDEHk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbYDEHk1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 03:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbYDEHkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 03:40:20 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:17327 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbYDEHkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 03:40:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=cqF+LSOo8cJhisjvVxgV+z6e2Repb2Hmn4AN0CPZrs5+n0jCv+g3b6kyq0KKQwQLA/0dg3pZpF1oqINxcoYqjg0IANDLmbSnXLlce59GGNWQCCSbdDnycosCSZHdg1N2mDE36POXyN0nw4Zt2CsIHl+HNOr+ezMeBp9E7CNK38M=
Message-ID: <84144f020804050040r6fd8b9a8h6d344b4ea53cb3e5@mail.gmail.com>
Date: Sat, 5 Apr 2008 10:40:18 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Avi Kivity" <avi@qumranet.com>
Subject: Re: mmiotrace bug: recursive probe hit
Cc: "Pekka Paalanen" <pq@iki.fi>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>, "Christoph Hellwig" <hch@infradead.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Pavel Roskin" <proski@gnu.org>, "Steven Rostedt" <rostedt@goodmis.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>, vegard.nossum@gmail.com
In-Reply-To: <47F72C12.9020701@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080309164050.2194461e@daedalus.pq.iki.fi>
	 <20080328222500.21863a44@daedalus.pq.iki.fi>
	 <20080330202608.054702a4@daedalus.pq.iki.fi>
	 <20080404000701.70bbc1a4@daedalus.pq.iki.fi>
	 <47F72C12.9020701@qumranet.com>
X-Google-Sender-Auth: 2cfef2da9f3bf151
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 5, 2008 at 10:36 AM, Avi Kivity <avi@qumranet.com> wrote:
> It should not be too difficult to modify x86_emulate.c to do everything
> through a function vector.  However there is a simpler (for you) solution:
> run the driver-to-be-reverse-engineered in a kvm guest, and modify kvm
> userspace to log accesses to mmio regions.  This requires the not-yet-merged
> pci passthrough support.  You can reverse engineer Windows drivers with this
> as well.
>
>  This won't work for kmemcheck smp though.

For kmemcheck, I'd prefer the per-CPU page tables suggested by Ingo.
I'm having hard time understanding why that's a "ugly hack" compared
to using kvm for this...
