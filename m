Return-Path: <linux-kernel-owner+w=401wt.eu-S933536AbXFRWxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933536AbXFRWxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 18:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932434AbXFRWxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 18:53:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932272AbXFRWxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 18:53:36 -0400
Message-ID: <46770CA9.4070304@redhat.com>
Date: Mon, 18 Jun 2007 18:52:25 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       prasanna@in.ibm.com, ananth@in.ibm.com, jkenisto@us.ibm.com, ak@suse.de
Subject: Re: [patch 1/3] Text Edit Lock - i386
References: <20070618215846.247539382@polymtl.ca> <20070618220458.888939232@polymtl.ca>
In-Reply-To: <20070618220458.888939232@polymtl.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2007 05:58 PM, Mathieu Desnoyers wrote:
> Interface to use for code patching : uses a mutex to insure mutual edit
> exclusion and makes sure the page is writable.
> 
... 
> +/* Mutex protecting text section modification (dynamic code patching) */
> +static DEFINE_MUTEX(text_mutex);
> +

Probably should be a spinlock.

And it just occurred to me, how does smp_alternatives deal with this?
Is it broken now when the text section is read-only?
