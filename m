Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905AbYGGLJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbYGGLJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 07:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbYGGLJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 07:09:04 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:3086 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbYGGLJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 07:09:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=s3wBskvFJ0kPPGFBaTPfOblEFTVcCFCL31ekVucxQEyotocDrqgueMXS8fE6MvtJ/d
         EvgkTKk31w3nI3TxPl/ctl5BUjzuM1cQf9obGVLF+wwaHNsvaXcKTdGCpFTUAVN22rxw
         EuZef/i+xqIdb1B82VioBZtSNqc18nnx4lwAQ=
Message-ID: <6e0cfd1d0807070408ybea080ewa75ed1f1a8f9326c@mail.gmail.com>
Date: Mon, 7 Jul 2008 13:08:53 +0200
From: "Martin Schwidefsky" <schwidefsky@googlemail.com>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: Lockless/Get_User_Pages_Fast causes Xorg 1.4.99.* to lock
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>, benh@kernel.crashing.org,
       cotte@de.ibm.com, "Zan Lynx" <zlynx@acm.org>,
       "Ryan Hope" <rmh3093@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0807071134090.21480@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48f7fe350807032326l1d68c94l531e44c09693b989@mail.gmail.com>
	 <486E4FD8.4010102@acm.org>
	 <Pine.LNX.4.64.0807042112130.16912@blonde.site>
	 <200807071806.11630.nickpiggin@yahoo.com.au>
	 <Pine.LNX.4.64.0807071134090.21480@blonde.site>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 7, 2008 at 12:39 PM, Hugh Dickins <hugh@veritas.com> wrote:
> On Mon, 7 Jul 2008, Nick Piggin wrote:
>>
>> I think we need a similar fix for s390 too. If so, then it really should
>> get into 2.6.26, but this late in the release, I hope an s390 maintainer
>> might be able to test and verify the fix?
>
> Wow, yes, I hadn't realized s390 is ahead of the game there: glad you're
> back to spot that.  But yes, we'd prefer maintainer to confirm and push.
>
>
> [PATCH]] s390: protect _PAGE_SPECIAL bit against mprotect
>
> Stop mprotect's pte_modify from wiping out the s390 pte_special bit, which
> caused oops thereafter when vm_normal_page thought X's abnormal was normal.
>
> Signed-off-by: Nick Piggin <npiggin@suse.de>
> Acked-by: Hugh Dickins <hugh@veritas.com>

s390 will definitely need this. Loosing the pte special bit is not
good. I'll prepate
a please pull right away. Thanks of pointing this out.

-- 
blue skies,
 Martin
