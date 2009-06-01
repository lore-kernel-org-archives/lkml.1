Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbZFAOqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbZFAOqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 10:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbZFAOqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 10:46:04 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41303 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbZFAOqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 10:46:03 -0400
In-Reply-To: <4A23A72E.3020506@gmail.com>
References: <1243849610.2234.3.camel@system> <4A23A690.6070504@gmail.com> <4A23A72E.3020506@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Eric Paris <eparis@redhat.com>, Kylene J Hall <kylene@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Reiner Sailer <sailer@watson.ibm.com>, serue@linux.vnet.ibm.com,
       vibi_sreenivasan@cms.com, safford@watson.ibm.com
MIME-Version: 1.0
Subject: Re: [Fwd: Re: [PATCH]:RESEND : Return proper error value on failure of
 dentry_open]
X-KeepSent: 4496A6A3:97A7AC73-852575C8:004E887B;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5 December 05, 2008
Message-ID: <OF4496A6A3.97A7AC73-ON852575C8.004E887B-852575C8.0051176D@us.ibm.com>
From: Mimi Zohar <zohar@us.ibm.com>
Date: Mon, 1 Jun 2009 10:45:43 -0400
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Release 8.5|December 05, 2008) at
 06/01/2009 10:45:53,
	Serialize complete at 06/01/2009 10:45:53
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jirislaby@gmail.com> wrote on 06/01/2009 06:02:22 AM:

> Re: [Fwd: Re: [PATCH]:RESEND : Return proper error value on failure of 
dentry_open]
> 
> On 06/01/2009 11:59 AM, Jiri Slaby wrote:
> > On 06/01/2009 11:46 AM, vibi sreenivasan wrote:
> >>>>>     mutex_unlock(&iint->mutex);
> >>>>> -   if (file)
> >>>>> +   if (!IS_ERR(file))
> >>>>>        fput(file);
> >>>>
> >>>> No, IS_ERR won't catch NULL and there is 'file = NULL' on the
> >>>> dentry_open fail path.
> >> Can you please point out that line number in fs/open.c
> > 
> > Aha, you use linus's git. This has been fixed by
> > f06dd16a03f6f7f72fab4db03be36e28c28c6fd6
> > (IMA: Handle dentry_open failures)
> > in -next.
> 
> [But the fix in -next still misses 'return 0' -> 'return rc' which I
> though you had tried to change.]

At this point, we're just collecting measurements, not appraising 
them. The return code will be the result of appraise_measurement(). 
For now, the dentry_open shouldn't fail, but if it does, we probably
should audit it.

Mimi Zohar
