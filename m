Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbZGNRoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbZGNRoD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 13:44:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753665AbZGNRoC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 13:44:02 -0400
Received: from smtp-out.google.com ([216.239.45.13]:10195 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbZGNRoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 13:44:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=XOlOGgDJcoBwUkDCwM3+g3BU/eQZQz7l29+5BhGLU4C3Yy9Vcsw6P3D1BOza5xgs7
	+UM2ahszosb9a+oo5Bssw==
MIME-Version: 1.0
In-Reply-To: <2f86c2480907141034r5a985cfue9e8fdf64ad28465@mail.gmail.com>
References: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com>
	 <20090705063850.GX11273@balbir.in.ibm.com>
	 <6599ad830907101658i13e4046br70377a487dd6b49b@mail.gmail.com>
	 <20090713121138.GC5051@balbir.in.ibm.com>
	 <6599ad830907130926v7788af12hdcd76e4ccb3ab6de@mail.gmail.com>
	 <20090714055638.GI5051@balbir.in.ibm.com>
	 <6599ad830907132349u6cf52060t4fafb6637cbe4ed1@mail.gmail.com>
	 <20090714071617.GK5051@balbir.in.ibm.com>
	 <2f86c2480907141034r5a985cfue9e8fdf64ad28465@mail.gmail.com>
Date: Tue, 14 Jul 2009 10:43:56 -0700
Message-ID: <6599ad830907141043s1c16d5c9saad9118c210ecef4@mail.gmail.com>
Subject: Re: [PATCH 0/2] CGroups: cgroup member list enhancement/fix
From: Paul Menage <menage@google.com>
To: Benjamin Blum <bblum@google.com>
Cc: balbir@linux.vnet.ibm.com, lizf@cn.fujitzu.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       libcg-devel <libcg-devel@lists.sourceforge.net>,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 10:34 AM, Benjamin Blum<bblum@google.com> wrote:
> procs file). While that's preferable to a global lock, if we can add a
> field to task_struct, a (lockless) flag-based approach might be
> possible.
>

I've been trying to think of a way to do that. AFAICS the only way to
do that reliably would be to move the call to cgroup_fork() that hooks
into the parent's cgroup inside the lock on the group leader's thread
list, and move the fork callbacks into cgroup_fork(). (Which would
mean that they'd not be able to sleep/fail, etc).

Paul
