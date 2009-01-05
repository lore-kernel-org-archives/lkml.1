Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbZAER5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbZAER5l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 12:57:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbZAER5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 12:57:32 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:60155 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbZAER5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 12:57:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lCJ7eWhNClC8xkVVRmFobectDfOTkpl6nDJgD5WuUGAjWno332mul30ozSPLp3aD/h
         +8KZJ/PMRjy73ZXVNWnMXWel+oCC2Q4zUiYOY3RZCdNB45WJ75DWLKpQp7inM99V5oQp
         9pGDAoM5dZ3jf3hC1tTIAdSe7FSV7vOdMFNVA=
Date: Mon, 5 Jan 2009 19:57:50 +0200
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] kmemtrace: Use tracepoints instead of markers.
Message-ID: <20090105175750.GB5196@localhost>
References: <cover.1230499486.git.eduard.munteanu@linux360.ro> <0d1bc24fa2c8d9df136cf833a36be2b72340bc8f.1230499486.git.eduard.munteanu@linux360.ro> <20090102205345.GB25473@Krystal> <20090102230116.GB5235@localhost> <20090102234254.GB29623@Krystal> <20090104041018.GB5198@localhost> <20090105160534.GA7708@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105160534.GA7708@Krystal>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 11:05:34AM -0500, Mathieu Desnoyers wrote:
> Hopefully it does, especially when there are no side-effects. Can you
> also try with -Os ?
> 
> Mathieu

Here's the disassembled code when using -Os. It seems it's optimised, as
with -O2. My GCC's version is 4.3.2 (Gentoo Linux).

If you want to test yourself, the output was generated with 'objdump -d
-S -a'.

What do you think?

static void print_that(unsigned long num)
{
	printf("input << 5 == %lu\n", num);
  40062d:	48 c1 e6 05          	shl    $0x5,%rsi
  400631:	bf 5e 07 40 00       	mov    $0x40075e,%edi
  400636:	31 c0                	xor    %eax,%eax
  400638:	e8 6b fe ff ff       	callq  4004a8 <printf@plt>
	sscanf(argv[2], "%lu", &in);

	call_do_something(in);

	return 0;
}
  40063d:	5a                   	pop    %rdx
  40063e:	59                   	pop    %rcx
  40063f:	31 c0                	xor    %eax,%eax
  400641:	5b                   	pop    %rbx
  400642:	c3                   	retq   


	Eduard

