Return-Path: <linux-kernel-owner+w=401wt.eu-S1762861AbYD2NRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762861AbYD2NRH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:17:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754510AbYD2NQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:16:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:41038 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbYD2NQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:16:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cwm7zysVJ+3phdH5Q9YUBPAP3gl4wywiQhYfjfZQew3gXC1LhdUxgOR9VwPhQSzUADOWgp2wgj3Ccn96l6McjrWzVhgbcJ3CCQkeMTA2224Kivlchx+Kz97W0KNMcxvYI1Co8ym6l+tiU1+a3Vj1k5An/8s6QB7Zn2Xc1QRLzhk=
Message-ID: <e2e108260804290616l489ac8c2udcb2e80fc268b72b@mail.gmail.com>
Date: Tue, 29 Apr 2008 15:16:52 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: ego@in.ibm.com
Subject: Re: [PATCH 1/8] lockdep: fix recursive read lock validation
Cc: linux-kernel@vger.kernel.org, "Zdenek Kabelac" <zdenek.kabelac@gmail.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Oleg Nesterov" <oleg@tv-sign.ru>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Srivatsa Vaddagiri" <vatsa@in.ibm.com>
In-Reply-To: <20080429125750.GB23562@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080429125659.GA23562@in.ibm.com>
	 <20080429125750.GB23562@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 2:57 PM, Gautham R Shenoy <ego@in.ibm.com> wrote:
> Subject: lockdep: fix recursive read lock validation
>  This means that the following sequence is now invalid, whereas previously
>  it was considered valid:
>
>   rlock(a); rlock(b); runlock(b); runlock(a)
>   rlock(b); rlock(a);

Why are you marking this sequence as invalid ? Although it can be
debated whether it is good programming practice to be inconsistent
about the order of read-locking, the above sequence can't be involved
in a deadlock.

Bart.
