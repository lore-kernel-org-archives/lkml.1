Return-Path: <linux-kernel-owner+w=401wt.eu-S1755920AbYD2Kav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbYD2Kav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 06:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753778AbYD2Kal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 06:30:41 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:46325 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbYD2Kal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 06:30:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HpVa1hQUZ3N1o9R8HfRVrP8T01ehu+FpAK9KSjXhw3msBKZJ3zJK8y6RD8tAOlUAWlpfipq1MBPaytxCop5GKNPLKGv5RHlpgI2SCnRoLoO9HNxmxxqgE6jm/t8+tqgerACAUbrBjOGJagoGY33GPdvATy5jKJ1veu4DK3yjn1E=
Message-ID: <86802c440804290330wd582daetb2a9c41a69f6e028@mail.gmail.com>
Date: Tue, 29 Apr 2008 03:30:39 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Gabriel C" <nix.or.die@googlemail.com>
Subject: Re: [PATCH 1/2] x86: mtrr cleanup for converting continuous to discrete layout v7
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Mika Fischer" <mika.fischer@zoopnet.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4816EEA1.6050804@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804272337.40130.yhlu.kernel@gmail.com>
	 <200804281316.14168.yhlu.kernel@gmail.com>
	 <200804281505.05764.yhlu.kernel@gmail.com>
	 <200804290200.33459.yhlu.kernel@gmail.com>
	 <4816EEA1.6050804@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 2:47 AM, Gabriel C <nix.or.die@googlemail.com> wrote:
> Yinghai Lu wrote:
>  > some BIOS like to use continus MTRR layout, and may X driver can not add
>  > WB entries for graphical cards when 4g or more RAM installed.
>  >
>  > the patch will change MTRR to discrete.
>  >
>  > mtrr_chunk_size= could be used to have smaller continuous block to hold holes.
>  > default is 256m, could be set according to size of graphics card memory.
>  >
>  > v2: fix -1 for UC checking
>  > v3: default to disable, and need use enable_mtrr_cleanup to enable this feature
>  >     skip the var state change warning.
>  >     remove next_basek in range_to_mtrr()
>  > v4: correct warning mask.
>  > v5: CONFIG_MTRR_SANITIZER
>  > v6: fix 1g, 2g, 512 aligment with extra hole
>  > v7: gran_sizek to prevent running out of MTRRs.
>  >
>
>  With this version ( and patch http://lkml.org/lkml/2008/4/29/97 ) applyed on latest linus git tree
>  the box OOPS'es early.
>
>  Sorry I don't have time right now to write down the part of the OOPS I can see on monitor , I can try to find
>  some time later.
>
>  In any way OOPS'es on __free_one_page+0x191/0x21e

thanks. found one problem with hole_basek ...

will send you v8, and hope it will be last version.

YH
