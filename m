Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab0BJXlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 18:41:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:40420 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755831Ab0BJXly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 18:41:54 -0500
Message-ID: <4B7344A4.1030607@kernel.org>
Date: Thu, 11 Feb 2010 08:43:32 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: mszeredi@suse.cz, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, polynomial-c@gentoo.org,
       akpm@linux-foundation.org
Subject: Re: [fuse-devel] [PATCH] FUSE/CUSE: implement direct mmap support
References: <4B70FBE4.7050700@kernel.org> <E1NerZ6-0007N6-UY@pomaz-ex.szeredi.hu> <4B7296DF.207@kernel.org> <E1NfAl6-0000o4-8Z@pomaz-ex.szeredi.hu> <4B729F07.8020704@kernel.org> <E1NfBTc-0000vk-59@pomaz-ex.szeredi.hu> <4B72A802.6040009@kernel.org> <E1NfE50-0001EK-Ao@pomaz-ex.szeredi.hu>
In-Reply-To: <E1NfE50-0001EK-Ao@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Feb 2010 23:40:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/11/2010 12:02 AM, Miklos Szeredi wrote:
>> Yeah, sure.  FUSE server is free to give them separate regions.  The
>> only restriction is the SHMLBA alignment which is pretty easy to
>> adhere to.
> 
> What I really meant was: does it ever happen that mapping a *single
> open file* of a chardev twice will result in two different maps?
> Or will the maps be only different if it was a different open of the
> device?

I don't know if there is one but ->mmap() implementation is definitely
allowed to do that.

> If there's a pattern there, we might make the sharing/non-sharing
> automated, and greatly simplify the interface.

Isn't the interface pretty simple as it is?  If we want to make it
easier for API users by imposing limits, I think the correct layer to
do that would be at the library level.

Thanks.

-- 
tejun
