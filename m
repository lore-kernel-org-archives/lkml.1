Return-Path: <linux-kernel-owner+w=401wt.eu-S1757538AbYFPSSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538AbYFPSSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 14:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbYFPSSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 14:18:12 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:62656 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbYFPSSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 14:18:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=qSLuJ9pKJ4qokH2195IXsji6DE8rmvdCdUh1ZYhnqrorVIy9p6Pa5IrLtsUsrT6ZLd
         KkOdwgqOFR++ALni3qBaOPwPUmkR33anUGW/B568r990N3L4KCgKyfzb8kwxW6dFuwV8
         XTHdcPV+688Di0R57YIEEZpwCrFd32GRdnsf4=
Message-ID: <84144f020806161118n70a876aeyb5ccac7b1e21d842@mail.gmail.com>
Date: Mon, 16 Jun 2008 21:18:11 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: [PATCH 2/3] relay: Fix race condition which occurs when reading across CPUs.
Cc: "Eduard - Gabriel Munteanu" <eduard.munteanu@linux360.ro>,
       "Mathieu Desnoyers" <compudj@krystal.dyndns.org>,
       "Tom Zanussi" <tzanussi@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, righi.andrea@gmail.com
In-Reply-To: <20080616164609.GM20851@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080613040958.4f52ee29@linux360.ro>
	 <1213417601.8237.37.camel@charm-linux>
	 <20080614181103.17617db1@linux360.ro> <20080616122249.GB18561@Krystal>
	 <20080616162212.27a8c119@linux360.ro>
	 <20080616164609.GM20851@kernel.dk>
X-Google-Sender-Auth: 8c7a3e0988b78906
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

On Mon, Jun 16 2008, Eduard - Gabriel Munteanu wrote:
>> In any case, if we use relay in a hot path, we are doing debugging, so
>> a couple of atomic operations won't be a big problem. Along with
>> setting affinity, this shouldn't be a problem.

On Mon, Jun 16, 2008 at 7:46 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> Ehm no, that is a completely false claim. Relay speed does matter, a
> great deal. We rely heavily on eg blktrace being as ligt weight as
> possible to capture millions of events in a very short time frame
> without impacting performance too much. Relay is NOT just for debugging.
>
> So I completely agree with Mathieu here, and I'm not a big fan of the
> proposed solution.

OK, so we just document that fact that you're not supposed to read
from different CPU and be done with that? Or do you have any
alternative fix in mind?
