Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463Ab0AMOaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab0AMOaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 09:30:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415Ab0AMOai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 09:30:38 -0500
Received: from cantor.suse.de ([195.135.220.2]:53809 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498Ab0AMOah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 09:30:37 -0500
Message-ID: <4B4DD8DB.8080900@suse.com>
Date: Wed, 13 Jan 2010 09:29:47 -0500
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux-MM <linux-mm@kvack.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [patch 2/6] hugetlb: Fix section mismatches
References: <20100113004855.550486769@suse.com> <20100113004938.715904356@suse.com> <alpine.DEB.2.00.1001130127450.469@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1001130127450.469@chino.kir.corp.google.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/13/2010 04:28 AM, David Rientjes wrote:
> On Tue, 12 Jan 2010, Jeff Mahoney wrote:
> 
>>  hugetlb_register_node calls hugetlb_sysfs_add_hstate, which is marked with
>>  __init. Since hugetlb_register_node is only called by
>>  hugetlb_register_all_nodes, which in turn is only called by hugetlb_init,
>>  it's safe to mark both of them as __init.
>>
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> ---
>>  mm/hugetlb.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -1630,7 +1630,7 @@ void hugetlb_unregister_node(struct node
>>   * hugetlb module exit:  unregister hstate attributes from node sysdevs
>>   * that have them.
>>   */
>> -static void hugetlb_unregister_all_nodes(void)
>> +static void __init hugetlb_unregister_all_nodes(void)
>>  {
>>  	int nid;
>>  
> 
> This is wrong, you want to move hugetlb_register_all_nodes() to 
> .init.text, not hugetlb_unregister_all_nodes().

Yep. You're right. I had this correct in my initial version of the patch
but accidentally deleted it while renaming them. I'll re-send.

- -Jeff

>> @@ -1650,7 +1650,7 @@ static void hugetlb_unregister_all_nodes
>>   * Register hstate attributes for a single node sysdev.
>>   * No-op if attributes already registered.
>>   */
>> -void hugetlb_register_node(struct node *node)
>> +void __init hugetlb_register_node(struct node *node)
>>  {
>>  	struct hstate *h;
>>  	struct node_hstate *nhs = &node_hstates[node->sysdev.id];


- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAktN2NsACgkQLPWxlyuTD7LWzACcDpwbTkDEaZpdHUOYBiFqj0xP
9NkAnjoySOmUkV45P8yaMK6Z7N8xWnvn
=dTst
-----END PGP SIGNATURE-----
