Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbYHVN4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbYHVN4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 09:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbYHVN41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 09:56:27 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:62414 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbYHVN40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 09:56:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vH9I5gHHITZSVVXz+x1fnN/2l/emmTSCtyNhNTwlqQU03g1w03SoH7f+4YglNcFIXw
         3ktaFaNhoSNMaa2hTvcifXyJ0uIuHGaQDDW+TQb+azVsjnsdHdS1RYm0kB95/FyUJqxG
         TAgCf8UpcTU8CXVF8DfTg2W6AP3Ns4fRK0DJU=
Message-ID: <19f34abd0808220656x42006849ta29c423beb6bb7d4@mail.gmail.com>
Date: Fri, 22 Aug 2008 15:56:24 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: Bug: "bad unlock balance detected" 2.6.27-rc3-next-20080820
Cc: "jay kumar" <jaykumarks@gmail.com>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org
In-Reply-To: <24926.1219410297@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6f31812b0808210004i63b3273ehf65ce9eb139256f0@mail.gmail.com>
	 <19f34abd0808210110s4dd2ec12r6d3044e45a21d67@mail.gmail.com>
	 <24926.1219410297@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 3:04 PM, David Howells <dhowells@redhat.com> wrote:
>> I couldn't reproduce your original failure, but I've attempted to fix
>> it by reordering the mutex unlock and bprm free and removing the
>> extraneous unlock (see attached patch; it boots for me without
>> errors).
>
> Your patch ought to throw up its own lock failure.  You've added a
> mutex_unlock() call to the execve success path, but you haven't removed one
> from install_exec_creds().  Also, this patch is not sufficient as it doesn't
> do anything for compat_do_execve().

Ah, right. Thanks for the review anyway :-)

I didn't realize the lock should be held across the function call, I
will do a bit more research next time :-)

It seems to be a bit tricky. It would probably be nice to have
somebody else look at it too and verify that it is now indeed correct?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
