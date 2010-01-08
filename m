Return-Path: <linux-kernel-owner+w=401wt.eu-S1751973Ab0AHGeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab0AHGeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 01:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750843Ab0AHGeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 01:34:17 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:57327 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab0AHGeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 01:34:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=FE+RqSPblr/MQUUVA2UCGRraWnZs4M0VOnKybt4qspfetMI1WwX+2Z6+UMPDBgwBQc
         ujvOHe2sVYtL+1kexFzetzmF+1JyBQ3naAGrvAiJq+tNS6Q+bO0NuZVkshG04MfigQjw
         LsFxFayi2sR0V+Jzz9kmdStqaYGuzsF2pq+YM=
MIME-Version: 1.0
In-Reply-To: <20100107143651.2fa73662.randy.dunlap@oracle.com>
References: <201001072218.o07MIPNm020870@imap1.linux-foundation.org>
	 <20100107143651.2fa73662.randy.dunlap@oracle.com>
Date: Fri, 8 Jan 2010 12:34:15 +0600
Message-ID: <b9df5fa11001072234o2e5fb8bfv7b57a562d9a6e4d1@mail.gmail.com>
Subject: Re: + hugetlb-fix-section-mismatch-warning-in-hugetlbc.patch added to 
	-mm tree
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/8/10, Randy Dunlap <randy.dunlap@oracle.com> wrote:

Hi,
>
> Hi,
>
>  If so, then hugetlb_register_node() could be called at any time
>  (like after system init), and it would then call
>  hugetlb_sysfs_add_hstate(), which would be bad.
>
But - hugetlb_register_node is only called from hugetlb_register_all_nodes.
The call sequence is :
                    hugetlb_init   --------------->  was __init
                         \-> hugetlb_register_all_nodes  ----> we make it __init
                                          \-> hugetlb_register_node
---> we make it __init
                                                 \->
hugetlb_sysfs_add_hstate -> this was __init

Above all happens in __init context. So - hugetlb_register_node is
called only at
system init. But I don't think __init is used for hotplug support, for
proper hotplug
support we might use __meminit.

And register_hugetlbfs_with_node is called from hugetlb_un/register_node.
But hugetlb_unregister_node doesn't use callback function. It's not referencing
hugetlb_sysfs_add_hstate(). So - it's safe. Unless I'm not missing
anything, too.

thanks,

>  Thanks.
> ---
>
> ~Randy
>
