Return-Path: <linux-kernel-owner+w=401wt.eu-S1759325AbYD2K45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325AbYD2K45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 06:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbYD2K4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 06:56:49 -0400
Received: from rv-out-0708.google.com ([209.85.198.247]:26879 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751306AbYD2K4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 06:56:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Qi3AqGasy8wS16Frvc/OR2Q90rtuARjryhE/rhlTXpdtwgHPxeNKEYAsx2LJfJcvNrk2gdqXP/yjCAQfVmrI1r+zo+aUYGZYqcGewz9VoRV5/99sZNoGqZFbuZmxNp1BWQYPHonOH77+sk58QWL+mhEf+YObAoMfHwEaJpf7SYo=
Message-ID: <86802c440804290356l678d3a0cxedcbe21a1f7642d1@mail.gmail.com>
Date: Tue, 29 Apr 2008 03:56:48 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Gabriel C" <nix.or.die@googlemail.com>
Subject: Re: [PATCH 1/2] x86: mtrr cleanup for converting continuous to discrete layout v7
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Mika Fischer" <mika.fischer@zoopnet.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440804290330wd582daetb2a9c41a69f6e028@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804272337.40130.yhlu.kernel@gmail.com>
	 <200804281316.14168.yhlu.kernel@gmail.com>
	 <200804281505.05764.yhlu.kernel@gmail.com>
	 <200804290200.33459.yhlu.kernel@gmail.com>
	 <4816EEA1.6050804@googlemail.com>
	 <86802c440804290330wd582daetb2a9c41a69f6e028@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 3:30 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
> On Tue, Apr 29, 2008 at 2:47 AM, Gabriel C <nix.or.die@googlemail.com> wrote:
>  > Yinghai Lu wrote:
>  >  > some BIOS like to use continus MTRR layout, and may X driver can not add
>  >  > WB entries for graphical cards when 4g or more RAM installed.
>  >  >
>  >  > the patch will change MTRR to discrete.
>  >  >
>  >  > mtrr_chunk_size= could be used to have smaller continuous block to hold holes.
>  >  > default is 256m, could be set according to size of graphics card memory.
>  >  >
>  >  > v2: fix -1 for UC checking
>  >  > v3: default to disable, and need use enable_mtrr_cleanup to enable this feature
>  >  >     skip the var state change warning.
>  >  >     remove next_basek in range_to_mtrr()
>  >  > v4: correct warning mask.
>  >  > v5: CONFIG_MTRR_SANITIZER
>  >  > v6: fix 1g, 2g, 512 aligment with extra hole
>  >  > v7: gran_sizek to prevent running out of MTRRs.
>  >  >
>  >
>  >  With this version ( and patch http://lkml.org/lkml/2008/4/29/97 ) applyed on latest linus git tree
>  >  the box OOPS'es early.
>  >
>  >  Sorry I don't have time right now to write down the part of the OOPS I can see on monitor , I can try to find
>  >  some time later.
>  >
>  >  In any way OOPS'es on __free_one_page+0x191/0x21e
>
>  thanks. found one problem with hole_basek ...
>
>  will send you v8, and hope it will be last version.

please try v8, it should get rid of the 8m entry. it need patch
http://lkml.org/lkml/2008/4/29/97 too.

Thanks

Yinghai Lu
