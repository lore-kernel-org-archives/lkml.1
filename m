Return-Path: <linux-kernel-owner+w=401wt.eu-S1030688AbXFHP5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030688AbXFHP5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 11:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966477AbXFHP5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 11:57:36 -0400
Received: from smtp-out.google.com ([216.239.45.13]:22682 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932836AbXFHP5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 11:57:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=D3XwCtBhcz2kAYQmAz+zEiOdJizDScqGgHscAOYrTY3gik515dbOUb8Zxmq7EbJ6V
	hpMXOLqylYfkqsYbTmP3g==
Message-ID: <6599ad830706080855n22612814u4805d34a295b165f@mail.gmail.com>
Date: Fri, 8 Jun 2007 08:55:47 -0700
From: "Paul Menage" <menage@google.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [ckrm-tech] [PATCH 00/10] Containers(V10): Generic Process Containers
Cc: "Paul Jackson" <pj@sgi.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       vatsa@in.ibm.com, ckrm-tech@lists.sourceforge.net, balbir@in.ibm.com,
       rohitseth@google.com, haveblue@us.ibm.com, xemul@sw.ru, dev@sw.ru,
       containers@lists.osdl.org, devel@openvz.org, ebiederm@xmission.com,
       mbligh@google.com, cpw@sgi.com, svaidy@linux.vnet.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070608143250.GA7728@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070604204131.GB19409@sergelap.austin.ibm.com>
	 <20070606223952.GB5626@sergelap.austin.ibm.com>
	 <20070606154347.a155630b.pj@sgi.com>
	 <20070607000559.GA19529@sergelap.austin.ibm.com>
	 <20070606174609.bfa01446.pj@sgi.com>
	 <20070607180158.GA936@sergelap.austin.ibm.com>
	 <20070607122121.24fe6ff4.pj@sgi.com>
	 <20070607201723.GA17011@sergelap.austin.ibm.com>
	 <20070607150113.f020d8f8.pj@sgi.com>
	 <20070608143250.GA7728@vino.hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/8/07, Serge E. Hallyn <serge@hallyn.com> wrote:
>
> Anyway the patch I sent is simple enough, and if users end up demanding
> the ability to better deal with exclusive cpusets, the patch will be
> simple enough to extend by changing cpuset_auto_setup(), so let's
> stick with that patch since it's your preference (IIUC).
>

Sounds good to me, although I think my preference would be to extend
the "create()" subsystem callback with a "struct task_struct
*clone_task" parameter that indicates that clone_task is cloning its
own container; a subsystem like cpusets that needs to do additional
setup at that point could inherit settings either from the parent or
from clone_task's container (or something else) as desired. (It could
also do permission checking based on properties of clone_task, etc).

Paul
