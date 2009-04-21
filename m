Return-Path: <linux-kernel-owner+w=401wt.eu-S1758680AbZDUTHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680AbZDUTHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 15:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756970AbZDUTHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 15:07:19 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:48077 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080AbZDUTHS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 15:07:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=lty6TF3cz/HEaU/D9v8Dqlaa5Arr/kLUiuzVyfoEjT6WtftET8jmnljT4zLhjJ+t5F
         zDDgkgC7McLMAUPMwCpyN0LmD2YDP4NvUDdHD0NEZA6iBjvFJeHqNgOIjhQcGN47pcPX
         cA2DVrM9C5tSC4Ktwv3kI4R3Cxvg4IAL0Of68=
MIME-Version: 1.0
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA39EC57748@orsmsx505.amr.corp.intel.com>
References: <49ecf25e2378234eed@agluck-desktop.sc.intel.com>
	 <84144f020904202251n616f188k80c6ce7d974d8b00@mail.gmail.com>
	 <alpine.DEB.1.10.0904211034550.19969@qirst.com>
	 <84144f020904211125v68b98df4ke1c04bc29df65fda@mail.gmail.com>
	 <57C9024A16AD2D4C97DC78E552063EA39EC57748@orsmsx505.amr.corp.intel.com>
Date: Tue, 21 Apr 2009 22:07:16 +0300
X-Google-Sender-Auth: 78f3e0677d5da03e
Message-ID: <84144f020904211207q736bfc44n4cd622536cd0a67@mail.gmail.com>
Subject: Re: linux-next ia64 build problems in slqb
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Christoph Lameter <cl@linux.com>, Nick Piggin <npiggin@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "randy.dunlap_ocs10g@oracle.com" <randy.dunlap_ocs10g@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>,
       "iwamatsu.nobuhiro@renesas.com" <iwamatsu.nobuhiro@renesas.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Tue, Apr 21, 2009 at 9:45 PM, Luck, Tony <tony.luck@intel.com> wrote:
>> Interesting. What exactly is an UP NUMA machine?
>
> UP + NUMA is a special case of memory-only nodes.  There are
> some (crazy?) customers with problems that require very large
> amounts of memory, but not very much cpu horse power.  They
> buy large multi-node systems and populate all the nodes with
> as much memory as they can afford, but most nodes get zero
> cpus.

Oh, cool. Thanks for the explanation!

On Tue, Apr 21, 2009 at 9:45 PM, Luck, Tony <tony.luck@intel.com> wrote:
>> Anyway, I'm more than
>> happy to apply a tested patch to fix up SLQB. Nick?
>
> I'm trying to check whether http://lkml.org/lkml/2009/4/20/30
> fixes things.  It certainly solves the complilation problem,
> but I'm running into apparently unrelated issues trying to
> boot linux-next kernels.

Great! You can try it on top of the "topic/slqb/core" branch of

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git

if you want. It's basically plain 2.6.30-rc1 plus SLQB.

One minor nit: the patch should define an empty static inline of
claim_remote_free_list() for the !SMP case. I can fix it at my end
before merging, though, if necessary.

                                       Pekka
