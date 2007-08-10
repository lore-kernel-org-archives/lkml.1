Return-Path: <linux-kernel-owner+w=401wt.eu-S941823AbXHJUmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941823AbXHJUmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 16:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933655AbXHJUmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 16:42:14 -0400
Received: from pat.uio.no ([129.240.10.15]:48538 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758882AbXHJUmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 16:42:13 -0400
Subject: Re: nfs - duplicate directory entries
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Vladimir Volovich <vvv@vsu.ru>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <87fy2rgpqs.fsf@vvv.vsu.ru>
References: <87fy2rgpqs.fsf@vvv.vsu.ru>
Content-Type: text/plain
Date: Fri, 10 Aug 2007 16:42:09 -0400
Message-Id: <1186778529.6642.52.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.079)
X-UiO-Scanned: 351061CC81A8278DF554A708579F66566F42EABD
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 192 total 3191830 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-10 at 23:21 +0400, Vladimir Volovich wrote:
> Hi!
> 
> we have an NFS server (windows-based), and mount a directory from this
> server on a linux box; there is some bug appearing sometimes, namely
> some of the directory entries are reported twice:
> 
> $ ls | wc
>    5968    5968   41776
> $ ls | uniq | wc
>    5964    5964   41748
> $ ls | uniq -d
> 112920
> 112921
> 112922
> 112923
> $ ls -li | grep '11292[0123]'
> 8507232 drwx------ 2 web web 64 2007-02-09 10:54 112920
> 8507232 drwx------ 2 web web 64 2007-02-09 10:54 112920
> 8507219 drwx------ 2 web web 64 2007-02-09 10:54 112921
> 8507219 drwx------ 2 web web 64 2007-02-09 10:54 112921
> 8507195 drwx------ 2 web web 64 2007-02-09 10:54 112922
> 8507195 drwx------ 2 web web 64 2007-02-09 10:54 112922
> 8507188 drwx------ 2 web web 64 2007-02-09 10:54 112923
> 8507188 drwx------ 2 web web 64 2007-02-09 10:54 112923
> 
> i.e. the current directory contains sub-directory 112920 twice,
> sub-directory 112921 twice, etc. - and the inode numbers are the same.

That can happen if the NFS server doesn't send unique cookies.

Trond

