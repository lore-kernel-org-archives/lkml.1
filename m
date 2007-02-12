Return-Path: <linux-kernel-owner+w=401wt.eu-S965345AbXBLTqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965345AbXBLTqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 14:46:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965347AbXBLTqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 14:46:35 -0500
Received: from smtp-out.google.com ([216.239.33.17]:24754 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965345AbXBLTqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 14:46:34 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=si7/aMDSM6jChHEaWiz3fI+DdWQYr7sznY0qlZ1b8sxMr4oZEgiBaaV0rCYCAfSzC
	LpRTV+vcI5nGEqm7iGwJw==
Message-ID: <6599ad830702121146y41c8856cm4a85943aa950771f@mail.gmail.com>
Date: Mon, 12 Feb 2007 11:46:20 -0800
From: "Paul Menage" <menage@google.com>
To: vatsa@in.ibm.com
Subject: Re: [PATCH 1/7] containers (V7): Generic container system abstracted from cpusets code
Cc: akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, winget@google.com,
       containers@lists.osdl.org, devel@openvz.org
In-Reply-To: <6599ad830702121126o35fb0cb6x696a4a56079bce40@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070212081521.808338000@menage.corp.google.com>
	 <20070212085104.130746000@menage.corp.google.com>
	 <20070212123309.GA7526@in.ibm.com>
	 <6599ad830702121126o35fb0cb6x696a4a56079bce40@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/12/07, Paul Menage <menage@google.com> wrote:
> reaches zero. RCU is still fine for reading the container_group
> pointers, but it's no good for updating them, since by the time you
> update it it may no longer be your container_group structure, and may
> instead be about to be deleted as soon as the other thread's
> rcu_synchronize() completes.

On further reflection, this probably would be safe after all. Since we
don't call put_container_group() in attach_task() until after
synchronize_rcu() completes, that implies that a container_group_get()
from the RCU section would have already completed. So we should be
fine.

Paul
