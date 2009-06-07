Return-Path: <linux-kernel-owner+w=401wt.eu-S1753524AbZFGOMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbZFGOMf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 10:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbZFGOM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 10:12:27 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:36352 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbZFGOM0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 10:12:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vl0+aa9Cm1FQi6V9TOjEi50N/0416JsE5c6lCKWfX4ko2KFYH4Qovb6hrLBmr2P8pZ
         SF5AGsPzAR1Pe9qcsk3/ghrDfHQw0AbGwlw3K3+bQIzHGiwNPHlXlgpXM7YWq0bV4UNh
         2x6/ZKGp28utra8kV/HZiypIP3q3ap8MI+1gM=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0906061512100.16635@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0906061512100.16635@chino.kir.corp.google.com>
Date: Sun, 7 Jun 2009 19:42:28 +0530
X-Google-Sender-Auth: 5abf4c1faeb79d5a
Message-ID: <661de9470906070712y7b90d1bbn60b110bdb99a0d01@mail.gmail.com>
Subject: Re: [patch -mmotm] oom: only oom kill exiting tasks with attached 
	memory
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 7, 2009 at 3:42 AM, David Rientjes<rientjes@google.com> wrote:
> When a task is chosen for oom kill and is found to be PF_EXITING,
> __oom_kill_task() is called to elevate the task's timeslice and give it
> access to memory reserves so that it may quickly exit.
>
> This privilege is unnecessary, however, if the task has already detached
> its mm.  Although its possible for the mm to become detached later since
> task_lock() is not held, __oom_kill_task() will simply be a no-op in such
> circumstances.
>
> Subsequently, it is no longer necessary to warn about killing mm-less
> tasks since it is a no-op.
>
> Cc: Rik van Riel <riel@redhat.com>
> Signed-off-by: David Rientjes <rientjes@google.com>

Seems like a good change to make. Did you encounter this situation on
a real machine?

Balbir
