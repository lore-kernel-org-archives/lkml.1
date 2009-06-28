Return-Path: <linux-kernel-owner+w=401wt.eu-S1754726AbZF1JMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbZF1JMF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 05:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbZF1JLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 05:11:53 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:48794 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbZF1JLw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 05:11:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=FlluCAA15fBCA+IhdZk3jv/A1yxhpTBHBcLhuCaRpH2wshF5Yz+ZM9XQTk8lTMtGHL
         niCl1I9vOryEnVkVDZm/cPoLCaDCj02KcwOWi/k0pTRjFiNlhO1svOfAZGt+SJVNTxgl
         GPdsrneYtGdfKD/oPYYLzGHO90cxCnbKPJ5v0=
MIME-Version: 1.0
In-Reply-To: <20090618223238.4d6b6707@infradead.org>
References: <20090614173331.18f01123@infradead.org>
	 <b6c5339f0906181008v1cd4b06aof866ea9a91d2eb84@mail.gmail.com>
	 <20090618223238.4d6b6707@infradead.org>
Date: Sun, 28 Jun 2009 05:11:54 -0400
X-Google-Sender-Auth: d03fd49edc5361b7
Message-ID: <b6c5339f0906280211n21287f68p6455890fd860c44@mail.gmail.com>
Subject: Re: kerneloops.org report for the week of June 14 2009
From: Bob Copeland <me@bobcopeland.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, tglx@tglx.de, alan@lxorguk.ukuu.org.uk,
       rjw@sisk.pl, netdev@vger.kernel.org, mingo@elte.hu, dwmw2@infradead.org,
       alsa-devel@alsa-project.org, dri-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 1:32 AM, Arjan van de Ven<arjan@infradead.org> wrote:
> On Thu, 18 Jun 2009 13:08:39 -0400
> Bob Copeland <me@bobcopeland.com> wrote:
>> > Rank 9: minstrel_get_rate (warning)
>>
>> I believe this is fixed by http://lkml.org/lkml/2009/6/5/269, now
>> in pre-2.6.31.  Hmm, odd though, we should be seeing reports from
>> other wireless drivers since it's a general memory corruption
>> unrelated to ath5k (but not all use the mac80211 rate controllers).
>
> well.. out of the 534 reports or so that I have by now... 525 have
> ath5k loaded.....
>
> it's not 100% but it'd pretty close.

Indeed, I can replicate this now, looks like some kind of race condition
since it's looking for a rate in the 5 ghz band while I'm communicating
with a 2 ghz AP (during a scan perhaps?).  The warning is harmless but
there is some underlying issue to be fixed.

-- 
Bob Copeland %% www.bobcopeland.com
