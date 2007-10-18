Return-Path: <linux-kernel-owner+w=401wt.eu-S1761255AbXJRG2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761255AbXJRG2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 02:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbXJRG14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 02:27:56 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:35383 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751745AbXJRG1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 02:27:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=c84c5Tj4kLTZjFL0/dlD8viLuI1l1xlaYYhrJx5SbpVf2qQoOajz1+JRxNUp9cWUSpcOzNDQ0bQYzQZiPv9fbt6YWFb6+xHf6tIkhYkuz7GhTCPes4fSa+xuQlb1eyPP3Bita6E0hBn8eBH4K1cllmLxCEvpu/vvI4G8JfRInP0=  ;
X-YMail-OSG: V0ihsOIVM1ms_pj7_TPV2jndwEq1XOugS33aVAc8lXd.ksdidb3tmKeSM._V1ELOCskSmJiudhleom7tqvU03t_r94Je89lZnVVqJv.RsXmZEd1SkHSfjmCvhVyQ3A--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Vasily Averin <vvs@sw.ru>
Subject: Re: How Inactive may be much greather than cached?
Date: Thu, 18 Oct 2007 16:27:27 +1000
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org, devel@openvz.org
References: <4716FC04.6070107@sw.ru>
In-Reply-To: <4716FC04.6070107@sw.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710181627.27827.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 18 October 2007 16:24, Vasily Averin wrote:
> Hi all,
>
> could anybody explain how "inactive" may be much greater than "cached"?
> stress test (http://weather.ou.edu/~apw/projects/stress/) that writes into
> removed files in cycle puts the node to the following state:
>
> MemTotal: 16401648 kB
> MemFree: 636644 kB
> Buffers: 1122556 kB
> Cached: 362880 kB
> SwapCached: 700 kB
> Active: 1604180 kB
> Inactive: 13609828 kB
>
> At the first glance memory should be freed on file closing, nobody refers
> to file and ext3_delete_inode() truncates inode. We can see that memory is
> go away from "cached", however could somebody explain why it become
> "invalid" instead be freed? Who holds the references to these pages?

Buffers, swap cache, and anonymous.
