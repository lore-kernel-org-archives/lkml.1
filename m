Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbYJOB3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbYJOB3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 21:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbYJOB3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 21:29:34 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:45743 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbYJOB3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 21:29:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EsmWf5/V6pbCg7wtMx68PdksFgDx2iqA18U/nNjrS/gNqHCIiA2+Iw6Di3pSW3UjYd
         Go6TY6R6GF7ZDrhws7FE+XmFe3k/kdq+WgAOVPgQ3dickOPqCE1E9gRPori7kZ1ZJxRa
         c1Ni0URiH/MtDYP/NOu3UpTeLKBytqtnY4Sik=
Message-ID: <524f69650810141829u2d708e4axe47a8a78a2b72941@mail.gmail.com>
Date: Tue, 14 Oct 2008 20:29:31 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Jeff Layton" <jlayton@redhat.com>
Subject: Re: [PATCH 2/5] cifs: eliminate usage of kthread_stop for cifsd
Cc: linux-kernel@vger.kernel.org, niallain@gmail.com,
       linux-cifs-client@lists.samba.org
In-Reply-To: <1224031267-17194-3-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1224031267-17194-1-git-send-email-jlayton@redhat.com>
	 <1224031267-17194-3-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 7:41 PM, Jeff Layton <jlayton@redhat.com> wrote:
> When cifs_demultiplex_thread was converted to a kthread based kernel
> thread, great pains were taken to make it so that kthread_stop would be
> used to bring it down. This just added unnecessary complexity since we
> needed to use a signal anyway to break out of kernel_recvmsg.
>
> Also, cifs_demultiplex_thread does a bit of cleanup as it's exiting, and
> we need to be certain that this gets done. It's possible for a kthread
> to exit before its main function is ever run if kthread_stop is called
> soon after its creation. While I'm not sure that this is a real problem
> with cifsd now, it could be at some point in the future if cifs_mount is
> ever changed to bring down the thread quickly.
>
> The upshot here is that using kthread_stop to bring down the thread just
> adds extra complexity with no real benefit. This patch changes the code
> to use the original method to bring down the thread, but still leaves it
> so that the thread is actually started with kthread_run.
>
> This seems to fix the deadlock caused by the reproducer in this bug
> report:
>
> https://bugzilla.samba.org/show_bug.cgi?id=5720

I agree with what Jeff is suggesting in this patch, and have no
problem merging the patch, but want to make sure that those who wanted
cifs to switch all of cifs threads to kthread usage are also ok with
this.

I don't like the patch 1 (disabling a section of code code) and 5
(basically reenabling similar code fixing some problems) though - has
to be a better way to do this by rewriting the function once.



-- 
Thanks,

Steve
