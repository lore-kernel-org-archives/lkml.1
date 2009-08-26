Return-Path: <linux-kernel-owner+w=401wt.eu-S1756811AbZHZKQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbZHZKQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756881AbZHZKQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:16:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756847AbZHZKQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:16:37 -0400
Message-ID: <4A950B75.5020409@redhat.com>
Date: Wed, 26 Aug 2009 13:16:21 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: alacrityvm-devel@lists.sourceforge.net,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org
Subject: Re: AlacrityVM benchmark numbers updated
References: <4A948962.7090909@gmail.com>
In-Reply-To: <4A948962.7090909@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2009 04:01 AM, Gregory Haskins wrote:
> We are pleased to announce the availability of the latest networking
> benchmark numbers for AlacrityVM.  We've made several tweaks to the
> original v0.1 release to improve performance.  The most notable is a
> switch from get_user_pages to switch_mm+copy_[to/from]_user thanks to a
> review suggestion from Michael Tsirkin (as well as his patch to
> implement it).
>
> This change alone accounted for freeing up an additional 1.2Gbps, which
> is over 25% improvement from v0.1.  The previous numbers were 4560Gbps
> before the change, and 5708Gbps after (for 1500mtu over 10GE).  This
> moves us ever closer to the goal of native performance under virtualization.
>    

Interesting, it's good to see that copy_*_user() works so well.  Note 
that there's a possible optimization that goes in the opposite direction 
- keep using get_user_pages(), but use the dma engine API to perform the 
actual copy.  I expect that it will only be a win when using tso to 
transfer full pages.  Large pages may also help.

Copyless tx also wants get_user_pages().  It makes sense to check if 
switch_mm() + get_user_pages_fast() gives better performance than 
get_user_pages().

-- 
error compiling committee.c: too many arguments to function

