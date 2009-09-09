Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbZIIOmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbZIIOmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 10:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbZIIOmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 10:42:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbZIIOmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 10:42:22 -0400
Message-ID: <4AA7BECB.2090903@redhat.com>
Date: Wed, 09 Sep 2009 17:42:19 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/9] virt/kvm: correct error-handling code
References: <Pine.LNX.4.64.0907281752560.28189@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0907281752560.28189@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2009 06:53 PM, Julia Lawall wrote:
> From: Julia Lawall<julia@diku.dk>
>
> This code is not executed before file has been initialized to the result of
> calling eventfd_fget.  This function returns an ERR_PTR value in an error
> case instead of NULL.  Thus the test that file is not NULL is always true.
>
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
>
> //<smpl>
> @match exists@
> expression x, E;
> statement S1, S2;
> @@
>
> x = eventfd_fget(...)
> ... when != x = E
> (
> *  if (x == NULL || ...) S1 else S2
> |
> *  if (x == NULL&&  ...) S1 else S2
> )
> //</smpl>
>
>    

Applied, thanks (yes, old patch, missed it).

-- 
error compiling committee.c: too many arguments to function

