Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496AbZGUQDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbZGUQDI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 12:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754618AbZGUQDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 12:03:07 -0400
Received: from smtp-out.google.com ([216.239.45.13]:4159 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbZGUQDF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 12:03:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=cLco/x4Mg2GpO5Sa529SNQnLCXzHtBE46MxGKUJrRf9TcPW/iOao+d+PlsR2f/BG1
	m/Z1o+9k961XdW3+VaVWg==
MIME-Version: 1.0
In-Reply-To: <1248171926-20232-1-git-send-email-dfeng@redhat.com>
References: <1248171926-20232-1-git-send-email-dfeng@redhat.com>
Date: Tue, 21 Jul 2009 09:03:01 -0700
Message-ID: <6599ad830907210903q7206cac2l83a9139d19c5e1a@mail.gmail.com>
Subject: Re: [PATCH] cgroup: fix reverse unlock sequence in cgroup_get_sb
From: Paul Menage <menage@google.com>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: lizf@cn.fujitsu.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 3:25 AM, Xiaotian Feng<dfeng@redhat.com> wrote:
> In cgroup_get_sb, the lock sequence is:
>        mutex_lock(&inode->i_mutex);
>        mutex_lock(&cgroup->mutex);
> so the last unlock sequence should be:

Make this "so for consistency the last ..." ?

Maybe make the patch title "Make unlock sequence in cgroup_get_sb
consistent" so someone looking through the change logs for fixes to
backport doesn't wrongly thing that this fixes any bug"?

>        mutex_unlock(&cgroup->mutex);
>        mutex_unlock(&inode->i_mutex);
>
> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>

Acked-by: Paul Menage <menage@google.com>

Paul
