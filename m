Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbZCGPRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbZCGPRe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 10:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbZCGPRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 10:17:25 -0500
Received: from www.tglx.de ([62.245.132.106]:39163 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbZCGPRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 10:17:25 -0500
Date: Sat, 7 Mar 2009 16:16:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhltc@us.ibm.com>
cc: "lkml, " <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: Re: [TIP][RFC 2/7] futex: futex_top_waiter()
In-Reply-To: <49AC75BA.3030006@us.ibm.com>
Message-ID: <alpine.LFD.2.00.0903071612000.29264@localhost.localdomain>
References: <49AC73A9.4040804@us.ibm.com> <49AC75BA.3030006@us.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Mar 2009, Darren Hart wrote:

> From: Darren Hart <dvhltc@us.ibm.com>
> 
> Improve legibility by wrapping finding the top waiter in a function.  This
> will be used by the follow-on patches for enabling requeue pi.
> +static struct futex_q *futex_top_waiter(struct futex_hash_bucket *hb,
> +					union futex_key *key)

Can we just have *head as argument instead of *hb ?

> +{
> +	struct plist_head *head;
> +	struct futex_q *this;
> +	struct futex_q *top_waiter = NULL;

  	struct futex_q *this;

> +	head = &hb->chain;
> +	plist_for_each_entry(this, head, list) {
> +		if (match_futex(&this->key, key)) {
  		   	return this;		    

> +			top_waiter = this;
> +			break;
> +		}
> +	}
> +	return top_waiter;

  	return NULL;

Makes the function half the size.

Thanks,

	tglx
