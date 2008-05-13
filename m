Return-Path: <linux-kernel-owner+w=401wt.eu-S1761538AbYEMVIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761538AbYEMVIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 17:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758734AbYEMVHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 17:07:54 -0400
Received: from smtp-out.google.com ([216.239.33.17]:62771 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758525AbYEMVHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 17:07:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=FunrMpZ+qCi/8yhDcZ5/Q0VntJvLa9LVq8OoA5eHBT4dlfpuZVDC0w3auVOKSs18d
	lIvZwxM5/HUQSfuCGxgiQ==
Message-ID: <6599ad830805131407y3d94016cn773ba21a42b6098c@mail.gmail.com>
Date: Tue, 13 May 2008 14:07:40 -0700
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [RFC/PATCH 1/8]: CGroup Files: Add locking mode to cgroups control files
Cc: pj@sgi.com, xemul@openvz.org, balbir@in.ibm.com, serue@us.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
In-Reply-To: <48295E11.2000003@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080513063707.049448000@menage.corp.google.com>
	 <20080513071522.133586000@menage.corp.google.com>
	 <48295E11.2000003@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 2:23 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>  > +
>  > +/**
>  > + * cgroup_file_lock(). Helper for cgroup read/write methods.
>  > + * @cgrp:  the cgroup being acted on
>  > + * @cft:   the control file being written to or read from
>  > + * *write: true if the access is a write access.
>
>  s/*write/@write
>

Fixed.

>  > @@ -1518,16 +1580,21 @@ static ssize_t cgroup_file_read(struct f
>  >       struct cftype *cft = __d_cft(file->f_dentry);
>  >       struct cgroup *cgrp = __d_cgrp(file->f_dentry->d_parent);
>  >
>  > -     if (!cft || cgroup_is_removed(cgrp))
>  > +     if (cgroup_is_removed(cgrp))
>  >               return -ENODEV;
>  >
>
>  This check seems redundant now.
>

It's not needed for safety, but it doesn't seem to hurt to check
cgroup_is_removed() prior to doing any copying, since we'll fail after
copying anyway if cgroup_is_removed() returns true (once we've taken
any relevant locks).

Paul
