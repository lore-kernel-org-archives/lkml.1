Return-Path: <linux-kernel-owner+w=401wt.eu-S1752989AbYHLMMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbYHLMMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 08:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbYHLMMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 08:12:39 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:2160 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbYHLMMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 08:12:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=CH9gY53GmQTyFO+EqnEXv6u/XeAW21VdBz1Ah1Wz8e/SUJ4xqhYwT+iBZWtk6lIVke
         mr0yk0dM9r5K9XQp98zYI7Dr5yhTyqTUA25Wk3n/IHk0odpzfT5z61qSJ9/5fjo6xkV2
         /973D0PilOl5XXX65pcyC+wImkhRWAWO1c1FA=
Message-ID: <b9df5fa10808120512wb7f684bgdbcd7ab3f86d25a5@mail.gmail.com>
Date: Tue, 12 Aug 2008 18:12:37 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH] cgroup.c: Some 'hlist_head' function fixes.
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080811222942.a7998c43.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b9df5fa10808080829l6275a208u65b3c48dafe6c8e1@mail.gmail.com>
	 <20080809160721.320b114d.pj@sgi.com>
	 <b9df5fa10808100036h35e2c461je9139516f724687@mail.gmail.com>
	 <20080810220816.105d66ea.pj@sgi.com>
	 <b9df5fa10808110202w38930bb3oa492284f1c072f1f@mail.gmail.com>
	 <20080811222942.a7998c43.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/12/08, Paul Jackson <pj@sgi.com> wrote:
> > Is it [text size] the only criteria to judge this patch ?
>
>  No - not the only criteria, as the patch combines a couple of
>  changes.
>
>  > What about the use of "unsigned long", instead of int.
>
>  I had missed that change, even though you had explicitly
>
> described it in your patch comment, when you wrote:
>
>   2. As hash_long returns with unsigned long we need a unsigned long
>
>
> How about just casting the hash_long() result to int:
>
>   index = (int)hash_long(tmp, CSS_SET_HASH_BITS);
 Yes, it looks good.
>
>  Since we are using this 'index' to index an array,
>  it had better fit in an 'int', which indeed it does
>  as CSS_SET_HASH_BITS is 7, which constrains the output
>  of hash_long to [0 .. 2^7-1], that is between 0 and 127.
>
>  However ... looking around the kernel, I see that most other
>  uses of hash_long(), except in cases where the second argument
>  (bit size) might actually exceed 32 bits, either directly
>  index some array with the result, or else assign the result
>  to a temporary 'int'.
>
>  And the compiler does not complain that we're assigning a
>  long to an int.
>
>  So ... what's the problem?
Yes, maybe your right. Ok, I'll go through the code again. If it's
good then I'm happy.
>
>  I see nothing in this patch of value.
>
>  Am I missing something?
>
>  -----
>
>  I just noticed that you had dropped the other recipients
>  from this email thread, a couple of replies ago.  My
>  preference would have been to have this discussion in
>  public.  I prefer not to drop people from CC lists on
>  email threads.
Yes, I've noticed it too. I just forgot to do that. Actually, when I
reply to thread, I just think about that one. This could be a reason
for missing.
Thanks.
>

>
>  --
>
>                   I won't rest till it's the best ...
>                   Programmer, Linux Scalability
>                   Paul Jackson <pj@sgi.com> 1.940.382.4214
>
