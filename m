Return-Path: <linux-kernel-owner+w=401wt.eu-S1756125AbZEELT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125AbZEELT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 07:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbZEELTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 07:19:12 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:47955 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403AbZEELTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 07:19:11 -0400
From: Hannes Hering <hannes.hering@linux.vnet.ibm.com>
Organization: IBM
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 2.6.30-rc5] ehea: fix invalid pointer access
Date: Tue, 5 May 2009 13:19:05 +0200
User-Agent: KMail/1.9.9
Cc: David Miller <davem@davemloft.net>, themann@de.ibm.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, raisch@de.ibm.com,
       ossrosch@linux.vnet.ibm.com, linuxppc-dev@ozlabs.org,
       ossthema@de.ibm.com, osstklei@de.ibm.com
References: <200905041802.30527.hannes.hering@linux.vnet.ibm.com> <25628.1241514687@redhat.com>
In-Reply-To: <25628.1241514687@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905051319.05806.hannes.hering@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 May 2009 11:11:27 David Howells wrote:
> Hannes Hering <hannes.hering@linux.vnet.ibm.com> wrote:
> 
> >  	pref = skb_array[x];
> > -	prefetchw(pref);
> > -	prefetchw(pref + EHEA_CACHE_LINE);
> > +	if (pref) {
> > +		prefetchw(pref);
> > +		prefetchw(pref + EHEA_CACHE_LINE);
> 
> Ummm...  Is prefetch() or prefetchw() faulting?
> 
> David
Hi David,

this is an ehea driver problem, which is occuring when the receive queue runs
empty. The faulting code is more specifically the following line:

	pref = (skb_array[x]->data);

Here the access to the struct element data would cause an exception.We could
have made the if block a little smaller.

Regards

Hannes
