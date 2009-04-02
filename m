Return-Path: <linux-kernel-owner+w=401wt.eu-S1752233AbZDBOMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbZDBOMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 10:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755213AbZDBOMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:12:35 -0400
Received: from gw.goop.org ([64.81.55.164]:48580 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382AbZDBOMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:12:34 -0400
Message-ID: <49D4C7CE.3060005@goop.org>
Date: Thu, 02 Apr 2009 07:12:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: dada1@cosmosbay.com, mingo@elte.hu, htejun@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, joe@perches.com,
       rusty@rustcorp.com.au
Subject: Re: [PATCH] x86: percpu_to_op() misses memory and flags clobbers
References: <20090402095217.GA30759@gondor.apana.org.au>
In-Reply-To: <20090402095217.GA30759@gondor.apana.org.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>   
>> There's probably not a lot of value in this.  The Intel and AMD 
>> optimisation guides tend to deprecate inc/dec in favour of using 
>> add/sub, because the former can cause pipeline stalls due to its partial 
>> flags update.
>>     
>
> Is this still the case on the latest Intel CPUs?
>   

Yes:

    Assembly/Compiler Coding Rule 32. (M impact, H generality) INC and DEC
    instructions should be replaced with ADD or SUB instructions,
    because ADD and
    SUB overwrite all flags, whereas INC and DEC do not, therefore
    creating false
    dependencies on earlier instructions that set the flags.

    J
