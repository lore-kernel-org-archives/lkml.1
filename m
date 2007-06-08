Return-Path: <linux-kernel-owner+w=401wt.eu-S970310AbXFHQUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970310AbXFHQUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969972AbXFHQRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:17:18 -0400
Received: from smtp-out.google.com ([216.239.45.13]:25279 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S969942AbXFHQRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:17:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=YRD3iKDfX+X6iKPhDYTz75PFttYbWBVPTiljqy9I/cgksB4hV+tPYJBI+n9HhMbNo
	rvzLugLap4eoDSkKcCtMQ==
Message-ID: <6599ad830706080916j477e08c0l8b142d9a0d832c76@mail.gmail.com>
Date: Fri, 8 Jun 2007 09:16:45 -0700
From: "Paul Menage" <menage@google.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [ckrm-tech] [PATCH 00/10] Containers(V10): Generic Process Containers
Cc: "Paul Jackson" <pj@sgi.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       vatsa@in.ibm.com, ckrm-tech@lists.sourceforge.net, balbir@in.ibm.com,
       rohitseth@google.com, haveblue@us.ibm.com, xemul@sw.ru, dev@sw.ru,
       containers@lists.osdl.org, devel@openvz.org, ebiederm@xmission.com,
       mbligh@google.com, cpw@sgi.com, svaidy@linux.vnet.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070608160840.GA11133@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070606223952.GB5626@sergelap.austin.ibm.com>
	 <20070607000559.GA19529@sergelap.austin.ibm.com>
	 <20070606174609.bfa01446.pj@sgi.com>
	 <20070607180158.GA936@sergelap.austin.ibm.com>
	 <20070607122121.24fe6ff4.pj@sgi.com>
	 <20070607201723.GA17011@sergelap.austin.ibm.com>
	 <20070607150113.f020d8f8.pj@sgi.com>
	 <20070608143250.GA7728@vino.hallyn.com>
	 <6599ad830706080855n22612814u4805d34a295b165f@mail.gmail.com>
	 <20070608160840.GA11133@vino.hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/8/07, Serge E. Hallyn <serge@hallyn.com> wrote:
>
> The problem is container_clone() doesn't call ->create explicitly, it
> does vfs_mkdir.  So we have no real way of passing in clone_task.
>

Good point.

Looking at vfs_mkdir(), it's pretty simple, and really the only bits
that apply to container_clone() are the call to ->mkdir() and possibly
the call to fsnotify_mkdir(). (I think that's maybe how you did it
originally?)

Maybe it would make sense to just call container_create() at that
point directly, which would allow us more parameters.

Paul
