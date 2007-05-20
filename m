Return-Path: <linux-kernel-owner+w=401wt.eu-S1757168AbXETTB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168AbXETTB4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 15:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755065AbXETTBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 15:01:49 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:56120 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbXETTBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 15:01:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bJFjblScLabT7wCrF/W0cp9k68ux+U1x9FtWnwAGTEQFDkKYHIT7+QdWaQildS0bcdKKWbPP8hF3oYxtkSelMAYXEtqoUJdbRhKcy1wjU2ST+kWHFRuLP9LNymL+brhq1gHu7CWK4ziftgNXC5Zn2PJ8/kazQdiCkAXYGYSiod8=
Message-ID: <a36005b50705201201y724ac400u5581df86c62d9de2@mail.gmail.com>
Date: Sun, 20 May 2007 12:01:47 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Eric Dumazet" <dada1@cosmosbay.com>
Subject: Re: first little problem with private futexes
Cc: "Ulrich Drepper" <drepper@redhat.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <46509924.8020904@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <465095E5.4050508@redhat.com> <46509924.8020904@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/20/07, Eric Dumazet <dada1@cosmosbay.com> wrote:
> > 1.  do nothing, always use the shared futexes.  Not very attractive IMO
>
> Why do you find this non attractive ?
>
> How is it performance critical ?

You should know better than any other that the problem is not that the
problem itself is the only one affected.  If threads terminate all
other programs and threads are affected since the global locks for the
shared futexes are needed.  That's the case I'm concerned about.  It's
not really about a single app creating many many threads over and over
again.  It's about many apps which do use threads (and that number
will have to rise) starts and stop threads at a reasonable rate.  It's
just one more unnecessary point of contact between concurrently
running apps.
