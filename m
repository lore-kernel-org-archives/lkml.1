Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645Ab0BLAXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 19:23:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:51650 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757348Ab0BLAXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 19:23:14 -0500
Message-ID: <4B749FF8.6030304@kernel.org>
Date: Fri, 12 Feb 2010 09:25:28 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: mszeredi@suse.cz, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, polynomial-c@gentoo.org,
       akpm@linux-foundation.org
Subject: Re: [fuse-devel] [PATCH] FUSE/CUSE: implement direct mmap support
References: <4B70FBE4.7050700@kernel.org> <E1NerZ6-0007N6-UY@pomaz-ex.szeredi.hu> <4B7296DF.207@kernel.org> <E1NfAl6-0000o4-8Z@pomaz-ex.szeredi.hu> <4B729F07.8020704@kernel.org> <E1NfBTc-0000vk-59@pomaz-ex.szeredi.hu> <4B72A802.6040009@kernel.org> <E1NfE50-0001EK-Ao@pomaz-ex.szeredi.hu> <4B7344A4.1030607@kernel.org> <E1NfVOi-0002l9-5l@pomaz-ex.szeredi.hu> <4B73EE68.4070004@kernel.org> <E1NfYFm-00034C-Pd@pomaz-ex.szeredi.hu> <4B73FE96.2080707@kernel.org> <E1NfYfb-00039p-Uh@pomaz-ex.szeredi.hu> <4B74065D.2000707@kernel.org> <E1NfZHO-0003FY-8E@pomaz-ex.szeredi.hu> <4B740CFB.7060409@kernel.org> <E1NfaD3-0003MQ-Du@pomaz-ex.szeredi.hu> <4B749BDF.8000807@kernel.org>
In-Reply-To: <4B749BDF.8000807@kernel.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 12 Feb 2010 00:22:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/12/2010 09:07 AM, Tejun Heo wrote:
>> The thing is, I'm still not sure if or how this kind of mmap makes
>> sense outside of the CUSE context.  Which makes designing the API
>> difficult.
> 
> For this to be useful for normal FS, it has to be backed by multiple
> swap backed files and I can almost guarantee you would need to be
> passing fds around.

BTW, if you're looking this way, one way to do it would be to ask the
server to return a fd to use for the mmap backing and offset
adjustment (still needs to be SHMLBA aligned) rather than creating
anonymous file from the kernel.  In this approach, the problem would
be wrapping the vma ops so that FUSE can determine when the mmap
segment is released.  I did it in pretty ugly way in the previous mmap
implementation by simply overwriting the ops as anonymous files didn't
have their own ->open or ->close but to do this for any file you'll
need a way to nest or inherit vma ops in generic way.  The problem is
that the assumptions regarding vma are pretty deeply buried all over
the VM layer.  FWIW, I couldn't think of a way to do that in generic
manner.

Thanks.

-- 
tejun
