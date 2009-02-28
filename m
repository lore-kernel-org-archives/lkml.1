Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbZB1AAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbZB1AAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 19:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058AbZB1AAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 19:00:15 -0500
Received: from smtp-out.google.com ([216.239.33.17]:4389 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbZB1AAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 19:00:13 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Pxwb5QNyjr5OIgE8DyEs7xHjdAkvRoObxnMa3urGGlozjYeHEGNRgXbDQs0qxsQxj
	5w93SZERq1uguov4I+ZQA==
MIME-Version: 1.0
In-Reply-To: <b0f5e75d938ffb61bdda7c88b962d3fe.squirrel@webmail-b.css.fujitsu.com>
References: <20090227140537.390905c4.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090227162928.6225fc80.kamezawa.hiroyu@jp.fujitsu.com>
	 <b040c32a0902271213q3dd1931foc2b955d8a028eb6f@mail.gmail.com>
	 <b0f5e75d938ffb61bdda7c88b962d3fe.squirrel@webmail-b.css.fujitsu.com>
Date: Fri, 27 Feb 2009 16:00:06 -0800
Message-ID: <b040c32a0902271600h31785bb8q93acde59f5d15e3d@mail.gmail.com>
Subject: Re: [PATCH] change cpuacct usage percpu format v2
From: Ken Chen <kenchen@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "menage@google.com" <menage@google.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>, mingo@elte.hu,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 27, 2009 at 3:34 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> "a lot of" ? I talking about cpu hotplug and reading another file as
> /sys/devices/system/cpu/present every time before reading this file
> gives much much much more overhead ;)

yes, really a lot.  CPU hotplug is an uncommon event.  It happens
perhaps once a day? maybe once an hour?

User monitoring process usually reads usage_percpu at fairly high
rate, say once a sec.  At each pass it will need to parse N number of
CPU index.  The overhead is N_CPU * T, where T is time in second
between cpu hotplug event.  Assume T = one day, on a moderate sized
64-CPU size machine, the overhead is:

64 * 86400 : 1, that's like 5.5 million to 1 ratio.  To me that is
*high* overhead.

- Ken
