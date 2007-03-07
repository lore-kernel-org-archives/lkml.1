Return-Path: <linux-kernel-owner+w=401wt.eu-S2992561AbXCGUuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992561AbXCGUuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 15:50:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992553AbXCGUuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 15:50:23 -0500
Received: from smtp-out.google.com ([216.239.33.17]:38845 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992561AbXCGUuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 15:50:19 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=ntqRWX43bS39BjUmK98Wa5yGa/KDTxTgmwbOYQ+g7ms/UGqdDlIGIYq9VEp0AmKzY
	mDGNC3+PPrf/U/CLLF4Vg==
Message-ID: <6599ad830703071250p6c92a357g51391a23ee3d78d8@mail.gmail.com>
Date: Wed, 7 Mar 2007 12:50:03 -0800
From: "Paul Menage" <menage@google.com>
To: vatsa@in.ibm.com
Subject: Re: [PATCH 1/7] containers (V7): Generic container system abstracted from cpusets code
Cc: akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, winget@google.com,
       containers@lists.osdl.org, devel@openvz.org
In-Reply-To: <20070307122117.GB2336@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070212081521.808338000@menage.corp.google.com>
	 <20070212085104.130746000@menage.corp.google.com>
	 <20070307122117.GB2336@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/07, Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
> If that is the case, I think we can push container_lock entirely inside
> cpuset.c and not have others exposed to this double-lock complexity.
> This is possible because cpuset.c (build on top of containers) still has
> cpuset->parent and walking cpuset->parent list safely can be made
> possible with a second lock which is local to only cpuset.c.
>

The callback mutex (which is what container_lock() actually locks) is
also used to synchronize fork/exit against subsystem additions, in the
event that some subsystem has registered fork or exit callbacks. We
could probably have a separate subsystem_mutex for that instead.

Apart from that, yes, it may well be possible to move callback lock
entirely inside cpusets.

Paul
