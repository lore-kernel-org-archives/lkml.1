Return-Path: <linux-kernel-owner+w=401wt.eu-S1760883AbZDGUkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760883AbZDGUkN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 16:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760951AbZDGUj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 16:39:57 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:59717 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759404AbZDGUj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 16:39:56 -0400
Message-ID: <49DBB929.4080205@cs.helsinki.fi>
Date: Tue, 07 Apr 2009 23:35:53 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] slub: default min_partial to at least highest cpus per
  node
References: <alpine.DEB.2.00.0904051653420.25339@chino.kir.corp.google.com>  <49DBA23A.3000106@cs.helsinki.fi> <84144f020904071209j638aae9bv406661ec401af7af@mail.gmail.com> <alpine.DEB.2.00.0904071231500.21113@chino.kir.corp.google.com> <49DBAF7E.30704@cs.helsinki.fi> <alpine.DEB.2.00.0904071302430.32321@chino.kir.corp.google.com> <49DBB373.5050800@cs.helsinki.fi> <alpine.DEB.2.00.0904071316460.21748@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0904071316460.21748@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> On Tue, 7 Apr 2009, Pekka Enberg wrote:
> 
>>> If you think that's acceptable, I'd be just as satisfied with that approach
>>> as long as all archs have valid cpu_to_node() mappings at the time of
>>> CPU_UP_PREPARE.
>> Well, that doesn't change the current behavior, so sure, I think it's
>> acceptable. And if the new defaults seem reasonable enough, we can probably
>> get rid of the tunable altogether.
> 
> I'd like to remove MAX_PARTIAL and replace it with nr_cpu_ids.

Yeah, something more dynamic makes sense. But we probably need to do 
ilog2(nr_cpu_ids) or something; otherwise we will have very long partial 
lists on big iron machines (think 4096 cpus here).
