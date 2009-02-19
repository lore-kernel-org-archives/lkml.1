Return-Path: <linux-kernel-owner+w=401wt.eu-S1755834AbZBSFvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbZBSFvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 00:51:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbZBSFuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 00:50:55 -0500
Received: from smtp110.prem.mail.sp1.yahoo.com ([98.136.44.55]:46021 "HELO
	smtp110.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751535AbZBSFuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 00:50:54 -0500
X-YMail-OSG: I9girPMVM1lT9HMJCaJQbI3zfC7nmqXRt0RI7icyrNgWuGNoTeqAdnJ2aY.Fqefy5tFyXF92CzAu9efNAZNQtX8ixh1zT5TSOgAO_mUcTPFKMR97vwOAvxyWkPGlaclusXR4zeVWSBCxGhnQinpsPARsvF9xW5Od1ZUpTFTWRv1doa9Omaqj4QP7FGxnhRKV4RfL_TFpPd8q46NiKKJLODGOtUpmQvlBC7ubW7NAgjY3oyxszmsnoGB4UpnKqbOjGz5PRC6mM5c8lAe17JMN96SI
X-Yahoo-Newman-Property: ymail-3
Message-ID: <499CF338.1080405@schaufler-ca.com>
Date: Wed, 18 Feb 2009 21:50:48 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: etienne <etienne.basset@numericable.fr>
CC: Paul Moore <paul.moore@hp.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] SMACK netlabel fixes
References: <fa.O38YY4pVfLlMFJNBI3mhgn+qOcQ@ifi.uio.no> <200902171852.21061.paul.moore@hp.com> <499BB76C.1030109@numericable.fr> <200902181005.24952.paul.moore@hp.com> <499C5377.8050408@numericable.fr> <499C5C44.4020902@schaufler-ca.com> <499C7A98.7000907@numericable.fr>
In-Reply-To: <499C7A98.7000907@numericable.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

etienne wrote:
> Hello,
>
> the following patch (against 2.6.29rc5) fixes a few issues in the smack/netlabel area :
> 1) smack_host_label disregard a "0.0.0.0/0 @" rule (or other label), preventing 'tagged' tasks to access Internet (many systems drop packets with IP options)
> 2) netmasks were not handled correctly, they were stored in a way _not equivalent_  to conversion to be32 (it was equivalent for /0, /8, /16, /24, /32 masks but not other masks)
> 3) smack_netlbladdr prefixes (IP/mask) were not consistent (mask&IP was not done), so there could have been different list entries for the same IP prefix; if those entries had different labels, well ... 
> 4) they were not sorted 
>
> 1) 2) 3) are bugs, 4) is a more cosmetic issue.
> The patch :
> -creates a new helper smk_netlbladdr_insert to insert a smk_netlbladdr, sorted by netmask length
> -use the new sorted nature of  smack_netlbladdrs list to simplify smack_host_label : 
>  the first match _will_ be the more specific
> -corrects endianness issues in smk_write_netlbladdr &  netlbladdr_seq_show
>
> The patch are "tested" so that they no crash the system; cat /smack/netlabel is now sorted and always consistent.
> Some basics ping tests to '@' and other label combination seems ok 
> See   an extract of my tests bellow the patch 
>
> regards,
> Etienne
>   

I am in the process of configuring the Smack test lab so that I
can bang on this a little. It looks good so far. Thank you.

