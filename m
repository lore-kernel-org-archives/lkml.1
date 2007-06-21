Return-Path: <linux-kernel-owner+w=401wt.eu-S1757531AbXFUQeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531AbXFUQeh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 12:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359AbXFUQeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 12:34:10 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:59455 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044AbXFUQeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 12:34:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fe0UW+E75z3G9LyiTfouS3pDIIsiqYyjgedLwK6r+KCKPo71WtKdHD6GeV79CiF73yhQaJ2J8ZdO+01u5a2z1/98Dd2EAbbZ7maD4I8hU6+4LgP+KTGzs8k0f5S4Gz247+v66nH7zE9FGAzgOzcDVEKhnaAd4VBelfd1iiVI/DQ=
Message-ID: <961aa3350706210934m11e7f0cq96f384056878cb43@mail.gmail.com>
Date: Fri, 22 Jun 2007 01:34:06 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Alexander Wuerstlein" <arw@arw.name>
Subject: Re: [PATCH] sns: add syscall to check signed state of a process [4/4]
Cc: linux-kernel@vger.kernel.org,
       "Johannes Schlumberger" <spjsschl@stud.informatik.uni-erlangen.de>
In-Reply-To: <11824417553291-git-send-email-arw@arw.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11824417553291-git-send-email-arw@arw.name>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/6/22, Alexander Wuerstlein <arw@arw.name>:

> +asmlinkage int sys_sns_is_trusted(pid_t p)
> +{
> +       struct task_struct *t;
> +       rcu_read_lock();
> +       t = find_task_by_pid(p);
> +       if (IS_ERR(t)) {

Shouldn't it be:
if (!t) {
        ...
?

find_task_by_pid() returns NULL on failure.

> +               rcu_read_unlock();
> +               return -EINVAL;
> +       }
> +       p = t->sns_valid_sig; /*locking needed*/
> +       rcu_read_unlock();
> +       return p;
> +}
