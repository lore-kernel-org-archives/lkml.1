Return-Path: <linux-kernel-owner+w=401wt.eu-S1750951AbXCHKki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750951AbXCHKki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 05:40:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbXCHKkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 05:40:37 -0500
Received: from smtp-out.google.com ([216.239.45.13]:45917 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbXCHKkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 05:40:36 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=VutxwUm16J4yBDPX62hqpnzZYf/PLKV8BV4hUKApQDJvdtz4OuF1m/DbvYnjnikHh
	edIlibi7EhKXHiwTKfZhQ==
Message-ID: <6599ad830703080240o6f67df6cvab314c0cb4a3b5ff@mail.gmail.com>
Date: Thu, 8 Mar 2007 02:40:30 -0800
From: "Paul Menage" <menage@google.com>
To: vatsa@in.ibm.com
Subject: Re: [ckrm-tech] [PATCH 1/7] containers (V7): Generic container system abstracted from cpusets code
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, rohitseth@google.com,
       pj@sgi.com, ebiederm@xmission.com, mbligh@google.com, winget@google.com,
       containers@lists.osdl.org, serue@us.ibm.com, dev@sw.ru,
       devel@openvz.org
In-Reply-To: <20070308103808.GH6504@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070212081521.808338000@menage.corp.google.com>
	 <20070212085104.130746000@menage.corp.google.com>
	 <20070307122117.GB2336@in.ibm.com>
	 <6599ad830703071250p6c92a357g51391a23ee3d78d8@mail.gmail.com>
	 <20070308103808.GH6504@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/8/07, Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
> On Wed, Mar 07, 2007 at 12:50:03PM -0800, Paul Menage wrote:
> > The callback mutex (which is what container_lock() actually locks) is
> > also used to synchronize fork/exit against subsystem additions, in the
> > event that some subsystem has registered fork or exit callbacks. We
> > could probably have a separate subsystem_mutex for that instead.
>
> Why can't manage_mutex itself be used there (to serialize fork/exit callbacks
> against modification to hierarchy)?

Because manage_mutex can be held for very long periods of time. I
think that a combination of a new lock that's only taken by fork/exit
and register_subsys, plus task_lock (which prevents the current task
from being moved) would be more lightweight.

Paul
