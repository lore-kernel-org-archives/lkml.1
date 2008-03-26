Return-Path: <linux-kernel-owner+w=401wt.eu-S1760608AbYCZNKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760608AbYCZNKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 09:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760079AbYCZNKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 09:10:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51672 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760053AbYCZNKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 09:10:34 -0400
Date: Wed, 26 Mar 2008 14:10:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Yeisley <dan.yeisley@unisys.com>
Cc: linux-kernel@vger.kernel.org, ak@suse.de,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] CPUs on memoryless nodes not being reassigned
Message-ID: <20080326131021.GA16852@elte.hu>
References: <1206535469.7468.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206535469.7468.9.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Yeisley <dan.yeisley@unisys.com> wrote:

> When I boot with memoryless nodes on the latest 2.6.25-rc kernels, the 
> CPUs aren't being reassigned to nodes with memory.

>  	node = apicid_to_node[apicid];
> -	if (node == NUMA_NO_NODE)
> +	if (node == NUMA_NO_NODE || !node_online(node))
>  		node = first_node(node_online_map);

that's already fixed in x86.git/latest, by Yinghai Lu, could you try it:

  http://people.redhat.com/mingo/x86.git/README

(let me know if there's any other problem with your hardware on 
x86.git/latest.)

	Ingo
