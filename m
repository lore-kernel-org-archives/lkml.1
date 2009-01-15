Return-Path: <linux-kernel-owner+w=401wt.eu-S1759294AbZAONfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294AbZAONfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 08:35:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765253AbZAONdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 08:33:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46024 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765538AbZAONdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 08:33:47 -0500
Date: Thu, 15 Jan 2009 14:33:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: roel kluin <roel.kluin@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Brian Gerst <brgerst@gmail.com>, ebiederm@xmission.com,
       cl@linux-foundation.org, rusty@rustcorp.com.au, travis@sgi.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       steiner@sgi.com, hugh@veritas.com
Subject: Re: [patch] add optimized generic percpu accessors
Message-ID: <20090115133312.GA1945@elte.hu>
References: <496C9FB7.9050907@kernel.org> <496D8CEB.5060402@zytor.com> <20090114093834.GA19799@elte.hu> <25e057c00901150204x61c54d9fl91afe23477d1f12f@mail.gmail.com> <496F0F5E.3080404@kernel.org> <20090115113230.GH22850@elte.hu> <496F1FA6.6050204@kernel.org> <20090115122222.GI22850@elte.hu> <496F3577.4020303@kernel.org> <20090115133206.GA31416@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090115133206.GA31416@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> FYI, -tip testing found the following bug with your percpu stuff:
> 
> There's an early exception during bootup, on 64-bit x86:
> 
>   PANIC: early exception 0e rip 10:ffffffff80276855: error ? cr2 6688
> 
>  - gcc version 4.3.2 20081007 (Red Hat 4.3.2-6) (GCC) 
>  - binutils-2.18.50.0.6-2.x86_64
> 
> config attached. You can find the disassembly of lock_release_holdtime() 
> below - that's where it crashed:

the tree i tested it with was:

  d5fd351: x86: misc clean up after the percpu update

	Ingo
