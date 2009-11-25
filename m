Return-Path: <linux-kernel-owner+w=401wt.eu-S934451AbZKYH4C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934451AbZKYH4C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 02:56:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758423AbZKYH4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 02:56:01 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35674 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758421AbZKYH4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 02:56:00 -0500
Subject: Re: [PATCH] perf_events: fix validate_event bug
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@gmail.com
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, perfmon2-devel@lists.sf.net, eranian@google.com
In-Reply-To: <7c86c4470911242147u160008d4y50385cb348615df8@mail.gmail.com>
References: <1256223091-6002-1-git-send-email-eranian@gmail.com>
	 <1258562785.3918.685.camel@laptop>
	 <7c86c4470911230534i4119734k1478550567852220@mail.gmail.com>
	 <1258983953.4531.456.camel@laptop>
	 <7c86c4470911240518qe0c3e87k589437ef43f4a3d4@mail.gmail.com>
	 <19212.22371.633313.129961@cargo.ozlabs.ibm.com>
	 <7c86c4470911242147u160008d4y50385cb348615df8@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Nov 2009 08:55:57 +0100
Message-ID: <1259135757.4027.5.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-25 at 06:47 +0100, stephane eranian wrote:
> It seems to me you have two ways of solving this:
>   1- push the algorithm to assign events to counters up in the generic code
>   2- have the generic code invoke all possible constraint sources on each group

2, is what it currently does. 

Since we can only add a single event to a group at a time, and we know
the previous group was schedulable, we only need to validate the
constraints on the pmu of the new event.

