Return-Path: <linux-kernel-owner+w=401wt.eu-S1755620AbYERJNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbYERJNo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 05:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751513AbYERJNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 05:13:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:50089 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbYERJNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 05:13:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=TVupInBtJ2RJYcrfINgLYq5V30H2MyBN8rEsQGBpnrmuUmKdBRFOymRiGENlL7ar24UU0n2YkzZzNuYF8YDQaWMNDg6wowk6uEZwtUtYvQ5w5zqfZRNevfsEQd42k/eIFpy3duA8yECxBO96UM9eGfJ1cp12n6NNBE05J5Us7qw=
Date: Sun, 18 May 2008 13:13:26 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Tom Spink <tspink@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] x86: merge nmi_32-64 to nmi.c
Message-ID: <20080518091326.GD6948@cvg>
References: <20080517192200.GA6914@cvg> <7b9198260805171328u555eec17t3597f3378edbda88@mail.gmail.com> <Pine.LNX.4.55.0805172148380.10067@cliff.in.clinika.pl> <alpine.LFD.1.10.0805172331030.18798@apollo.tec.linutronix.de> <482FD9F2.8080204@goop.org> <20080518073804.GB6948@cvg> <482FE9CA.4090804@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482FE9CA.4090804@goop.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Jeremy Fitzhardinge - Sun, May 18, 2008 at 09:33:14AM +0100]
> Cyrill Gorcunov wrote:
>> I think I would prefer Maciej's advice then but with capital
>> letters (to easy distinguish them and point an attention) like
>>
>> #ifdef CONFG_X86_64
>> #define CPU_64 1
>> #else
>> #define CPU_64 0
>> #endif
>
> The other problem in this case is that cpu_pda() doesn't exit for 32-bit, 
> so it probably won't compile anyway.  But in general, I fully support using 
> if (constant) over #ifdef (?: not so much).
>
>    J
>

yep, you're right - gcc doesn't throw it out but tries to evaluate in any
case so this trick with () ? : ; would not work :( or we should define
dummy types for this case...

		- Cyrill -
