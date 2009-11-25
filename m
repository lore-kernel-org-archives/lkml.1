Return-Path: <linux-kernel-owner+w=401wt.eu-S1758638AbZKYKly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638AbZKYKly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 05:41:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758556AbZKYKlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 05:41:53 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52597 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758545AbZKYKlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 05:41:53 -0500
Message-ID: <4B0D09F5.6020305@cs.helsinki.fi>
Date: Wed, 25 Nov 2009 12:41:57 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tim Blechmann <tim@klingt.org>, linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 3/5] slab.c: remove branch hint
References: <cover.1259059549.git.tim@klingt.org> <4B0BBBA8.2090604@klingt.org> <20091124112058.GA23765@elte.hu> <84144f020911240328l3d36d347o6c91b2b1a0f50f2a@mail.gmail.com> <20091124114218.GA24396@elte.hu>
In-Reply-To: <20091124114218.GA24396@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar kirjoitti:
>> That sounds odd to me. Can you see where the incorrectly predicted
>> calls are coming from? Calling kmem_cache_alloc_node() with node set
>> to -1 most of the time could be a real bug somewhere.
> 
> I think it could occur in too limited tests - the branch prediction 
> looks 'wrong' in certain tests - while it's OK in general.
> 
> Is there some easy to run workload you consider more or less 
> representative of typical SLAB patterns?

I can think of three main classes: VFS, SCSI, or network intensive 
applications and benchmarks tend to bring out the worst in SLAB. There 
are probably some interesting NUMA related things that I'm not really 
aware of.
