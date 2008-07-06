Return-Path: <linux-kernel-owner+w=401wt.eu-S1760176AbYGFVEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760176AbYGFVEQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 17:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758284AbYGFVD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 17:03:58 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:32871 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758167AbYGFVD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 17:03:57 -0400
Message-ID: <4871330A.3030400@acm.org>
Date: Sun, 06 Jul 2008 15:03:06 -0600
From: Zan Lynx <zlynx@acm.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Ryan Hope <rmh3093@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Lockless/Get_User_Pages_Fast causes Xorg 1.4.99.* to lock
References: <48f7fe350807032326l1d68c94l531e44c09693b989@mail.gmail.com> <486E4FD8.4010102@acm.org> <Pine.LNX.4.64.0807042112130.16912@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0807042112130.16912@blonde.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20080706/1KFbOY-0006gm-BO-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Fri, 4 Jul 2008, Zan Lynx wrote:
[cut]
> Useful info, thank you; even more useful was the Code line in your attachment
> 
>> [  269.224557] Code: 00 00 48 b9 00 00 00 00 00 e2 ff ff 48 21 d8 48 c1 e8 0c 48 8d 14 c5 00 00 00 00 48 c1 e0 06 48 29 d0 48 01 c1 0f 84 10 ff ff ff <48> 8b 01 48 89 ca f6 c4 40 74 04 48 8b 51 10 90 ff 42 08 90 ff 
> 
> which is enough to identify the oops as in copy_one_pte's get_page(page).
> Here's a patch I think we need, which I'm hoping will fix both your
> crashes - please let us know - thanks a lot.
> 
> Stop mprotect's pte_modify from wiping out the x86 pte_special bit, which
> caused oops thereafter when vm_normal_page thought X's abnormal was normal.
[cut patch]

I can report that this fixes things for me as well.  Thank you.
